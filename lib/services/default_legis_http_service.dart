import 'dart:io';

import 'package:html/parser.dart';
import 'package:laws_browser/constants.dart';
import 'package:laws_browser/services/abstractions/legis_http_service.dart';
import 'package:laws_browser/models/common/code.dart';

import 'package:http/http.dart' as http;

class DefaultLegisHttpService implements LegisHttpService {
  @override
  Future<String?> downloadCode(Code code) async {
    var sessionCookie = await _getSessionCookie(code);

    if (sessionCookie == null) {
      return null;
    }

    var codeUrl = await _getCodeUrl(code, sessionCookie);

    if (codeUrl == null) {
      return null;
    }

    var docId = parseDocumentId(codeUrl);

    if (docId == null) {
      return null;
    }

    return await _fetchDocument(docId);
  }

  // Parse document ID from legis.md/getResults URL
  String? parseDocumentId(String codeUrl) {
    var docIdIndex = codeUrl.indexOf('doc_id');

    if (docIdIndex < 0) {
      return null;
    }

    docIdIndex = codeUrl.indexOf('=', docIdIndex);
    
    if (docIdIndex < 0) {
      return null;
    }

    var docIdEndIndex = codeUrl.indexOf(RegExp(r'[^a-zA-z0-9]'), ++docIdIndex);

    if (docIdEndIndex > 0) {
      return codeUrl.substring(docIdIndex, docIdEndIndex);
    }

    return null;
  }

  Future<String?> _fetchDocument(String docId) async {
    final fetchUri = Uri.https(Constants.baseLegisUrl, '/cautare/showdetails/$docId');
    final response = await http.get(fetchUri);

    if (response.statusCode != HttpStatus.ok) {
      return null;
    }

    return response.body;
  }

  
  // Make an AJAX search request to get a table with codes
  // Extract the necessary code by filtering it's search term
  Future<String?> _getCodeUrl(Code code, String sessionCookie) async {
    final queryParameters = { 'filter_title': code.searchTerm };
    final ajaxSearchUri = Uri.https(Constants.baseLegisUrl, '/cautare/getAjaxContent', queryParameters);
    final response = await http.get(ajaxSearchUri, headers: {'cookie': sessionCookie});

    if (response.statusCode != HttpStatus.ok) {
      return null;
    }

    final document = parse(response.body);
    final hrefElements = document
      .getElementsByTagName('a');
    final hrefTag = hrefElements
      .where((w) => w.text.replaceAll('\n', ' ').toLowerCase() == code.searchTerm.toLowerCase())
      .first;

    if (!hrefTag.attributes.containsKey('href')) {
      return null;
    }

    return hrefTag.attributes['href'];
  }

  // Make a request to Legis search to initiate session
  // Returns ci_session from the cookie
  Future<String?> _getSessionCookie(Code code) async {
    final queryParameters = {
      'document_status': '0',
      'tip[]': '39350',
      'search_type': '1',
      'search_string': code.searchTerm
    };
    var uri = Uri.https(Constants.baseLegisUrl, '/cautare/getResults', queryParameters);
    // https://www.legis.md/cautare/getResults?document_status=0&tip%5B%5D=39350&nr_doc=&datepicker1=&publication_status=+-+TOATE+-+&nr=&publish_date=&search_type=1&search_string=CODUL+PENAL+AL+REPUBLICII+MOLDOVA
    var response = await http.get(uri);

    if (response.statusCode != HttpStatus.ok) {
      return null;
    }

    response.headers.removeWhere((key, value) => value.contains('ci_session=deleted'));
    var cookieHeader = response.headers['set-cookie'];

    if (cookieHeader == null) { 
      return null;
    }

    var sessionIdIndex = cookieHeader.indexOf('ci_session');

    if (sessionIdIndex < 0) {
      return null;
    }

    var sessionId = cookieHeader.substring(sessionIdIndex, cookieHeader.indexOf(';'));

    return sessionId;
  }
}
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';

part 'model.g.dart';

const articlesTable = SqfEntityTable(
  tableName: 'articles',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: null,
  fields: [
    SqfEntityField('articleName', DbType.text, isNotNull: true),
    SqfEntityField('articleText', DbType.text, isNotNull: true)
  ]
);

const categoriesRelationTable = SqfEntityTable(
  tableName: 'categoriesRelations',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  fields: [
    SqfEntityFieldRelationship(parentTable: categoriesTable, fieldName: 'category' , deleteRule: DeleteRule.NO_ACTION, isPrimaryKeyField: true),
    SqfEntityFieldRelationship(parentTable: categoriesTable, fieldName: 'parent', deleteRule: DeleteRule.CASCADE),
    SqfEntityFieldRelationship(parentTable: categoriesTable, fieldName: 'children', relationType: RelationType.ONE_TO_MANY)
  ]
);

const categoriesTable = SqfEntityTable(
  tableName: 'categories',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  useSoftDeleting: false,
  modelName: null,
  fields: [
    SqfEntityField('name', DbType.text, isNotNull: true),
    SqfEntityField('parent', DbType.text, isNotNull: true),
    SqfEntityFieldRelationship(parentTable: articlesTable, fieldName: 'articles', deleteRule: DeleteRule.CASCADE, relationType: RelationType.ONE_TO_MANY )
  ]
);

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity'
);

@SqfEntityBuilder(lawsBrowserDbModel)
const lawsBrowserDbModel = SqfEntityModel(
  modelName: 'LawsBrowserDB',
  databaseName: 'lb.db',
  databaseTables: [categoriesTable, categoriesRelationTable, articlesTable],
  sequences: [seqIdentity],
  dbVersion: 2,
  bundledDatabasePath: null //         'assets/sample.db'
);
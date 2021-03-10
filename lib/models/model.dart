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
    SqfEntityField('articleText', DbType.text, isNotNull: true),
    SqfEntityFieldRelationship(parentTable: categoriesTable, fieldName: 'category', defaultValue: DeleteRule.NO_ACTION, relationType: RelationType.ONE_TO_MANY_VICEVERSA)
  ],
  formListSubTitleField: ''
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
    SqfEntityField('parent', DbType.text, isNotNull: true)
  ],
  formListSubTitleField: ''
);

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity'
);

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
    modelName: 'MyDbModel',
    databaseName: 'sampleORM_v1.4.0+3.db',
    password: null, // You can set a password if you want to use crypted database (For more information: https://github.com/sqlcipher/sqlcipher)
    // put defined tables into the tables list.
    databaseTables: [categoriesTable, categoriesRelationTable, articlesTable],
    // put defined sequences into the sequences list.
    sequences: [seqIdentity],
    dbVersion: 2,
    bundledDatabasePath: 'assets/lb.db' //         'assets/sample.db'
    );

// class Model {
//   int id;
//   String articleName;
//   String articleText;

//   int categoryId;

//   static const String tableName = 'Article';

//   Article({this.articleText, this.articleName}){
//     categoriesTable.fields.add()
//   }
// }
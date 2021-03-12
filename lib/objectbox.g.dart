// GENERATED CODE - DO NOT MODIFY BY HAND

// Currently loading model from "JSON" which always encodes with double quotes
// ignore_for_file: prefer_single_quotes
// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/objectbox.dart';
import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'models/entities/article.model.dart';
import 'models/entities/category.model.dart';

ModelDefinition getObjectBoxModel() {
  final model = ModelInfo.fromMap({
    "entities": [
      {
        "id": "1:5936671829527920407",
        "lastPropertyId": "4:4148164479105458252",
        "name": "Article",
        "properties": [
          {
            "id": "1:3017419998083312329",
            "name": "id",
            "type": 6,
            "flags": 1,
            "dartFieldType": "int?"
          },
          {
            "id": "2:4884888709601326896",
            "name": "articleName",
            "type": 9,
            "dartFieldType": "String?"
          },
          {
            "id": "3:8344413015670528839",
            "name": "articleText",
            "type": 9,
            "dartFieldType": "String?"
          },
          {
            "id": "4:4148164479105458252",
            "name": "categoryId",
            "type": 6,
            "dartFieldType": "int?"
          }
        ],
        "relations": [],
        "backlinks": [],
        "constructorParams": ["articleText named", "articleName named"],
        "nullSafetyEnabled": false
      },
      {
        "id": "2:6671118379599220207",
        "lastPropertyId": "3:2816847797330471055",
        "name": "Category",
        "properties": [
          {
            "id": "1:5068818080077751813",
            "name": "id",
            "type": 6,
            "flags": 1,
            "dartFieldType": "int?"
          },
          {
            "id": "2:1035646518518211126",
            "name": "name",
            "type": 9,
            "dartFieldType": "String?"
          },
          {
            "id": "3:2816847797330471055",
            "name": "parentId",
            "type": 11,
            "flags": 520,
            "indexId": "1:36218473582618149",
            "relationTarget": "Category",
            "dartFieldType": "ToOne?"
          }
        ],
        "relations": [
          {
            "id": "1:2744082653007183090",
            "name": "children",
            "targetId": "2:6671118379599220207",
            "targetName": "Category"
          },
          {
            "id": "2:4750951749375170642",
            "name": "articles",
            "targetId": "1:5936671829527920407",
            "targetName": "Article"
          }
        ],
        "backlinks": [],
        "constructorParams": ["name named"],
        "nullSafetyEnabled": false
      }
    ],
    "lastEntityId": "2:6671118379599220207",
    "lastIndexId": "1:36218473582618149",
    "lastRelationId": "2:4750951749375170642",
    "lastSequenceId": "0:0",
    "modelVersion": 5
  }, check: false);

  final bindings = <Type, EntityDefinition>{};
  bindings[Article] = EntityDefinition<Article>(
      model: model.getEntityByUid(5936671829527920407),
      toOneRelations: (Article object) => [],
      toManyRelations: (Article object) => {},
      getId: (Article object) => object.id,
      setId: (Article object, int id) {
        object.id = id;
      },
      objectToFB: (Article object, fb.Builder fbb) {
        final offsetarticleName = object.articleName == null
            ? null
            : fbb.writeString(object.articleName);
        final offsetarticleText = object.articleText == null
            ? null
            : fbb.writeString(object.articleText);
        fbb.startTable(5);
        fbb.addInt64(0, object.id ?? 0);
        fbb.addOffset(1, offsetarticleName);
        fbb.addOffset(2, offsetarticleText);
        fbb.addInt64(3, object.categoryId);
        fbb.finish(fbb.endTable());
        return object.id ?? 0;
      },
      objectFromFB: (Store store, Uint8List fbData) {
        final buffer = fb.BufferContext.fromBytes(fbData);
        final rootOffset = buffer.derefObject(0);

        final object = Article(
            articleText:
                fb.StringReader().vTableGetNullable(buffer, rootOffset, 8),
            articleName:
                fb.StringReader().vTableGetNullable(buffer, rootOffset, 6))
          ..id = fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4)
          ..categoryId =
              fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 10);

        return object;
      });
  bindings[Category] = EntityDefinition<Category>(
      model: model.getEntityByUid(6671118379599220207),
      toOneRelations: (Category object) => [object.parent],
      toManyRelations: (Category object) => {
            RelInfo<Category>.toMany(1, object.id): object.children,
            RelInfo<Category>.toMany(2, object.id): object.articles
          },
      getId: (Category object) => object.id,
      setId: (Category object, int id) {
        object.id = id;
      },
      objectToFB: (Category object, fb.Builder fbb) {
        final offsetname =
            object.name == null ? null : fbb.writeString(object.name);
        fbb.startTable(4);
        fbb.addInt64(0, object.id ?? 0);
        fbb.addOffset(1, offsetname);
        fbb.addInt64(2, object.parent.targetId);
        fbb.finish(fbb.endTable());
        return object.id ?? 0;
      },
      objectFromFB: (Store store, Uint8List fbData) {
        final buffer = fb.BufferContext.fromBytes(fbData);
        final rootOffset = buffer.derefObject(0);

        final object = Category(
            name: fb.StringReader().vTableGetNullable(buffer, rootOffset, 6))
          ..id = fb.Int64Reader().vTableGetNullable(buffer, rootOffset, 4);
        object.parent.targetId =
            fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);
        object.parent.attach(store);
        InternalToManyAccess.setRelInfo(object.children, store,
            RelInfo<Category>.toMany(1, object.id), store.box<Category>());
        InternalToManyAccess.setRelInfo(object.articles, store,
            RelInfo<Category>.toMany(2, object.id), store.box<Category>());
        return object;
      });

  return ModelDefinition(model, bindings);
}

class Article_ {
  static final id =
      QueryIntegerProperty(entityId: 1, propertyId: 1, obxType: 6);
  static final articleName =
      QueryStringProperty(entityId: 1, propertyId: 2, obxType: 9);
  static final articleText =
      QueryStringProperty(entityId: 1, propertyId: 3, obxType: 9);
  static final categoryId =
      QueryIntegerProperty(entityId: 1, propertyId: 4, obxType: 6);
}

class Category_ {
  static final id =
      QueryIntegerProperty(entityId: 2, propertyId: 1, obxType: 6);
  static final name =
      QueryStringProperty(entityId: 2, propertyId: 2, obxType: 9);
  static final parent = QueryRelationProperty<Category, Category>(
      targetEntityId: 2, sourceEntityId: 2, propertyId: 3, obxType: 11);
  static final children = QueryRelationMany<Category, Category>(
      sourceEntityId: 2, targetEntityId: 2, relationId: 1);
  static final articles = QueryRelationMany<Category, Article>(
      sourceEntityId: 2, targetEntityId: 1, relationId: 2);
}

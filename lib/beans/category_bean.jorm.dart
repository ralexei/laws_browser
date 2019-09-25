// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_bean.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _CategoryBean implements Bean<Category> {
  final id = IntField('id');
  final name = StrField('name');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
      };
  Category fromMap(Map map) {
    Category model = Category();
    model.id = adapter.parseValue(map['id']);
    model.name = adapter.parseValue(map['name']);

    return model;
  }

  List<SetColumn> toSetColumns(Category model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, isNullable: false);
    st.addStr(name.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Category model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      Category newModel;
      if (model.articles != null) {
        newModel ??= await find();
        model.articles
            .forEach((x) => articleBean.associateCategory(x, newModel));
        for (final child in model.articles) {
          await articleBean.insert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<Category> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(insert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = models
          .map((model) =>
              toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
          .toList();
      final InsertMany insert = inserters.addAll(data);
      await adapter.insertMany(insert);
      return;
    }
  }

  Future<dynamic> upsert(Category model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      Category newModel;
      if (model.articles != null) {
        newModel ??= await find();
        model.articles
            .forEach((x) => articleBean.associateCategory(x, newModel));
        for (final child in model.articles) {
          await articleBean.upsert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<Category> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(upsert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      }
      final UpsertMany upsert = upserters.addAll(data);
      await adapter.upsertMany(upsert);
      return;
    }
  }

  Future<void> updateMany(List<Category> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(update(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      final List<Expression> where = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
        where.add(null);
      }
      final UpdateMany update = updaters.addAll(data, where);
      await adapter.updateMany(update);
      return;
    }
  }

  Future<Category> preload(Category model, {bool cascade = false}) async {
    model.articles = await articleBean.findByCategory(model.id,
        preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<Category>> preloadAll(List<Category> models,
      {bool cascade = false}) async {
    models.forEach((Category model) => model.articles ??= []);
    await OneToXHelper.preloadAll<Category, Article>(
        models,
        (Category model) => [model.id],
        articleBean.findByCategoryList,
        (Article model) => [model.categoryId],
        (Category model, Article child) =>
            model.articles = List.from(model.articles)..add(child),
        cascade: cascade);
    return models;
  }

  ArticleBean get articleBean;
}

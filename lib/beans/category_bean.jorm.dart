// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_bean.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _CategoryBean implements Bean<Category> {
  final id = IntField('id');
  final name = StrField('name');
  final parentId = IntField('parent_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        parentId.name: parentId,
      };
  Category fromMap(Map map) {
    Category model = Category();
    model.id = adapter.parseValue(map['id']);
    model.name = adapter.parseValue(map['name']);
    model.parentId = adapter.parseValue(map['parent_id']);

    return model;
  }

  List<SetColumn> toSetColumns(Category model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      ret.add(name.set(model.name));
      ret.add(parentId.set(model.parentId));
    } else if (only != null) {
      if (model.id != null) {
        if (only.contains(id.name)) ret.add(id.set(model.id));
      }
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(parentId.name)) ret.add(parentId.set(model.parentId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
      if (model.parentId != null) {
        ret.add(parentId.set(model.parentId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, autoIncrement: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    st.addInt(parentId.name,
        foreignTable: categoryBean.tableName,
        foreignCol: 'id',
        isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Category model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.insert(insert);
    if (cascade) {
      Category newModel;
      if (model.children != null) {
        newModel ??= await find(retId);
        model.children
            .forEach((x) => categoryBean.associateCategory(x, newModel));
        for (final child in model.children) {
          await categoryBean.insert(child, cascade: cascade);
        }
      }
      if (model.articles != null) {
        newModel ??= await find(retId);
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
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      Category newModel;
      if (model.children != null) {
        newModel ??= await find(retId);
        model.children
            .forEach((x) => categoryBean.associateCategory(x, newModel));
        for (final child in model.children) {
          await categoryBean.upsert(child, cascade: cascade);
        }
      }
      if (model.articles != null) {
        newModel ??= await find(retId);
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

  Future<int> update(Category model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      Category newModel;
      if (model.children != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.children
              .forEach((x) => categoryBean.associateCategory(x, newModel));
        }
        for (final child in model.children) {
          await categoryBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
      if (model.articles != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.articles
              .forEach((x) => articleBean.associateCategory(x, newModel));
        }
        for (final child in model.articles) {
          await articleBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
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
        where.add(this.id.eq(model.id));
      }
      final UpdateMany update = updaters.addAll(data, where);
      await adapter.updateMany(update);
      return;
    }
  }

  Future<Category> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final Category model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final Category newModel = await find(id);
      if (newModel != null) {
        await categoryBean.removeByCategory(newModel.id);
        await articleBean.removeByCategory(newModel.id);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Category> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<Category>> findByCategory(int parentId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.parentId.eq(parentId));
    final List<Category> models = await findMany(find);
    if (preload) {
      await this.preloadAll(models, cascade: cascade);
    }
    return models;
  }

  Future<List<Category>> findByCategoryList(List<Category> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Category model in models) {
      find.or(this.parentId.eq(model.id));
    }
    final List<Category> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByCategory(int parentId) async {
    final Remove rm = remover.where(this.parentId.eq(parentId));
    return await adapter.remove(rm);
  }

  void associateCategory(Category child, Category parent) {
    child.parentId = parent.id;
  }

  Future<Category> preload(Category model, {bool cascade = false}) async {
    model.children = await categoryBean.findByCategory(model.id,
        preload: cascade, cascade: cascade);
    model.articles = await articleBean.findByCategory(model.id,
        preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<Category>> preloadAll(List<Category> models,
      {bool cascade = false}) async {
    models.forEach((Category model) => model.children ??= []);
    await OneToXHelper.preloadAll<Category, Category>(
        models,
        (Category model) => [model.id],
        categoryBean.findByCategoryList,
        (Category model) => [model.parentId],
        (Category model, Category child) =>
            model.children = List.from(model.children)..add(child),
        cascade: cascade);
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

  CategoryBean get categoryBean;
  ArticleBean get articleBean;
}

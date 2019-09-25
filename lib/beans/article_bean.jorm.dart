// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_bean.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _ArticleBean implements Bean<Article> {
  final id = IntField('id');
  final articleName = StrField('article_name');
  final articleText = StrField('article_text');
  final categoryId = IntField('category_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        articleName.name: articleName,
        articleText.name: articleText,
        categoryId.name: categoryId,
      };
  Article fromMap(Map map) {
    Article model = Article();
    model.id = adapter.parseValue(map['id']);
    model.articleName = adapter.parseValue(map['article_name']);
    model.articleText = adapter.parseValue(map['article_text']);
    model.categoryId = adapter.parseValue(map['category_id']);

    return model;
  }

  List<SetColumn> toSetColumns(Article model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      ret.add(articleName.set(model.articleName));
      ret.add(articleText.set(model.articleText));
      ret.add(categoryId.set(model.categoryId));
    } else if (only != null) {
      if (model.id != null) {
        if (only.contains(id.name)) ret.add(id.set(model.id));
      }
      if (only.contains(articleName.name))
        ret.add(articleName.set(model.articleName));
      if (only.contains(articleText.name))
        ret.add(articleText.set(model.articleText));
      if (only.contains(categoryId.name))
        ret.add(categoryId.set(model.categoryId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.articleName != null) {
        ret.add(articleName.set(model.articleName));
      }
      if (model.articleText != null) {
        ret.add(articleText.set(model.articleText));
      }
      if (model.categoryId != null) {
        ret.add(categoryId.set(model.categoryId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, autoIncrement: true, isNullable: false);
    st.addStr(articleName.name, isNullable: false);
    st.addStr(articleText.name, isNullable: false);
    st.addInt(categoryId.name,
        foreignTable: categoryBean.tableName,
        foreignCol: 'id',
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Article model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.insert(insert);
    if (cascade) {
      Article newModel;
    }
    return retId;
  }

  Future<void> insertMany(List<Article> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(Article model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      Article newModel;
    }
    return retId;
  }

  Future<void> upsertMany(List<Article> models,
      {bool onlyNonNull = false, Set<String> only}) async {
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

  Future<int> update(Article model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<Article> models,
      {bool onlyNonNull = false, Set<String> only}) async {
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

  Future<Article> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(int id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Article> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<Article>> findByCategory(int categoryId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.categoryId.eq(categoryId));
    return findMany(find);
  }

  Future<List<Article>> findByCategoryList(List<Category> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Category model in models) {
      find.or(this.categoryId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByCategory(int categoryId) async {
    final Remove rm = remover.where(this.categoryId.eq(categoryId));
    return await adapter.remove(rm);
  }

  void associateCategory(Article child, Category parent) {
    child.categoryId = parent.id;
  }

  CategoryBean get categoryBean;
}

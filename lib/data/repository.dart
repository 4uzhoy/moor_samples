import 'package:moor_samples/database/database.dart';
import 'package:moor_samples/database/dao/products_dao.dart';

class Repository {
  Database _database;

  /// Открываем соединение
  Future<void> init() async {
    print("init");
    _database = await Database.open();

    if (_database.allTables.isNotEmpty) {
      print('Очищаем таблицы и удаляем');
      for (Table t in _database.allTables) {
        print('-очищается таблица ${t.runtimeType}');
        await _database.delete(t).go();

      }
      print('Очистка завершена');
    }
  }

  Future<void> insertData() async {
    await _insertBrand();
    await _insertCategory();
    await _insertProduct();
    //  await _insertCustomer();
  }

  Future<void> _insertBrand() async {
    print('Start inserting');
    await _database.transaction(() async {
      await _database.into(_database.brandsTable).insertOnConflictUpdate(
          BrandsTableCompanion.insert(name: 'Кока-Кола'));
    });
  }

  Future<void> _insertCategory() async {
    print('Start inserting');
    await _database.transaction(() async {
      await _database.into(_database.categoriesTable).insertOnConflictUpdate(
          CategoriesTableCompanion.insert(name: 'Напитки'));
    });
  }

  Future<void> _insertProduct() async {
    final category = await (_database.select(_database.categoriesTable)
          ..where((filter) => filter.name.equals('Напитки')))
        .getSingle();

    final brand = await (_database.select(_database.brandsTable)
          ..where((filter) => filter.name.equals('Кока-Кола')))
        .getSingle();

    await _database.transaction(() async {
      await _database.into(_database.productsTable).insertOnConflictUpdate(
          ProductsTableCompanion.insert(
              name: 'Кока-Кола 1.75л',
              quantity: 7,
              categoryId: Value(category.id),
              brandId: Value(brand.id)));
    });
  }

  Future<void> _insertCustomer() async {
    await _database.transaction(() async {
      await _database
          .into(_database.customersTable)
          .insertOnConflictUpdate(CustomersTableCompanion.insert(
            firstName: 'Иван',
            lastName: 'Васильев',
          ));
      await _database
          .into(_database.customersTable)
          .insertOnConflictUpdate(CustomersTableCompanion.insert(
            firstName: 'Василий',
            lastName: 'Иванов',
          ));
    });
  }

  /// читаем ProductWithCategoryAndBrand с помощью дао
  Future<String> readProductsWithDaoWithJoin() async {
    final ProductDao _productDao = ProductDao(_database);

    print('читаем ProductWithCategoryAndBrand с помощью дао');
    List<ProductWithCategoryAndBrand> _entrys =
        await _productDao.getAllProducts();

    return _entrys.toString();
  }

  /// читаем ProductEntry с помощью дао простым запросом
  Future<String> readProductsWithDaoSimpleWay() async {
    final ProductDao _productDao = ProductDao(_database);

    print('читаем ProductEntry с помощью дао простым запросом');
    List<ProductEntry> _entrys =
    await _productDao.getAllProductsSimple();

    return _entrys.toString();
  }

  /// читаем ProductEntry с помощью дао сырым запросом
  Future<String> readProductsWithDaoRawQueryWay() async {
    final ProductDao _productDao = ProductDao(_database);

    print('читаем ProductEntry с помощью дао сырым запросом');
    List<ProductEntry> _entrys =
    await _productDao.getAllProductsWithRawSelect();

    return _entrys.toString();
  }

  /// читаем ProductEntry с помощью сгенерированного аннотацией бд запроса
  /// который возвращает [Selectable<ProductEntry>]
  Future<String> readProductsWithDbAnnotationMethodWay() async {

    print('читаем ProductEntry с помощью сгенерированного аннотацией бд запроса');
    List<ProductEntry> _entrys =
    await _database.getAllProductsMethodFromDatabaseAnnotation().get();

    return _entrys.toString();
  }

  /// читаем продукты по тупому транзакциями и подставляя имя категории
  /// и имя бренда по айди в продукте
  Future<String> readProductsSimpleStupid() async {
    print('читаем ProductEntity по тупому');

    var _entitys = [];
    await _database.transaction<void>(() async {
      final products = await (_database.select(_database.productsTable)
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();
      if (products == null) return [];
      print('products length ${products.length}');

      for (var product in products) {
        print('Call loop iteration');
        final category = await (_database.select(_database.categoriesTable)
              ..where((filter) => filter.id.equals(product.categoryId)))
            .getSingle();
        final brand = await (_database.select(_database.brandsTable)
              ..where((filter) => filter.id.equals(product.brandId)))
            .getSingle();

        _entitys.add(ProductEntity(product.id,
            name: product.name,
            quantity: product.quantity,
            brand: brand.name,
            category: category.name));
      }
    });
    print('_entitys length ${_entitys.length}');
    return _entitys.toString();
  }
}

class ProductEntity {
  int id;
  String name;
  int quantity;
  String brand;
  String category;

  ProductEntity(this.id,
      {@required this.name,
      @required this.quantity,
      @required this.brand,
      @required this.category});

  @override
  String toString() {
    return 'ProductEntity{id: $id, name: $name, quantity: $quantity, brand: $brand, category: $category}\n';
  }
}

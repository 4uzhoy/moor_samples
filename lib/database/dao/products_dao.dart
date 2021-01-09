import 'package:moor/moor.dart';
import 'package:moor_samples/database/tables/products_table.dart';

import '../database.dart';

part 'products_dao.g.dart';

@UseDao(tables: [ProductsTable])
class ProductDao extends DatabaseAccessor<Database> with _$ProductDaoMixin {
  ProductDao(this.database) : super(database);
  final Database database;

  ///Получение записей из таблицы [productTable],[categoriesTable],[brandsTable]
  ///и присвоение результатов к [ProductWithCategoryAndBrand]
  Future<List<ProductWithCategoryAndBrand>> getAllProducts() async {
    final _query = await select(productsTable).join([
      innerJoin(database.categoriesTable,
          database.categoriesTable.id.equalsExp(productsTable.categoryId)),
      innerJoin(database.brandsTable,
          database.brandsTable.id.equalsExp(productsTable.brandId))
    ]).get();

    ///парсинг ответа
    return _query.map((row) {
      return ProductWithCategoryAndBrand(
          row.readTable(productsTable),
          row.readTable(database.categoriesTable),
          row.readTable(database.brandsTable));
    }).toList();
  }

  ///Получение записей из таблицы [productTable] как они там записаны
  Future<List<ProductEntry>> getAllProductsSimple() =>
      select(productsTable).get();

  ///Получение записей из таблицы [productTable] как они там записаны, но при помощи
  ///сырого SQL запроса, и преобразования ответа запроса к ProductEntry
  Future<List<ProductEntry>> getAllProductsWithRawSelect() async {
    final _query =
        await customSelect('SELECT * FROM products_table').get();

    ///парсинг ответа
    return _query
        .map((row) => ProductEntry.fromData(row.data, database))
        .toList();
  }

}

class ProductWithCategoryAndBrand {
  ProductEntry productEntry;
  CategoryEntry categoryEntry;
  BrandEntry brandEntry;

  ProductWithCategoryAndBrand(
      this.productEntry, this.categoryEntry, this.brandEntry);

  @override
  String toString() {
    return 'ProductWithCategoryAndBrand{productEntry: $productEntry, categoryEntry: $categoryEntry, brandEntry: $brandEntry}';
  }
}

Пример работы с [Moor](https://moor.simonbinder.eu/) библиотекой 

1. перед началом необходимо сгенерировать файлы 
при помощи
 `pub run build_runner build --delete-conflicting-outputs`

2. указать метод `main*` в `bin\moor_samples.dart` как запускной

`*)`
  ```dart
import 'package:moor_samples/moor_samples.dart' as moor_samples;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main(List<String> arguments) {
  sqfliteFfiInit();
  moor_samples.runConsoleApp();
}
```
`sqfliteFfiInit` из `package:sqflite_common_ffi`
 необходим для загрузки библиотеки sqlite3.dll (запуск на Windows)


Сценарий `moor_samples.runConsoleApp()`
1. Создает базу данных 
2. Запускает удаление всех таблиц если они созданы 
3. Инициирует вставку категории, бренда, товара
4. Разными способами читает данные из базы


---
Файл `tables.moor`
используется в аннотации к созданию бд, 
так же можно писать сырые запросы, указывать таблицы и дао
```dart
@UseMoor(include: {
  'tables.moor'
}, queries: {
  'categoriesWithCount':
      'SELECT *, (SELECT COUNT(*) FROM todos WHERE category = c.id) AS "amount" FROM categories c;',

  /// запрос 'SELECT *' на наши продукты
  'getAllProductsMethodFromDatabaseAnnotation':
    'SELECT * FROM products_table;',

}, tables: [
  BrandsTable,
  ProductsTable,
  CustomersTable,
  CategoriesTable,
], daos: [
  ProductDao
])
```
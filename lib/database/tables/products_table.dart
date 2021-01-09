import 'package:moor/moor.dart';

@DataClassName('ProductEntry')
class ProductsTable extends Table {
  Index get tableAndIDIndex => Index('table_and_id_idx',
      'CREATE INDEX IF NOT EXISTS `table_idx` ON `$tableName` (`table`, `id`);');

  IntColumn get id => integer().autoIncrement()();


  TextColumn get name => text().withLength(min: 1, max: 64)();

/*  @override
  List<String> get customConstraints =>[

  ];*/

  IntColumn  get categoryId => integer().nullable()
      .customConstraint('NULLABLE REFERENCES categories_table(id)')();
  IntColumn get brandId => integer().nullable()
      .customConstraint('NULLABLE REFERENCES brands_table(id)')();
  IntColumn get quantity => integer()();
}

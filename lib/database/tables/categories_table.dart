import 'package:moor/moor.dart';

@DataClassName('CategoryEntry')
class CategoriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 64)();

}

import 'package:moor/moor.dart';

@DataClassName('BrandEntry')
class BrandsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 64)();


}

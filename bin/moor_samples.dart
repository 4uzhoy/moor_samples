import 'package:moor_samples/moor_samples.dart' as moor_samples;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main(List<String> arguments) {
  sqfliteFfiInit();
  moor_samples.runConsoleApp();
}

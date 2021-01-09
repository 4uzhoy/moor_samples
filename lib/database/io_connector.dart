import 'dart:async';
import 'dart:io' as io;

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

import 'package:path/path.dart' as p;

/// Открыть ленивый коннект с бд (инициализация при первом обращении)
LazyDatabase openConnectionLazy() => LazyDatabase(openConnection);

/// Открыть соединение с бд из файла
FutureOr<QueryExecutor> openConnection() async {
  print('Открываем соединение из файла');
  final dbFolder = io.Directory.current.absolute;
  print('дбФолдер $dbFolder');
  final file = io.File(p.join(dbFolder.path, 'db.sqlite'));
/*  if (!file.existsSync()) {
    print('дбФайл $file не сущесствует, создаем его');
    file.createSync();
  }*/
  print('дбФайл $file');
  return VmDatabase(file, logStatements: true);
}


import 'package:moor_samples/data/repository.dart';

///Исполнение приложения
void runConsoleApp() async {
  String _query1 = '<not executed query1>';
  String _query2 = '<not executed query2>';
  String _query3 = '<not executed query3>';
  var repository = Repository();
  print('Инициализируем репозиторий');
  await repository.init();
  print('\n\n');
  await repository.insertData();
  print('\n\n');
  print(await repository.readProductsSimpleStupid());
  print('\n\n');
  _query1 = await repository.readProductsWithDaoRawQueryWay();
  print(_query1);
  print('\n\n');
  _query2 = await repository.readProductsWithDaoSimpleWay();
  print(_query2);
  print('\n\n');
  _query3 = await repository.readProductsWithDbAnnotationMethodWay();
  print(_query3);
  print('\n\n');
  print(
      'readProductsWithDaoRawQueryWay AND readProductsWithDaoSimpleWay is equal result query\'s? ${_query2 == _query1}');
  print(
      'readProductsWithDaoSimpleWay AND readProductsWithDbAnnotationMethodWay is equal result query\'s? ${_query2 == _query3}');
  print('readProductsWithDaoRawQueryWay AND'
      ' readProductsWithDaoSimpleWay AND'
      ' readProductsWithDbAnnotationMethodWay is equal result query\'s? ${_query1 == _query2 && _query2 == _query3}');
  print('\n\n');
  print(await repository.readProductsWithDaoWithJoin());
}
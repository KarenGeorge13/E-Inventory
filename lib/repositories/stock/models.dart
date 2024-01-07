import 'package:hive/hive.dart';
part 'models.g.dart';

@HiveType(typeId: 0)
class Catalog extends HiveObject{
  @HiveField(0)
  String name;

  @HiveField(1)
  String? description;

  @HiveField(2)
  String responsible;

  Catalog({
    this.name = 'Название',
    this.description = 'Описание',
    this.responsible='Иванов И.И.',
  });
}

@HiveType(typeId: 2)
class Thing extends HiveObject{
  @HiveField(0)
  String name;

  @HiveField(1)
  String number;

  @HiveField(2)
  String? description;

  @HiveField(3)
  int catalogId;

  @HiveField(4)
  String? imagePath;

  Thing({
    this.name = 'Название',
    this.number = '1',
    this.catalogId = 0,
    this.description = '',
    this.imagePath = '',
  });
}
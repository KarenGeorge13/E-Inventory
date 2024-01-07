import 'package:stock/features/catalog_detail/catalog_detail.dart';
import 'package:stock/features/catalogs_list/catalogs_list.dart';
import 'package:stock/features/catalog_add/catalog_add.dart';
import 'package:stock/features/thing_add/thing_add.dart';
import 'package:stock/features/thing_detail/thing_detail.dart';

final routes = {
  '/': (context) => const CatalogListPage(title: 'Инвентарь'),
  '/catalog-detail': (context) => const CatalogDetailPage(title: 'Каталог'),
  '/catalog-add': (context) => const CatalogAddPage(title: 'Добавление каталога'),
  '/thing-add': (context) => const ThingAddPage(title: 'Добавление предмета'),
  '/thing-detail': (context) => const ThingDetailPage(title: 'Предмет'),
};
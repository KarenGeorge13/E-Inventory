import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stock/repositories/stock/models.dart';

class CatalogListView extends StatelessWidget {
  const CatalogListView({
    super.key,
    required this.catalogs,
    required this.refresh,
  });

  final List<Catalog> catalogs;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: catalogs.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index){
        return CatalogListTile(catalog: catalogs[index], refresh: refresh);
      }
    );
  }
}

class CatalogListTile extends StatelessWidget {
  final Catalog catalog;
  final Function refresh;

  const CatalogListTile({
    super.key,
    required this.catalog,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    String description = catalog.description!.isEmpty
        ? 'Пустое описание'
        : catalog.description.toString().split('\n')[0];
    if(description.length > 36){
      description = '${description.substring(0, 36)}...';
    }
    return ListTile(
      title: Text(
        catalog.name,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      subtitle: Text(
        description,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      onTap: (){
        Navigator.of(context).pushNamed(
          '/catalog-detail',
          arguments: {
            'catalogId': catalog.key,
          },
        ).then((value) => refresh());
      },
    );
  }
}
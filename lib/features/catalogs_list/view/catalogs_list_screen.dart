import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stock/features/catalogs_list/widgets/widgets.dart';
import 'package:stock/repositories/stock/models.dart';


class CatalogListPage extends StatefulWidget {
  const CatalogListPage({super.key, required this.title});
  final String title;

  @override
  State<CatalogListPage> createState() => _CatalogListPageState();
}

class _CatalogListPageState extends State<CatalogListPage> {

  void _refresh(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    Box<Catalog> catalogBox = Hive.box<Catalog>('catalog_box');
    final catalogs = catalogBox.values.map((catalog) {
      return catalog;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: CatalogListView(catalogs: catalogs, refresh: _refresh),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed(
            '/catalog-add',
          ).then((_) => setState(() { }));
          // setState(() {
          //   Box<Thing> catalogBox = Hive.box<Thing>('thing_box');
          //   final l = catalogBox.values.map((e) => e.key).toList();
          //   catalogBox.deleteAll(l);
          // });
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}




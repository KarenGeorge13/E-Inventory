import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stock/features/catalog_detail/widgets/things_list_view.dart';
import 'package:stock/repositories/stock/models.dart';

class CatalogDetailPage extends StatefulWidget {
  const CatalogDetailPage({super.key, required this.title});
  final String title;

  @override
  State<CatalogDetailPage> createState() => _CatalogDetailPageState();
}

class _CatalogDetailPageState extends State<CatalogDetailPage> {
  int? catalogId;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    catalogId = (args as Map)['catalogId'];
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _refresh(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    Box<Catalog> catalogBox = Hive.box<Catalog>('catalog_box');
    Box<Thing> thingBox = Hive.box<Thing>('thing_box');
    final catalog = catalogBox.get(catalogId);
    final things = thingBox.values.map((thing) {
      return thing;
    }).where((element) => element.catalogId == catalog?.key).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed(
                '/catalog-add',
                arguments: {
                  "catalog": catalog,
                  "title": 'Изменение каталога',
                },
              ).then((_) => setState(() { }));
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () async {
              bool result = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Удаление'),
                    content: Text('Вы точно хотите удалить каталог?'),
                    actions: <Widget>[
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop(false);
                        },
                        child: Text('Нет'),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop(true);
                        },
                        child: Text('Да'),
                      ),
                    ],
                  );
                },
              );
              if(result){
                Box<Catalog> thingBox = Hive.box<Catalog>('catalog_box');
                thingBox.delete(catalog?.key);
                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              catalog!.name,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Ответственный: ${catalog.responsible}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            Text(
              catalog.description.toString(),
              style: Theme.of(context).textTheme.labelMedium,
            ),

            const SizedBox(height: 10),
            Expanded(
              child: ThingListView(things: things, refresh: _refresh),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed(
            '/thing-add',
            arguments: {
              'catalogId': catalogId,
            }
          ).then((_) => setState(() { }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
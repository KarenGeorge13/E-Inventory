import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stock/features/catalog_detail/widgets/things_list_view.dart';
import 'package:stock/repositories/stock/models.dart';

class ThingDetailPage extends StatefulWidget {
  const ThingDetailPage({super.key, required this.title});
  final String title;

  @override
  State<ThingDetailPage> createState() => _ThingDetailPageState();
}

class _ThingDetailPageState extends State<ThingDetailPage> {
  int? thingId;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    thingId = (args as Map)['thingId'];
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _refresh(){
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    Box<Thing> thingBox = Hive.box<Thing>('thing_box');
    final thing = thingBox.get(thingId);
    // thing = thingBox.get(thing?.key);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.of(context).pushNamed(
                '/thing-add',
                arguments: {
                  "catalogId": thing!.catalogId,
                  "thing": thing,
                  "title": 'Изменение предмета',
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
                    content: Text('Вы точно хотите удалить предмет?'),
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
                Box<Thing> thingBox = Hive.box<Thing>('thing_box');
                thingBox.delete(thing?.key);
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
              thing!.name,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            Text(
              thing.number,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            Text(
              thing.description!.isEmpty
                  ? 'Описание отсутствует'
                  : thing.description.toString(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 10),
            thing.imagePath!.isEmpty
                ? Text('Изображение отсутствует')
                : Image.file(File(thing.imagePath.toString()), height: 300,),
          ],
        ),
      ),
    );
  }
}
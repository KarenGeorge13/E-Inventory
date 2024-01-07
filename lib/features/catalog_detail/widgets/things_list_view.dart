import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stock/repositories/stock/models.dart';

class ThingListView extends StatelessWidget {
  const ThingListView({
    super.key,
    required this.things,
    required this.refresh,
  });

  final Function refresh;
  final List<Thing> things;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: things.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index){
          return ThingListTile(thing: things[index], refresh: refresh,);
        }
    );
  }
}

class ThingListTile extends StatelessWidget {
  final Thing thing;
  final Function refresh;

  const ThingListTile({
    super.key,
    required this.thing,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    String description = thing.description!.isEmpty
        ? 'Пустое описание'
        : thing.description.toString().split('\n')[0];
    print(description);
    if(description.length > 36){
      description = '${description.substring(0, 36)}...';
    }
    return ListTile(
      title: Text(
        '${thing.number}: ${thing.name}',
        style: Theme.of(context).textTheme.labelMedium,
      ),
      subtitle: Text(
        description,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      onTap: (){
        Navigator.of(context).pushNamed(
          '/thing-detail',
          arguments: {
            "thingId": thing.key,
          },
        ).then((value) => refresh());
      },
    );
  }
}
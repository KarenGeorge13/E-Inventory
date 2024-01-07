import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock/features/catalogs_list/widgets/widgets.dart';
import 'package:stock/repositories/stock/models.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class ThingAddPage extends StatefulWidget {
  const ThingAddPage({super.key, required this.title});
  final String title;

  @override
  State<ThingAddPage> createState() => _ThingAddPageState();
}

class _ThingAddPageState extends State<ThingAddPage> {
  Thing? thing;
  int? catalogId;
  String? title;

  String? name;
  String? number;
  String? description;
  String? imagePath;

  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    title = widget.title;
    name = '';
    number = '';
    description = '';
    imagePath = '';
    if (args != null){
      catalogId = (args as Map)['catalogId'];
      thing = (args as Map)['thing'];
      if(thing != null){
        name = thing?.name;
        number = thing?.number;
        description = thing?.description;
        imagePath = thing?.imagePath;
      }
      if((args as Map)['title'] != null){
        title = (args as Map)['title'];
      }
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title.toString()),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 15),
                  TextFormField(
                    initialValue: name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.deepPurple, width: 5.0),
                      ),
                      labelText: 'Название',
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    validator: (val) {
                      return val!.trim().isEmpty
                          ? 'Введите название'
                          : null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    initialValue: number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.deepPurple, width: 5.0),
                      ),
                      labelText: 'Номер',
                    ),
                    onChanged: (value) {
                      setState(() {
                        number = value;
                      });
                    },
                    validator: (val) {
                      return _validateNumber(val);
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    initialValue: description,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(color: Colors.deepPurple, width: 5.0),
                      ),
                      labelText: 'Описание',
                    ),
                    onChanged: (value) {
                      setState(() {
                        description = value;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  imagePath!.isEmpty
                      ? Text('Выберите изображение')
                      : Image.file(File(imagePath!), height: 300,),
                  const SizedBox(height: 15),
                  FilledButton(
                      onPressed: () {
                        _getImage();
                      },
                      child: Text('Загрузить изображение')
                  ),
                  const SizedBox(height: 15),
                  FilledButton(
                      onPressed: _validateAndSave,
                      child: Text('Сохранить')
                  )
                ],
              ),
            ),
          ),
        ) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _copyImageToAppDirectory(File image) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    String fileName = image.path.split('/').last;
    File newImage = await image.copy('$appDocPath/$fileName');
    imagePath = newImage.path;
    print('Image copied to: $appDocPath/$fileName');
  }

  Future _getImage() async{
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        final image = File(pickedFile.path);
        _copyImageToAppDirectory(image);
      } else {
        print('No image selected.');
      }
    });
  }

  String? _validateNumber(val){
    if(val!.trim().isEmpty){
      return 'Укажите номер';
    }
    if(val == thing?.number){
      return null;
    }
    Box<Thing> thingBox = Hive.box<Thing>('thing_box');
    final things = thingBox.values.map((thing) {return thing;})
        .where((element) => element.catalogId == catalogId)
        .where((element) => element.number == val)
        .toList();
    if(things.isNotEmpty){
      return 'Номер должен быть уникальным';
    }
    return null;
  }

  void _validateAndSave(){
    final form = _formKey.currentState;
    if (form!.validate()) {
      Box<Thing> thingBox = Hive.box<Thing>('thing_box');
      final thingField = Thing(
        name: name.toString(),
        number: number.toString(),
        description: description == null ? '' : description.toString(),
        imagePath: imagePath == null ? '' : imagePath.toString(),
        catalogId: catalogId!.toInt(),
      );
      if(thing == null){
        thingBox.add(thingField);
      }
      else{
        thingBox.put(thing?.key, thingField);
      }

      Navigator.of(context).pop();
    } else {
      print('form is invalid');
    }
  }
}




import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stock/features/catalogs_list/widgets/widgets.dart';
import 'package:stock/repositories/stock/models.dart';


class CatalogAddPage extends StatefulWidget {
  const CatalogAddPage({super.key, required this.title});
  final String title;

  @override
  State<CatalogAddPage> createState() => _CatalogAddPageState();
}

class _CatalogAddPageState extends State<CatalogAddPage> {
  Catalog? catalog;
  String? title;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    title = widget.title;
    if (args != null){
      catalog = (args as Map)['catalog'];
      name = catalog?.name;
      description = catalog?.description;
      responsible = catalog?.responsible;
      if((args as Map)['title'] != null){
        title = (args as Map)['title'];
      }
    }
    else{
      name = '';
      description = '';
      responsible = '';
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  String? name;
  String? description;
  String? responsible;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title.toString()),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                  initialValue: responsible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(color: Colors.deepPurple, width: 5.0),
                    ),
                    labelText: 'Отвественный',
                  ),
                  onChanged: (value) {
                    setState(() {
                      responsible = value;
                    });
                  },
                  validator: (val) {
                    return val!.trim().isEmpty
                        ? 'Укажите ответственного'
                        : null;
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

  void _validateAndSave(){
    final form = _formKey.currentState;
    if (form!.validate()) {
      Box<Catalog> catalogBox = Hive.box<Catalog>('catalog_box');
      final catalogField = Catalog(
        name: name.toString(),
        description: description,
        responsible: responsible.toString(),
      );
      print(catalog);
      if(catalog == null){
        catalogBox.add(catalogField);
      }
      else{
        catalogBox.put(catalog?.key, catalogField);
      }

      Navigator.of(context).pop();
    } else {
      print('form is invalid');
    }
  }
}




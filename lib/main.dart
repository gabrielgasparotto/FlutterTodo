import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'model/item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>();

  HomePage() {
    inicializaItems();
  }

  @override
  _HomePageState createState() => _HomePageState();

  void inicializaItems() {
    items = [];
  }
}

class _HomePageState extends State<HomePage> {
  var novaTarefa = TextEditingController();

  void adicionaTarefa(){
    setState((){
      if(novaTarefa.text.isNotEmpty){
        widget.items.add(Item(title: novaTarefa.text, done: false));
        novaTarefa.clear();
        atualizaShared();
        FocusScope.of(context).requestFocus(new FocusNode());
      }
    });
  }

  void removeTarefa(int index){
    setState(() {
      widget.items.removeAt(index);
      atualizaShared();
    });
  }

  Future carregaShared() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var data = sharedPreferences.getString('data');
    if(data != null){
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  atualizaShared() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('data', jsonEncode(widget.items));
  }

  _HomePageState(){
    carregaShared();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: novaTarefa,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white, fontSize: 18),
          decoration: InputDecoration(
              labelText: "Nova Tarefa",
              labelStyle: TextStyle(color: Colors.white)
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = widget.items[index];
          return Dismissible(
            key: Key(item.title),
            background: Container(color: Colors.red.withOpacity(0.2)),
            onDismissed: (direction) {
              removeTarefa(index);
            },
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                  atualizaShared();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: adicionaTarefa,
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}

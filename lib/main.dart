import 'package:flutter/material.dart';

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
    items.add(Item(title: "Titulo 1", done: false));
    items.add(Item(title: "Titulo 2", done: true));
    items.add(Item(title: "Titulo 3", done: false));
  }
}

class _HomePageState extends State<HomePage> {
  var novaTarefa = TextEditingController();

  void adicionaTarefa(){
    setState((){
      if(novaTarefa.text.isNotEmpty){
        widget.items.add(Item(title: novaTarefa.text, done: false));
        novaTarefa.clear();
      }
    });
  }

  void removeTarefa(int index){
    setState(() {
      widget.items.removeAt(index);
    });
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

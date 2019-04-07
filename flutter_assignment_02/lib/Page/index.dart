import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/Listing/Data.dart';

class Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return IndexState();
  }
}

class IndexState extends State<Index> {
  TodoProvider todo = TodoProvider();
  String name = "Todo";
  int position = 0;
  int lenth = 0;
  List<Todo> notcomplete = [];
  List<Todo> completed = [];

  @override
  Widget build(BuildContext context) {
    final List<Widget> allbutton = [
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/addtodo");
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          for (var i in completed) {
            todo.delete(i.id);
          }
          setState(() {
            completed = [];
          });
        },
      ),
    ];
    var list_all_todo = new FutureBuilder<List<Todo>>(
      future: todo.getAll(),
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> j) {
        switch (j.connectionState) {
          default:
            if (j.hasError) {
              return new Center(
                child: Text("No data found....."),
              );
            } else {
              return createListView(context, j);
            }
        }
      },
    );
    final List<Widget> _btnpositon = 
    [
      Center(child: list_all_todo),
      Center(child: list_all_todo)
    ];
    
    return new Scaffold(
      appBar: AppBar(
          title: Text("Todo"), actions: <Widget>[allbutton[position]]),
      body: _btnpositon[position],
      bottomNavigationBar: BottomNavigationBar(
        onTap: tapped, // new
        currentIndex: position, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            title: new Text('Task'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.done_all),
            title: new Text('Completed'),
          ),
        ],
      ),
    );
  }

  void tapped(int index) {
    setState(() {
      position = index;
    });
  }

  Widget createListView(BuildContext context, AsyncSnapshot j) {
    notcomplete = [];
    completed = [];
    lenth = j.data.length;
    for (var i in j.data) {
      if (i.done == false) {
        notcomplete.add(i);
      } else {
        completed.add(i);
      }
    }
    if (position == 0 && notcomplete.length > 0) {
      return new ListView.builder(
        itemCount: notcomplete.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new ListTile(
                  title: new Text(notcomplete[index].title),
                  leading: Text((index + 1).toString()),
                  trailing: Checkbox(
                    onChanged: (bool value) async {
                      setState(() {
                        notcomplete[index].done = value;
                      });
                      todo.update(notcomplete[index]);
                    },
                    value: notcomplete[index].done,
                  )),
            ],
          );
        },
      );
    } 
    else if (position == 1 && completed.length > 0) {
      return new ListView.builder(
        itemCount: completed.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new ListTile(
                  title: new Text(completed[index].title),
                  leading: Text((index + 1).toString()),
                  trailing: Checkbox(
                    onChanged: (bool value) async {
                      setState(() {
                        completed[index].done = value;
                      });
                      todo.update(completed[index]);
                    },
                    value: completed[index].done,
                  )),
            ],
          );
        },
      );
    } 
    else {
      return new Center(
        child: Text("No data found...."),
      );
    }
  }
}

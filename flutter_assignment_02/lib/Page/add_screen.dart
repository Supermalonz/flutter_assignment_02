import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/Listing/data.dart';

class Add extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AddState();
  }
}

class AddState extends State<Add>{
  TodoProvider todo = TodoProvider();
  final _formkey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("New Subject"),),
      body: Form(
        key: _formkey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "Subject",
              ),
              controller: _controller,
              validator: (i) {
                if (i.isEmpty) {
                  return "Input cannot be empty !!";
                }
              }
            ),
            RaisedButton(
              child: Text("Save"),
              onPressed: () async {
                _formkey.currentState.validate();
                if(_controller.toString().length > 0){
                  await todo.open("todo.db");
                  Todo obj = Todo();
                  obj.title = _controller.text;
                  obj.done = false;
                  await todo.insert(obj);
                  Navigator.pop(context);
                }
                _controller.text = "";
                //set to empty
              },
            ),
          ],
        ),
      ),
    );
  }
}
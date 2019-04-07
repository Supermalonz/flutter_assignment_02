import 'package:flutter/material.dart';
class Infor extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InforState();
  }

}
class InforState extends State<Infor>{
  Iterable<Node> forallchildren(Node node) sync* {
    for (var n in node.children) {
       yield n;
       yield* forallchildren(n);
    }
}
}
import 'package:flutter/material.dart';
import 'package:tp5v2/ui/scol_list_dialog.dart';
import 'package:tp5v2/util/dbuse.dart';

import 'models/scol_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dbuse helper = dbuse();
    helper.testDb();
    return MaterialApp(
        title: 'class List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ShList());
  }
}

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  ScolListDialog dialog;
  @override
  void initState() {
    dialog = ScolListDialog();
    super.initState();
  }

  List<ScolList> scolList;
  dbuse helper = dbuse();
  @override
  Widget build(BuildContext context) {
    ScolListDialog dialog = ScolListDialog();

    showData();
    return Scaffold(
        appBar: AppBar(
          title: Text(' Classes list'),
        ),
        body: ListView.builder(
            itemCount: (scolList != null) ? scolList.length : 0,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                  key: Key(scolList[index].nomClass),
                  onDismissed: (direction) {
                    String strName = scolList[index].nomClass;
                    helper.deleteList(scolList[index]);
                    setState(() {
                      scolList.removeAt(index);
                    });
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("$strName deleted")));
                  },
                  child: ListTile(
                      title: Text(scolList[index].nomClass),
                      leading: CircleAvatar(
                        child: Text(scolList[index].codClass.toString()),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  dialog.buildDialog(
                                      context, scolList[index], false));
                        },
                      )));
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) =>
                  dialog.buildDialog(context, ScolList(0, '', 0), true),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.pink,
        ));
  }

  Future showData() async {
/*    await helper.openDb();
    ScolList list1 = ScolList(11, "DSI31", 30);
    int ClassId1 = await helper.insertClass(list1);
    ScolList list2 = ScolList(12, "DSI32", 26);
    int ClassId2 = await helper.insertClass(list2);
    ScolList list3 = ScolList(13, "DSI33", 28);
    int ClassId3 = await helper.insertClass(list3);*/

    await helper.openDb();
    scolList = await helper.getClasses();
    setState(() {
      scolList = scolList;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Hiscores extends StatefulWidget {
  @override
  _HiscoresState createState() => _HiscoresState();
}

class _HiscoresState extends State<Hiscores> {
  SharedPreferences _prefs;
  List<String> _records;
  bool _loading = true;
  @override
  void didChangeDependencies() {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _prefs = sp;
      setState(() {
        _records = _prefs.getStringList("records") ?? ["No records yet"];
        _loading = false;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Delete all records',
                      style: TextStyle(fontFamily: "Frijole", fontSize: 20),
                    ),
                    content: Text(
                        'Are you sure you want to delete\n all the records?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Delete'),
                        onPressed: () {
                          _prefs.remove("records");
                          _records.clear();
                          _records.add("No records yet");
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Regret'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Colors.blue,
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
        title: Text(
          "Hiscores",
          style: TextStyle(fontFamily: "Frijole", fontSize: 40),
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: Container(
          width: _size.width,
          color: Colors.orangeAccent,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  itemCount: _records.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: Colors.blue,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Text("$index.",
                          style:
                              TextStyle(fontFamily: "Frijole", fontSize: 20)),
                      title: Text(" ${_records[index]}",
                          style:
                              TextStyle(fontFamily: "Frijole", fontSize: 14)),
                    );
                  },
                )),
    );
  }
}

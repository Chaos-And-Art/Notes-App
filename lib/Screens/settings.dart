import 'package:flutter/material.dart';
import 'package:notes/Screens/home.dart';
import 'package:notes/Utils/navigate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool darkTheme = true;

  @override
  void initState() {
    super.initState();
    setTheme();
  }

  setTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int theme = prefs.getInt('appTheme') ?? 0;
    if (theme == 0) {
      setState(() {
        darkTheme = true;
      });
    } else if (theme == 1) {
      setState(() {
        darkTheme = false;
      });
    }
  }

  changeThemeDark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('appTheme', 0);
  }

  changeThemeLight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('appTheme', 1);
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF696D77), Color(0xFF292C36)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          tileMode: TileMode.clamp,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
          backgroundColor: Colors.black54,
          title: Text("Settings"),
          centerTitle: true,
          leading: ButtonTheme(
            minWidth: 5,
            child: FlatButton(
              onPressed: () {
                Navigator.push(context, SlideRightRoute(page: Home()));
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 25),
            Container(
              height: 200,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: new Card(
                color: darkTheme ? Colors.grey[800] : Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomLeft: const Radius.circular(10),
                    bottomRight: const Radius.circular(10),
                  ),
                ),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "App Theme",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                          color: darkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: <Widget>[
                          ButtonTheme(
                            minWidth: 0,
                            child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    darkTheme = true;
                                    changeThemeDark();
                                  });
                                },
                                child: darkTheme
                                    ? Icon(Icons.radio_button_checked,  color: Colors.white,)
                                    : Icon(
                                        Icons.radio_button_unchecked,
                                        color: Colors.black,
                                      )),
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                darkTheme = true;
                                changeThemeDark();
                              });
                            },
                            child: Text(
                              "Dark Theme",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: darkTheme ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          ButtonTheme(
                            minWidth: 0,
                            child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    darkTheme = false;
                                    changeThemeLight();
                                  });
                                },
                                child: !darkTheme
                                    ? Icon(
                                        Icons.radio_button_checked,
                                        color: Colors.black,
                                      )
                                    : Icon(Icons.radio_button_unchecked, color: Colors.white,)),
                          ),
                          FlatButton(
                            onPressed: () {
                              setState(() {
                                darkTheme = false;
                                changeThemeLight();
                              });
                            },
                            child: Text(
                              "Light Theme",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: darkTheme ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              height: 200,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: new Card(
                color: darkTheme ? Colors.grey[800] : Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomLeft: const Radius.circular(10),
                    bottomRight: const Radius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              height: 200,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: new Card(
                color: darkTheme ? Colors.grey[800] : Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomLeft: const Radius.circular(10),
                    bottomRight: const Radius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

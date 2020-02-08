import 'package:flutter/material.dart';
import 'package:notes/Screens/edit_notes.dart';

import 'package:notes/Screens/notes_view.dart';
import 'package:notes/Screens/settings.dart';

import 'package:notes/Services/database.dart';
import 'package:notes/UI/widgets.dart';
import 'package:notes/Utils/navigate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

bool newNote = false;

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<NotesModel> notesList = [];
  bool search = false;
  bool darkTheme = true;
  bool longPress = false;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    setTheme();
  }

  setPress() {
    setState(() {
      longPress = true;
    });
  }

  void setNotesFromDB() async {
    Future.delayed(Duration(seconds: 1), () {});
    var fetchedNotes = await NotesDatabaseService.db.getNotesFromDB();
    setState(() {
      notesList = fetchedNotes;
    });
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

  finalTest() {
    setState(() {
      longPress = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkTheme ? Colors.grey[900] : Colors.grey[100],
      appBar: !longPress ? standardBar() : optionsBar(),
      drawer: Drawer(
        child: menu(context, darkTheme),
      ),
      body: NotesView(
        isSearch: searchController,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkTheme ? Colors.grey[300] : Colors.grey[700],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditNotes(
                triggerRefetch: setNotesFromDB,
              ),
            ),
          );
          newNote = true;
        },
        child: Icon(
          Icons.add,
          color: darkTheme ? Colors.black : Colors.white,
          size: 40,
        ),
      ),
    );
  }

  Widget standardBar() {
    return AppBar(
      backgroundColor: darkTheme ? Colors.grey[700] : Colors.grey[200],
      title: search
          ? TextField(
              controller: searchController,
              autofocus: true,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              maxLines: null,
              onSubmitted: (text) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              onChanged: (value) {
                setState(() {
                  searchController.text;
                });
              },
              textInputAction: TextInputAction.next,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: darkTheme ? Colors.grey[100] : Colors.grey[900]),
              decoration: InputDecoration.collapsed(
                hintText: 'Search...',
                hintStyle: TextStyle(
                    color: darkTheme ? Colors.grey[300] : Colors.grey[700],
                    fontSize: 26,
                    fontWeight: FontWeight.w700),
              ),
              cursorColor: darkTheme ? Colors.grey[300] : Colors.grey[700],
            )
          : Text(
              "Notes",
              style: TextStyle(
                  fontSize: 25, color: darkTheme ? Colors.white : Colors.black),
            ),
      actions: <Widget>[
        ButtonTheme(
          minWidth: 0,
          child: FlatButton(
            onPressed: () {
              setState(() {
                search = true;
              });
            },
            child: search
                ? FlatButton(
                    onPressed: () {
                      setState(() {
                        searchController.clear();
                        search = false;
                      });
                    },
                    child: Icon(
                      Icons.cancel,
                      color: darkTheme ? Colors.white : Colors.black,
                    ),
                  )
                : Icon(
                    Icons.search,
                    color: darkTheme ? Colors.white : Colors.black,
                  ),
          ),
        ),
        ButtonTheme(
          minWidth: 0,
          child: FlatButton(
            onPressed: () {
              setState(() {
                Navigator.push(context, SlideLeftRoute(page: Settings()));
              });
            },
            child: Icon(
              Icons.settings,
              color: darkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
      iconTheme: IconThemeData(color: darkTheme ? Colors.white : Colors.black),
    );
  }

//Currently Not Being Used
  Widget optionsBar() {
    return AppBar(
      backgroundColor: darkTheme ? Colors.grey[700] : Colors.grey[200],
      leading: FlatButton(
        onPressed: () {
          setState(() {
            longPress = false;
          });
        },
        child: Icon(
          Icons.cancel,
          color: darkTheme ? Colors.white : Colors.black,
        ),
      ),
      actions: <Widget>[
        ButtonTheme(
          minWidth: 0,
          child: FlatButton(
            onPressed: () {},
            child: Icon(
              Icons.star_border,
              color: darkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
        ButtonTheme(
          minWidth: 0,
          child: FlatButton(
            onPressed: () {},
            child: Icon(
              Icons.color_lens,
              color: darkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
        ButtonTheme(
          minWidth: 0,
          child: FlatButton(
            onPressed: () {},
            child: Icon(
              Icons.content_copy,
              color: darkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
        ButtonTheme(
          minWidth: 0,
          child: FlatButton(
            onPressed: () {},
            child: Icon(
              Icons.delete,
              color: darkTheme ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
      iconTheme: IconThemeData(color: darkTheme ? Colors.white : Colors.black),
    );
  }
}

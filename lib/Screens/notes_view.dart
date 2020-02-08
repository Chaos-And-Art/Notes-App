import 'package:flutter/material.dart';
import 'package:notes/Screens/edit_notes.dart';
import 'package:notes/Screens/home.dart';
import 'package:notes/Services/database.dart';
import 'package:notes/UI/cards.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesView extends StatefulWidget {
  final TextEditingController isSearch;
  final Function() longPress;

  NotesView({this.isSearch, this.longPress});

  @override
  _NotesView createState() => _NotesView(isSearch);
}

class _NotesView extends State<NotesView> {
  _NotesView(this.searchController);
  List<NotesModel> notesList = [];
  bool header = true;
  bool darkTheme = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    setNotesFromDB();
    setTheme();
  }

  void setNotesFromDB() async {
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

  @override
  Widget build(BuildContext context) {
    return  ListView(
        children: <Widget>[
          ...buildRecentsCard(),
          SizedBox(height: 50),
          greeting(context),
          SizedBox(height: 100),
        ],
      
    );
  }

  List<Widget> buildRecentsCard() {
    List<Widget> noteComponentsList = [];
    if (notesList.length >= 1) {
      header = false;
    } else if (notesList.length <= 0) {
      header = true;
    }
    notesList.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    if (searchController.text.isNotEmpty) {
      notesList.forEach((note) {
        if (note.title
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            note.content
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
          noteComponentsList.add(NoteCard(
            noteData: note,
            onTapAction: gotoEditNote,
          ));
      });
      return noteComponentsList;
    } else {
      notesList.forEach((note) {
        noteComponentsList.add(
          NoteCard(
            noteData: note,
            onTapAction: gotoEditNote,
          ),
        );
      });
      return noteComponentsList;
    }
  }

  Widget greeting(BuildContext context) {
    return Visibility(
      visible: header,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
          child: Column(
            children: <Widget>[
              Text(
                "You have no Notes. Press the + button to get started.",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w400,
                  color: darkTheme ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              ButtonTheme(
                child: RaisedButton(
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
                    color: Colors.white,
                  ),
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void gotoEditNote(NotesModel noteData) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotes(
          existingNote: noteData,
          triggerRefetch: setNotesFromDB,
        ),
      ),
    );
  }
}

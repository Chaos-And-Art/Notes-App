import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/Services/database.dart';
import 'package:notes/Screens/home.dart';
import 'package:notes/Utils/navigate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteCard extends StatefulWidget {
  const NoteCard({
    this.noteData,
    this.onTapAction,
    Key key,
  }) : super(key: key);

  final NotesModel noteData;
  final Function(NotesModel noteData) onTapAction;

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
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

  @override
  Widget build(BuildContext context) {
    String neatDate = DateFormat.jm().add_yMd().format(widget.noteData.date);
    return GestureDetector(
      onTap: () {
        widget.onTapAction(widget.noteData);
      },
      onLongPress: () {
        // Navigator.push(context, NoRoute(page: Home(isPressed: true,)));
      },
      child: Container(
        height: 190,
        margin: EdgeInsets.fromLTRB(6, 12, 6, 0),
        decoration: BoxDecoration(
          color: darkTheme ? Colors.grey[800] : Colors.grey[300],
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              alignment: Alignment.topLeft,
              child: Text(
                  "${widget.noteData.title.length <= 30 ? widget.noteData.title : widget.noteData.title.substring(0, 30)}",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: darkTheme ? Colors.grey[100] : Colors.black),
                  textAlign: TextAlign.left),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
              alignment: Alignment.centerLeft,
              child: Text(
                "${widget.noteData.content.length <= 30 ? widget.noteData.content : widget.noteData.content + '...'}",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: darkTheme ? Colors.grey[100] : Colors.black,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.bottomRight,
                child: Text(
                  "$neatDate",
                  style: TextStyle(
                      fontSize: 12,
                      color: darkTheme ? Colors.grey[100] : Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateNoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black),
                borderRadius: new BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.blueGrey),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 30, 5, 30),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.add,
                    size: 70,
                    color: Colors.grey[100],
                  ),
                  Text(
                    "Create New Note",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

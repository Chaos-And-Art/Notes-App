import 'package:flutter/material.dart';
import 'package:notes/Screens/home.dart';
import 'package:notes/Services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNotes extends StatefulWidget {
  Function() triggerRefetch;
  NotesModel existingNote;
  EditNotes({Key key, Function() triggerRefetch, NotesModel existingNote})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.existingNote = existingNote;
  }
  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  bool darkTheme = true;
  bool isDirty = false;
  bool isNoteNew = true;
  bool exitSave = false;
  bool activateOptions = false;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();

  NotesModel currentNote;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setTheme();
    if (widget.existingNote == null) {
      currentNote = NotesModel(content: '', title: '', date: DateTime.now());
      isNoteNew = true;
    } else {
      currentNote = widget.existingNote;
      isNoteNew = false;
    }
    titleController.text = currentNote.title;
    contentController.text = currentNote.content;
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
    double _width = MediaQuery.of(context).size.width * 0.95;
    return Container(
      width: double.infinity,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: darkTheme ? Colors.grey[800] : Colors.grey[200],
          leading: ButtonTheme(
            minWidth: 5,
            child: FlatButton(
              onPressed: () {
                hasntSaved();
              },
              child: Icon(
                Icons.arrow_back,
                color: darkTheme ? Colors.white : Colors.black,
              ),
            ),
          ),
          actions: <Widget>[
            ButtonTheme(
              minWidth: 5,
              child: FlatButton(
                onPressed: () {
                  setState(() {
                    if (activateOptions) {
                      activateOptions = false;
                    } else if (activateOptions == false) {
                      activateOptions = true;
                    }
                  });

                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Icon(
                  Icons.more_vert,
                  color: darkTheme ? Colors.white : Colors.black,
                ),
              ),
            ),
            AnimatedContainer(
              margin: EdgeInsets.only(left: 10),
              duration: Duration(milliseconds: 200),
              width: isDirty ? 100 : 0,
              height: 42,
              curve: Curves.decelerate,
              child: RaisedButton.icon(
                color: Colors.blueGrey,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100))),
                icon: Icon(Icons.done),
                label: Text(
                  'SAVE',
                  style: TextStyle(letterSpacing: 1),
                ),
                onPressed: () {
                  hasSaved();
                  _save();
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
              ),
            )
          ],
        ),
        body: Container(
          color: darkTheme ? Colors.grey[850] : Colors.grey[200],
          child: Column(
            children: <Widget>[
              Container(
                color: darkTheme ? Colors.grey[850] : Colors.grey[200],
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  focusNode: titleFocus,
                  controller: titleController,
                  autofocus: isNoteNew,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  onSubmitted: (text) {
                    titleFocus.unfocus();
                    FocusScope.of(context).requestFocus(contentFocus);
                  },
                  onChanged: (value) {
                    markTitleAsDirty(value);
                  },
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: darkTheme ? Colors.grey[100] : Colors.black),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Title',
                    hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                    border: InputBorder.none,
                  ),
                  cursorColor: darkTheme ? Colors.grey[100] : Colors.black,
                ),
              ),
              Expanded(
                child: Container(
                  color: darkTheme ? Colors.grey[850] : Colors.grey[200],
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    onTap: () {
                      setState(() {
                        activateOptions = false;
                      });
                    },
                    focusNode: contentFocus,
                    controller: contentController,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: darkTheme ? Colors.grey[100] : Colors.black),
                    onChanged: (value) {
                      markTitleAsDirty(value);
                    },
                    decoration: InputDecoration.collapsed(
                      hintText: 'Note',
                      hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                    ),
                    cursorColor: darkTheme ? Colors.grey[100] : Colors.black,
                  ),
                ),
              ),
              AnimatedContainer(
                color: darkTheme ? Colors.grey[850] : Colors.grey[200],
                duration: Duration(milliseconds: 200),
                width: _width,
                height: activateOptions ? 150 : 0,
                curve: Curves.decelerate,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                      ),
                      color: darkTheme ? Colors.grey[500] : Colors.grey[700]),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: ButtonTheme(
                          minWidth: 0,
                          child: FlatButton(
                            onPressed: () {
                              setState(() {
                                activateOptions = false;
                              });
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(15),
                            topRight: const Radius.circular(15),
                          ),
                          color:
                              darkTheme ? Colors.grey[500] : Colors.grey[700],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ButtonTheme(
                              child: FlatButton.icon(
                                onPressed: () {
                                  handleDelete();
                                },
                                color: darkTheme
                                    ? Colors.grey[200]
                                    : Colors.grey[850],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.delete,
                                  color: darkTheme
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                ),
                                label: Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: darkTheme
                                          ? Colors.grey[800]
                                          : Colors.grey[200]),
                                ),
                              ),
                            ),
                            ButtonTheme(
                              child: FlatButton.icon(
                                onPressed: () {},
                                color: darkTheme
                                    ? Colors.grey[200]
                                    : Colors.grey[850],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.share,
                                  color: darkTheme
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                ),
                                label: Text(
                                  'Share',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: darkTheme
                                        ? Colors.grey[800]
                                        : Colors.grey[200],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void hasntSaved() {
    if (isDirty == false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      exitSave = true;
      var alert = AlertDialog(
        title: Column(
          children: <Widget>[
            Text(
              "The file isn't saved!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            Text(
              "Do you want to save before exiting?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        content: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _save();
                  hasSaved();
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                color: Colors.grey[300],
                child: Text("Yes"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                color: Colors.grey[300],
                child: Text("No"),
              ),
            ],
          ),
        ),
      );
      showDialog(context: context, builder: (context) => alert);
    }
  }

  void markTitleAsDirty(String title) {
    setState(() {
      isDirty = true;
    });
  }

  void markContentAsDirty(String content) {
    setState(() {
      isDirty = true;
    });
  }

  void hasSaved() {
    var alert = AlertDialog(
      title: Text(
        "Successfully Saved",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      backgroundColor: Colors.grey[300],
    );
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(Duration(seconds: 1), () {
          if (exitSave) {
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
          }
        });
        return alert;
      },
    );
  }

  void _save() async {
    setState(() {
      currentNote.title = titleController.text;
      currentNote.content = contentController.text;
      currentNote.date = DateTime.now();
    });
    if (isNoteNew) {
      var latestNote = await NotesDatabaseService.db.addNoteInDB(currentNote);
      setState(() {
        currentNote = latestNote;
      });
    } else {
      await NotesDatabaseService.db.updateNoteInDB(currentNote);
    }
    setState(() {
      isNoteNew = false;
      isDirty = false;
    });
    widget.triggerRefetch();
    titleFocus.unfocus();
    contentFocus.unfocus();
  }

  void handleDelete() async {
    if (isNoteNew) {
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Delete Note'),
            content: Text('This note will be deleted permanently'),
            actions: <Widget>[
              FlatButton(
                child: Text('DELETE',
                    style: TextStyle(
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () async {
                  await NotesDatabaseService.db.deleteNoteInDB(currentNote);
                  widget.triggerRefetch();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('CANCEL',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1)),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
    }
  }
}

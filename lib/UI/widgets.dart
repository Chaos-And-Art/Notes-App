import 'package:flutter/material.dart';

bool search = false;

Widget menu(BuildContext context, bool darkTheme) {
  return SafeArea(
    child: Column(
      children: <Widget>[
        Container(
          color: darkTheme ? Colors.grey[700] : Colors.grey[200],
          child: ListTile(
            title: Text(
              'Notes',
              style: TextStyle(
                color: darkTheme ? Colors.white : Colors.black,
              ),
            ),
            trailing: Icon(Icons.event_note,
                color: darkTheme ? Colors.white : Colors.black),
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        Container(
          color: darkTheme ? Colors.grey[700] : Colors.grey[200],
          child: Divider(
            height: 10.0,
            color: darkTheme ? Colors.white : Colors.black,
            indent: 15.0,
            endIndent: 15.0,
          ),
        ),
        Container(
          height: 700,
          color: darkTheme ? Colors.grey[700] : Colors.grey[200],
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: darkTheme ? Colors.grey[700] : Colors.grey[200],
              child: ListTile(
                title: Text(
                  'Close',
                  style:
                      TextStyle(color: darkTheme ? Colors.white : Colors.black),
                ),
                trailing: Icon(Icons.cancel,
                    color: darkTheme ? Colors.white : Colors.black),
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

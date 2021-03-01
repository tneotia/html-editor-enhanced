import 'package:flutter/material.dart';

/// Widget for the toolbar icon
Widget toolbarIcon(BuildContext context, IconData icon, String title,
    {required Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: <Widget>[
        Icon(
          icon,
          color: Theme.of(context).iconTheme.color,
          size: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        )
      ],
    ),
  );
}

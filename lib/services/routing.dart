import 'package:flutter/material.dart';

void navigateToPage({required page, required BuildContext context}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return page;
  }));
}

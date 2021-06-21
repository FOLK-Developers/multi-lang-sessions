import 'package:flutter/material.dart';

import 'package:multi_language_sessions/helpers/utility.dart';

class LoadingIndicatorWithMessage extends StatelessWidget {
  final String text;

  const LoadingIndicatorWithMessage({
    Key? key,
    required this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Utility().getSize(context).height * 0.25,
      width: Utility().getSize(context).width * 0.30,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(text),
            )
          ],
        ),
      ),
    );
  }
}

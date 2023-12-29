import 'package:flutter/material.dart';

Function alert =
    (BuildContext context, String title, String content, String type,
            {int popFreq = 1}) =>
        {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    icon: type == 'error'
                        ? const Icon(
                            Icons.error,
                            size: 30.0,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.check_circle,
                            size: 30.0,
                            color: Colors.green,
                          ),
                    title: Text(title),
                    content: Text(content),
                    contentTextStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          for (int i = 0; i < popFreq; i++) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Ok'),
                      )
                    ],
                    titleTextStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ))
        };

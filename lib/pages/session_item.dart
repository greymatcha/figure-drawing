import 'package:flutter/material.dart';

import 'package:figure_drawing/classes.dart' as classes;

class SessionItemPage extends StatefulWidget {
  final classes.SessionItem sessionItem;

  const SessionItemPage ({ required this.sessionItem });

  @override
  _SessionItemPageState createState() => _SessionItemPageState(sessionItem: this.sessionItem);
}

class _SessionItemPageState extends State<SessionItemPage> {
  classes.SessionItem sessionItem;
  final _formDrawKey = GlobalKey<FormState>();
  final _formBreakKey = GlobalKey<FormState>();

  _SessionItemPageState({ required this.sessionItem });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add session item"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: classes.SessionItemType.draw,
                    groupValue: sessionItem.type,
                    onChanged: (classes.SessionItemType? value) {
                      if (value != null) {
                        setState(() {
                          sessionItem.type = value;
                        });
                      }
                    },
                  ),
                  Text("Drawing"),
                  Radio(
                    value: classes.SessionItemType.pause,
                    groupValue: sessionItem.type,
                    onChanged: (classes.SessionItemType? value) {
                      if (value != null) {
                        setState(() {
                          sessionItem.type = value;
                        });
                      }
                    },
                  ),
                  Text("Break"),
                ],
              ),
              sessionItem.type == classes.SessionItemType.draw ?
                FocusTraversalGroup(
                  child: Form(
                      key: _formDrawKey,
                      onChanged: () {
                        Form.of(primaryFocus!.context!)!.save();
                      },
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Number of drawings',
                            ),
                            initialValue: sessionItem.imageAmount != null ? sessionItem.imageAmount.toString() : "",
                            keyboardType: TextInputType.number,
                            onSaved: (String? value) {
                              if (value != null && value.isNotEmpty) {
                                int? parsedInt = int.tryParse(value);
                                if (parsedInt != null) {
                                  sessionItem.imageAmount = parsedInt;
                                }
                              }
                            },
                            validator: (String? value) {
                              if (value != null && value.isNotEmpty) {
                                int? parsedInt = int.tryParse(value);
                                if (parsedInt != null) {
                                  return null;
                                }
                              }

                              return "Please enter a whole number";
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Seconds per drawing',
                            ),
                            initialValue: sessionItem.timeAmount != null ? sessionItem.timeAmount.toString() : "",
                            keyboardType: TextInputType.number,
                            onSaved: (String? value) {
                              if (value != null && value.isNotEmpty) {
                                int? parsedInt = int.tryParse(value);
                                if (parsedInt != null) {
                                  sessionItem.timeAmount = parsedInt;
                                }
                              }
                            },
                            validator: (String? value) {
                              if (value != null && value.isNotEmpty) {
                                int? parsedInt = int.tryParse(value);
                                if (parsedInt != null) {
                                  return null;
                                }
                              }

                              return "Please enter a whole number";
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formDrawKey.currentState!.validate()) {
                                  Navigator.pop(context, sessionItem);
                                }
                              },
                              child: const Text('Submit'),
                            ),
                          ),
                        ],
                      )
                  )
                ) :
              FocusTraversalGroup(
                  child: Form(
                    key: _formBreakKey,
                    onChanged: () {
                      Form.of(primaryFocus!.context!)!.save();
                    },
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Break length in seconds',
                          ),
                          initialValue: sessionItem.timeAmount != null ? sessionItem.timeAmount.toString() : "",
                          keyboardType: TextInputType.number,
                          onSaved: (String? value) {
                            if (value != null && value.isNotEmpty) {
                              int? parsedInt = int.tryParse(value);
                              if (parsedInt != null) {
                                sessionItem.timeAmount = parsedInt;
                              }
                            }
                          },
                          validator: (String? value) {
                            if (value != null && value.isNotEmpty) {
                              int? parsedInt = int.tryParse(value);
                              if (parsedInt != null) {
                                return null;
                              }
                            }

                            return "Please enter a whole number";
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formBreakKey.currentState!.validate()) {
                                Navigator.pop(context, sessionItem);
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    )
                  )
              )
            ]
          ),
        )
      )
    );
  }
}

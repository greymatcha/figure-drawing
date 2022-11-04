import 'package:flutter/material.dart';

import 'package:figure_drawing/classes.dart' as classes;

class CreateSessionItemPage extends StatefulWidget {
  final classes.SessionItemEdit sessionItem;

  const CreateSessionItemPage ({ super.key, required this.sessionItem });

  @override
  State<CreateSessionItemPage> createState() => _CreateSessionItemPageState();
}

class _CreateSessionItemPageState extends State<CreateSessionItemPage> {
  late classes.SessionItemEdit sessionItem = widget.sessionItem;
  final _formDrawKey = GlobalKey<FormState>();
  final _formBreakKey = GlobalKey<FormState>();

  void popNavigator() {
    Navigator.pop(context, classes.SessionItemComplete(
        sessionItem.type,
        sessionItem.timeAmount as int,
        sessionItem.type == classes.SessionItemType.pause ? 0 : sessionItem.imageAmount as int
    ));
  }

  @override
  void initState() {
    super.initState();

    sessionItem = widget.sessionItem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create or edit session item"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              if (sessionItem.type == classes.SessionItemType.draw) {
                if (_formDrawKey.currentState!.validate()) {
                  popNavigator();
                }
              } else {
                if (_formBreakKey.currentState!.validate()) {
                  popNavigator();
                }
              }
            },
            child: const Text('Save'),
          ),
        ]
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
                  const Text("Drawing"),
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
                  const Text("Break"),
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
                                if (parsedInt != null && parsedInt > 0) {
                                  sessionItem.imageAmount = parsedInt;
                                }
                              }
                            },
                            validator: (String? value) {
                              if (value != null && value.isNotEmpty) {
                                int? parsedInt = int.tryParse(value);
                                if (parsedInt != null && parsedInt > 0) {
                                  return null;
                                }
                              }

                              return "Please enter a whole number above 0";
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
                                if (parsedInt != null && parsedInt > 0) {
                                  sessionItem.timeAmount = parsedInt;
                                }
                              }
                            },
                            validator: (String? value) {
                              if (value != null && value.isNotEmpty) {
                                int? parsedInt = int.tryParse(value);
                                if (parsedInt != null && parsedInt > 0) {
                                  return null;
                                }
                              }

                              return "Please enter a whole number above 0";
                            },
                          )
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
                              if (parsedInt != null && parsedInt > 0) {
                                sessionItem.timeAmount = parsedInt;
                              }
                            }
                          },
                          validator: (String? value) {
                            if (value != null && value.isNotEmpty) {
                              int? parsedInt = int.tryParse(value);
                              if (parsedInt != null && parsedInt > 0) {
                                return null;
                              }
                            }

                            return "Please enter a whole number above 0";
                          },
                        )
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

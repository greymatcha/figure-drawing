import 'package:flutter/material.dart';

import 'package:figure_drawing/classes.dart' as classes;
import 'package:figure_drawing/pages/create_session_item.dart';

class CreateSessionPage extends StatefulWidget {
  final classes.Session session;

  const CreateSessionPage({ super.key, required this.session });

  @override
  State<CreateSessionPage> createState() => _CreateSessionPage();
}

class _CreateSessionPage extends State<CreateSessionPage> {
  late classes.Session session = widget.session;
  late int sessionKey = widget.session.items.length;
  final _formKey = GlobalKey<FormState>();

  void popNavigator({required bool cancel}) {
    if (cancel) {
      Navigator.pop(context, null);
    } else {
      Navigator.pop(context, session);
    }
  }

  Future<void> navigateAddEditPage(BuildContext context, classes.SessionItem sessionItem, int? existingIndex) async {
    final classes.SessionItemComplete? resultSessionItem = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateSessionItemPage(
            sessionItem: sessionItem.runtimeType == classes.SessionItemComplete ? classes.SessionItemEdit(
                sessionItem.type,
                (sessionItem as classes.SessionItemComplete).timeAmount,
                sessionItem.imageAmount
            ) : sessionItem as classes.SessionItemEdit
        ))
    );
    if (resultSessionItem != null) {
      setState(() {
        if (existingIndex != null) {
          session.items[existingIndex] = resultSessionItem;
        } else {
          session.items.add(resultSessionItem);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create or edit session"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate() && session.items.isNotEmpty) {
                popNavigator(cancel: false);
              } else if (session.items.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please add some session items"))
                );
              }
            },
            child: const Text('Save'),
          ),
        ]
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FocusTraversalGroup(
                child: Form(
                  key: _formKey,
                  onChanged: () {
                    Form.of(primaryFocus!.context!)!.save();
                  },
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Session title"
                        ),
                        initialValue: session.title,
                        onSaved: (String? value) {
                          if (value != null) {
                            session.title = value;
                          }
                        },
                        validator: (String? value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          }

                          return "Please give your session a title";
                        }
                      )
                    ],
                  )
                )
              ),
              const SizedBox(height: 12),
              Expanded(
                  child: ReorderableListView(
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final classes.SessionItemComplete sessionItem = session.items.removeAt(oldIndex);
                          session.items.insert(newIndex, sessionItem);
                        });
                      },
                      children:
                      session.items.asMap().entries.map((MapEntry entry) {
                        int index = entry.key;
                        classes.SessionItemComplete sessionItem = entry.value;
                        return ListTile(
                            key: Key(index.toString()),
                            title: Text(sessionItemDescription(sessionItem)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(onPressed: () {
                                  navigateAddEditPage(
                                      context,
                                      sessionItem,
                                      index
                                  );
                                }, icon: const Icon(Icons.edit)),
                                IconButton(onPressed: () {
                                  setState(() {
                                    session.items.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Session item removed"),
                                      action: SnackBarAction(label: "Undo", onPressed: () {
                                        setState(() {
                                          session.items.insert(index, sessionItem);
                                        });
                                      })
                                    )
                                  );
                                }, icon: const Icon(Icons.delete_outline)),
                                const SizedBox(width: 32),
                              ],
                            )
                        );
                      }).toList()
                  )
              ),
            ],
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateAddEditPage(
              context,
              classes.SessionItemEdit(
                  classes.SessionItemType.draw,
                  null,
                  null
              ),
              null
          );
          setState(() {
            sessionKey += 1;
          });
        },
        child: const Icon(
          Icons.add,
          size: 25.0,
        ),
      )
    );
  }
}

String sessionItemDescription(classes.SessionItemComplete sessionItem) {
  String result = "";

  if (sessionItem.type == classes.SessionItemType.pause) {
    result = "${sessionItem.timeAmount}s break";
  } else {
    result = "${sessionItem.imageAmount} drawings of ${sessionItem.timeAmount}s each";
  }

  return result;
}

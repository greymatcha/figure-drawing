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
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Session item updated"))
          );
        } else {
          session.items.add(resultSessionItem);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Session item added"))
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create or edit session")
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 40),
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
              Expanded(
                  child: ReorderableListView(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      footer: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
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
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add),
                                  SizedBox(width: 4),
                                  Text("Add item")
                                ],
                              )
                          ),
                        ],
                      ),
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
                                      const SnackBar(content: Text("Session item removed"))
                                  );
                                }, icon: const Icon(Icons.delete_outline)),
                                const SizedBox(width: 32),
                              ],
                            )
                        );
                      }).toList()
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() && session.items.isNotEmpty) {
                          popNavigator(cancel: false);
                        }
                      },
                      child: const Text("Save")
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                      onPressed: () {
                        popNavigator(cancel: true);
                      },
                      child: const Text("Cancel")
                  ),
                ],
              )
            ],
          )
        )
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

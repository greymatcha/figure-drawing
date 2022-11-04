import 'package:flutter/material.dart';

import 'package:figure_drawing/classes.dart' as classes;

class SessionRow extends StatelessWidget {
  final classes.Session session;
  final int? index;
  final Function(classes.Session, int)? editSession;
  final Function(int)? deleteSession;
  final VoidCallback? clickAction;
  final bool showIcon;

  const SessionRow(
    this.session,
    this.index,
    this.editSession,
    this.deleteSession,
    this.clickAction,
    this.showIcon,
    { super.key }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: const BorderRadius.all(Radius.circular(10))
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (clickAction != null) {
            clickAction!();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(session.title),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                editSession != null ? IconButton(
                  onPressed: () {
                    editSession!(session, index!);
                  },
                  icon: const Icon(Icons.edit),
                  iconSize: 18,
                ) : const SizedBox(),
                deleteSession != null ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () {
                        deleteSession!(index!);
                      },
                      icon: const Icon(Icons.delete_outline),
                      iconSize: 18,
                    ),
                  ],
                ) : const SizedBox(),
                showIcon ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right_rounded)
                  ],
                ) : const SizedBox(),
              ],
            )
          ]
        )
      )
    );
  }
}

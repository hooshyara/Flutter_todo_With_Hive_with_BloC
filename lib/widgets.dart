import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Image.asset(
            'assets/emptyState.jpg',
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'your Task List is Empty !!!',
          style: Theme.of(context).textTheme.headline6,
        )
      ],
    );
  }
}



class MyCheckBox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;

  const MyCheckBox({
    super.key,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 2),
        child: Container(
          height: 24,
          width: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border:
            !value ? Border.all(color: secondaryTextColor, width: 2) : null,
            color: value ? primaryColor : null,
          ),
          child: value
              ? Icon(
            CupertinoIcons.check_mark,
            color: Theme.of(context).colorScheme.surface,
            size: 16,
          )
              : null,
        ),
      ),
    );
  }
}

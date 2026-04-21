import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('yMMMMd');

class MilestoneContainer extends StatelessWidget {
  const MilestoneContainer({
    required this.name,
    required this.description,
    required this.icon,
    required this.isCompleted,
    this.completedDate,
    super.key
  });

  final String name;
  final String description;
  final IconData icon;
  final bool isCompleted;
  final DateTime? completedDate;

  @override
  build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Icon(
            icon,
            size: 50,
            color: isCompleted ? Theme.of(context).colorScheme.primary : Colors.grey,
          ),
          SizedBox(height: 10,),
          Text(
            name,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: isCompleted ? Theme.of(context).colorScheme.onSurface : Colors.grey
            ),
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: isCompleted ? Theme.of(context).colorScheme.onSurface : Colors.grey
            ),
          ),
          if (isCompleted && completedDate != null)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                '(${formatter.format(completedDate!)})',
                style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: isCompleted ? Theme.of(context).colorScheme.onSurface : Colors.grey
                ),
              ),
            )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'models.dart';

class SampleItemWidget extends StatelessWidget {
  final SampleItem item;
  final VoidCallback? onTap;

  const SampleItemWidget({Key? key, required this.item, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage('path/to/your/image.jpg'),
        ),
        title: Text(item.name.value),
        subtitle: Text('ID: ${item.id}\nPrice: \$${item.price.value}'),
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: onTap,
      ),
    );
  }
}

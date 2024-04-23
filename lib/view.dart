import 'package:flutter/material.dart';
import 'models.dart';
import 'view_models.dart';
import 'widgets.dart';

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({Key? key}) : super(key: key);

  @override
  _SampleItemListViewState createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  final viewModel = SampleItemViewModel();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredItems = viewModel.items
        .where((item) =>
            item.name.value.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet<SampleItem?>(
                context: context,
                builder: (context) => SampleItemUpdate(),
              ).then((newItem) {
                if (newItem != null) {
                  viewModel.addItem(newItem.name.value, newItem.price.value);
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return SampleItemWidget(
                  key: ValueKey(item.id),
                  item: item,
                  onTap: () {
                    Navigator.of(context)
                        .push<bool>(
                      MaterialPageRoute(
                        builder: (context) => SampleItemDetailsView(item: item),
                      ),
                    )
                        .then((deleted) {
                      if (deleted ?? false) {
                        viewModel.removeItem(item.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SampleItemDetailsView extends StatefulWidget {
  final SampleItem item;

  const SampleItemDetailsView({Key? key, required this.item}) : super(key: key);

  @override
  _SampleItemDetailsViewState createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  final viewModel = SampleItemViewModel();
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name.value);
    _priceController = TextEditingController(
      text: widget.item.price.value.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              showModalBottomSheet<SampleItem?>(
                context: context,
                builder: (context) => SampleItemUpdate(
                  initialName: widget.item.name.value,
                  initialPrice: widget.item.price.value,
                ),
              ).then((updatedItem) {
                if (updatedItem != null) {
                  viewModel.updateItem(
                    widget.item.id,
                    updatedItem.name.value,
                    updatedItem.price.value,
                  );
                  setState(() {
                    _nameController.text = updatedItem.name.value;
                    _priceController.text =
                        updatedItem.price.value.toStringAsFixed(2);
                  });
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Xác nhận xóa'),
                    content: const Text('Bạn có chắc chắn xóa không?!!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          viewModel.removeItem(widget.item.id);
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Xóa'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Item Name:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _nameController,
              readOnly: true,
            ),
            const SizedBox(height: 20),
            const Text(
              'Item Price:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _priceController,
              readOnly: true,
            ),
            const SizedBox(height: 20),
            const Text(
              'Item ID:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.item.id),
          ],
        ),
      ),
    );
  }
}

class SampleItemUpdate extends StatefulWidget {
  final String? initialName;
  final double? initialPrice;

  const SampleItemUpdate({Key? key, this.initialName, this.initialPrice})
      : super(key: key);

  @override
  _SampleItemUpdateState createState() => _SampleItemUpdateState();
}

class _SampleItemUpdateState extends State<SampleItemUpdate> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _priceController = TextEditingController(
      text: widget.initialPrice?.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialName != null ? 'Edit Item' : 'Add Item'),
        actions: [
          IconButton(
            onPressed: () {
              final updatedItem = SampleItem(
                name: _nameController.text,
                price: double.tryParse(_priceController.text) ?? 0.0,
              );
              Navigator.of(context).pop(updatedItem);
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Item Price',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

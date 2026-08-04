import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:inventra/services/item_service.dart';

class AllItemsPage extends StatefulWidget {
  const AllItemsPage({super.key});

  @override
  State<AllItemsPage> createState() => _AllItemsPageState();
}

class _AllItemsPageState extends State<AllItemsPage> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final data = await ItemService.getAllItems();
    if (mounted) {
      setState(() {
        _items = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 70.0),
          child:
              _items.isEmpty
                  ? const Center(child: Text('No items found'))
                  : PaginatedDataTable2(
                    minWidth: 680,
                    dataRowHeight: 70,
                    rowsPerPage: _items.length > 10 ? 10 : _items.length,
                    availableRowsPerPage: const [10],
                    columns: const [
                      DataColumn2(label: Text('Item Code'), size: ColumnSize.S),
                      DataColumn2(label: Text('Item Name'), size: ColumnSize.M),
                      DataColumn2(
                        label: Text('Description'),
                        size: ColumnSize.L,
                      ),
                      DataColumn2(label: Text('Price'), numeric: true),
                      DataColumn2(
                        label: Text('Item Category'),
                        size: ColumnSize.S,
                      ),
                      DataColumn2(label: Text('Taxable')),
                    ],
                    source: ItemDataSource(_items),
                  ),
        ),
      ),
    );
  }
}

class ItemDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;

  ItemDataSource(this._data);

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final item = _data[index];
    return DataRow(
      cells: [
        DataCell(Text(item['item_code'].toString() ?? '')),
        DataCell(Text(item['item_name'].toString() ?? '')),
        DataCell(Text(item['item_description'].toString() ?? '')),
        DataCell(Text(item['price'].toString() ?? '')),
        DataCell(Text(item['item_category'].toString() ?? '')),
        DataCell(Text(item['is_taxable'] == true ? 'Yes' : 'No')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;
}

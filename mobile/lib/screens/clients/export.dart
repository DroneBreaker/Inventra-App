import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:inventra/services/customer_service.dart';

class ExportPage extends StatefulWidget {
  const ExportPage({super.key});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  List<Map<String, dynamic>> _exports = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadExports();
  }

  Future<void> _loadExports() async {
    final data = await CustomerService.getClients(clientType: 'Export');
    if (mounted) {
      setState(() {
        _exports = data;
        _loading = false;
      });
    }
  }

  void _openEditModal(Map<String, dynamic> client) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _EditExportSheet(client: client, onUpdated: _loadExports),
    );
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
              _exports.isEmpty
                  ? const Center(child: Text('No export customers found'))
                  : PaginatedDataTable2(
                    minWidth: 720,
                    dataRowHeight: 80,
                    columnSpacing: 15,
                    rowsPerPage: _exports.length > 10 ? 10 : _exports.length,
                    availableRowsPerPage: const [10],
                    columns: const [
                      DataColumn2(label: Text('Name'), size: ColumnSize.S),
                      DataColumn2(label: Text('TIN'), size: ColumnSize.M),
                      DataColumn2(label: Text('Email'), size: ColumnSize.M),
                      DataColumn2(label: Text('Phone Number')),
                      DataColumn2(label: Text('Action'), size: ColumnSize.S),
                    ],
                    source: ExportDataSource(_exports, _openEditModal),
                  ),
        ),
      ),
    );
  }
}

// ─── DataTableSource ───────────────────────────────────────────────────────────

class ExportDataSource extends DataTableSource {
  final List<Map<String, dynamic>> _data;
  final void Function(Map<String, dynamic>) onEdit;

  ExportDataSource(this._data, this.onEdit);

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) return null;
    final client = _data[index];
    return DataRow(
      cells: [
        DataCell(Text(client['client_name'] ?? '')),
        DataCell(Text(client['client_tin'] ?? '')),
        DataCell(Text(client['client_email'] ?? '')),
        DataCell(Text(client['client_phone'] ?? '')),
        DataCell(
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.amber),
            onPressed: () => onEdit(client),
          ),
        ),
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

// ─── Edit Bottom Sheet ─────────────────────────────────────────────────────────

class _EditExportSheet extends StatefulWidget {
  final Map<String, dynamic> client;
  final VoidCallback onUpdated;

  const _EditExportSheet({required this.client, required this.onUpdated});

  @override
  State<_EditExportSheet> createState() => _EditExportSheetState();
}

class _EditExportSheetState extends State<_EditExportSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.client['client_name'] ?? '');
    _emailCtrl = TextEditingController(
      text: widget.client['client_email'] ?? '',
    );
    _phoneCtrl = TextEditingController(
      text: widget.client['client_phone'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final success = await CustomerService.updateClient(
      id: widget.client['id'] ?? widget.client['ID'] ?? '',
      clientName: _nameCtrl.text.trim(),
      clientEmail: _emailCtrl.text.trim(),
      clientPhone: _phoneCtrl.text.trim(),
    );

    if (mounted) {
      setState(() => _saving = false);
      if (success) {
        widget.onUpdated();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export client updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update export client')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottom + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Export Client',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[800],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _saving
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

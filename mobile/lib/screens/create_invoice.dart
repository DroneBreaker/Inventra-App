import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:inventra/config/app_colors.dart';
import 'package:inventra/config/app_text.dart';
import 'package:inventra/services/customer_service.dart';
import 'package:inventra/services/item_service.dart';
import 'package:inventra/widgets/button.dart';
import 'package:inventra/widgets/forms.dart';
import 'package:inventra/widgets/titles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ---------------------------------------------------------------------------
// GRA E-VAT tax rate constants
// ---------------------------------------------------------------------------
const double VAT_RATE = 0.15;
const double NHIL_RATE = 0.025;
const double GETFUND_RATE = 0.025;
const double CST_RATE = 0.05;
const double TOURISM_RATE = 0.01;
const double EXCISE_RATE = 0.05;

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({super.key});

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController clientTINController = TextEditingController();
  final TextEditingController invoiceDateController = TextEditingController();
  final TextEditingController invoiceTimeController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  final TextEditingController totalVATController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController itemCodeController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemDescriptionController =
      TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final TextEditingController exchangeRateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController totalLevyController = TextEditingController();

  // Item List
  List<Map<String, dynamic>> addedItems = [];
  Map<String, dynamic>? selectedItemData;
  bool showItemDropdown = false;
  List<Map<String, dynamic>> filteredItems = [];

  final _formKey = GlobalKey<FormState>();

  // DATE OPTIONS
  DateTime? selectedInvoiceDate;
  DateTime? selectedDueDate;
  TimeOfDay? selectedInvoiceTime;

  // invoice Date picker
  Future<void> _selectInvoiceDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      setState(() {
        invoiceDateController.text = DateFormat('yyyy-MM-dd').format(date);
        selectedInvoiceDate = date;
      });
    }
  }

  // Due Date picker
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      setState(() {
        dueDateController.text = DateFormat('yyyy-MM-dd').format(date);
        selectedDueDate = date;
      });
    }
  }

  // Time picker
  Future<void> _selectInvoiceTime(BuildContext context) async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      final String formattedTime = time.format(context);

      setState(() {
        invoiceTimeController.text = formattedTime;
        selectedInvoiceTime = time;
      });
    }
  }

  // OPTIONS
  bool isTaxInclusive = true;
  bool isActive = false;
  String activeButton = '';

  // CURRENCY OPTIONS
  final List<String> currencyOptions = ["GHS", "USD", "EUR", "GBP"];
  String? selectedCurrency;

  // Enhanced client management
  List<Map<String, dynamic>> clients = [
    {'name': 'John Doe', 'tin': 'TIN001'},
    {'name': 'Jane Smith', 'tin': 'TIN002'},
    {'name': 'Acme Corporation', 'tin': 'TIN003'},
    {'name': 'Tech Solutions Ltd', 'tin': 'TIN004'},
  ];
  List<Map<String, dynamic>> filteredClients = [];
  bool showClientDropdown = false;
  Map<String, dynamic>? selectedClientData;

  // FLAG OPTIONS
  // "Credit Note" / "Debit Note" route to a separate endpoint — see
  // _sendInvoiceToAPI / _sendNoteToAPI split below.
  String? selectedFlag;
  final List<String> flags = [
    "Invoice",
    "Purchase",
    "Refund",
    "Credit Note",
    "Debit Note",
  ];

  String? selectedSaleType;
  final List<String> saleType = ["NORMAL", "EXPORT"];

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final userDataString = prefs.getString("userData");

    if (userDataString != null) {
      final userData = jsonDecode(userDataString);

      usernameController.text = userData['Username'].toString();

      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    filteredClients = List.from(clients);
    _loadUserData();

    clientNameController.addListener(_onClientNameChanged);
    itemNameController.addListener(_onItemNameChanged);
  }

  @override
  void dispose() {
    clientNameController.removeListener(_onClientNameChanged);
    itemNameController.removeListener(_onItemNameChanged);
    super.dispose();
  }

  void _onClientNameChanged() {
    final query = clientNameController.text.trim();

    if (query.isEmpty) {
      setState(() {
        filteredClients = [];
        showClientDropdown = false;
        selectedClientData = null;
        clientTINController.clear();
      });
      return;
    }

    CustomerService.searchCustomers(query).then((results) {
      if (mounted) {
        setState(() {
          filteredClients = results;
          showClientDropdown = results.isNotEmpty;
        });
      }
    });
  }

  void _selectClient(Map<String, dynamic> client) {
    setState(() {
      selectedClientData = client;
      clientNameController.text = client['name'];
      clientTINController.text = client['tin'] ?? '';
      showClientDropdown = false;
    });
  }

  // Item Search Logic
  void _onItemNameChanged() {
    final query = itemNameController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredItems = [];
        showItemDropdown = false;
      });
      return;
    }

    ItemService.searchItems(query).then((items) {
      if (mounted) {
        setState(() {
          filteredItems = items;
          showItemDropdown = items.isNotEmpty;
        });
      }
    });
  }

  // Item fields come straight from the Go Item model's JSON keys:
  // item_code, name, item_category, amount (unit selling price).
  // "cost" (internal cost-of-goods) is never touched here — it's not
  // part of the invoice payload.
  void _selectItem(Map<String, dynamic> item) {
    setState(() {
      selectedItemData = item;
      itemNameController.text = item['name'];
      priceController.text = item['amount'].toString();
      showItemDropdown = false;
    });
  }

  void _addItemToList() {
    if (selectedItemData == null || quantityController.text.isEmpty) {
      _showErrorDialog('Please select an item and enter quantity');
      return;
    }

    final int quantity = int.tryParse(quantityController.text) ?? 1;
    final double price = double.tryParse(priceController.text) ?? 0.0;

    setState(() {
      addedItems.add({
        ...selectedItemData!,
        'quantity': quantity,
        'final_price': price,
      });

      itemNameController.clear();
      quantityController.clear();
      priceController.clear();
      selectedItemData = null;

      _calculateTotals();
    });
  }

  void _removeItem(int index) {
    setState(() {
      addedItems.removeAt(index);
      _calculateTotals();
    });
  }

  // Live on-screen totals preview. This mirrors the EXCLUSIVE-style
  // calculation for display purposes only — the authoritative,
  // calculationType-aware totals are computed in _prepareInvoiceData()
  // right before submission.
  void _calculateTotals() {
    double totalVAT = 0.0;
    double totalAmount = 0.0;

    for (var item in addedItems) {
      final calc = _calculateItemTaxes(
        item,
        isTaxInclusive ? 'INCLUSIVE' : 'EXCLUSIVE',
      );
      totalVAT += calc['_vat'] as double;
      totalAmount +=
          (calc['unitPrice'] as double) * (calc['quantity'] as double);
    }

    totalVATController.text = totalVAT.toStringAsFixed(2);
    totalAmountController.text = totalAmount.toStringAsFixed(2);
  }

  // ---------------------------------------------------------------------
  // Per-item tax calculation.
  //
  // totalAmount contribution is ALWAYS unitPrice * quantity regardless of
  // calculationType (per the E-VAT spec). What changes between INCLUSIVE
  // and EXCLUSIVE is how VAT/levies/excise are derived from that base.
  //
  // categoryCode comes directly from item['item_category'], which is
  // stored in the DB using the exact API codes: "", "CST", "TRSM", "EXM",
  // "RNT", "EXC_PLASTIC".
  //
  // NOTE: the INCLUSIVE back-calculation for combined CST/Tourism/Excise
  // rates is implemented here per standard practice, but should be
  // verified against GRA's official tax calculation Excel template
  // before relying on it for real submissions.
  // ---------------------------------------------------------------------
  Map<String, dynamic> _calculateItemTaxes(
    Map<String, dynamic> item,
    String calculationType,
  ) {
    final String categoryCode = item['item_category'] ?? '';
    final double unitPrice = (item['final_price'] as num).toDouble();
    final double quantity = (item['quantity'] as num).toDouble();
    final bool isExempt = categoryCode == 'EXM';

    final double grossOrNetBase = unitPrice * quantity;

    double nhil = 0, getfund = 0, cst = 0, tourism = 0, excise = 0, vat = 0;

    if (calculationType == 'EXCLUSIVE') {
      double base = grossOrNetBase;

      if (!isExempt) {
        nhil = base * NHIL_RATE;
        getfund = base * GETFUND_RATE;
      }

      double vatableAmount = base;
      if (categoryCode == 'CST') {
        cst = base * CST_RATE;
        vatableAmount += cst;
      } else if (categoryCode == 'TRSM') {
        tourism = base * TOURISM_RATE;
        vatableAmount += tourism;
      } else if (categoryCode == 'EXC_PLASTIC') {
        excise = base * EXCISE_RATE;
        vatableAmount += excise;
      }

      if (!isExempt) {
        vat = vatableAmount * VAT_RATE;
      }
    } else {
      // INCLUSIVE — back-calculate the base out of the tax-inclusive price.
      double combinedRate = 1.0;
      if (!isExempt) combinedRate += VAT_RATE + NHIL_RATE + GETFUND_RATE;
      if (categoryCode == 'CST') combinedRate += CST_RATE;
      if (categoryCode == 'TRSM') combinedRate += TOURISM_RATE;
      if (categoryCode == 'EXC_PLASTIC') combinedRate += EXCISE_RATE;

      double base = grossOrNetBase / combinedRate;

      if (!isExempt) {
        nhil = base * NHIL_RATE;
        getfund = base * GETFUND_RATE;
      }
      if (categoryCode == 'CST') cst = base * CST_RATE;
      if (categoryCode == 'TRSM') tourism = base * TOURISM_RATE;
      if (categoryCode == 'EXC_PLASTIC') excise = base * EXCISE_RATE;

      double vatableAmount = base + cst + tourism + excise;
      if (!isExempt) vat = vatableAmount * VAT_RATE;
    }

    return {
      'itemCode': item['item_code'] ?? '',
      'itemCategory': categoryCode,
      'description': item['name'] ?? '',
      'quantity': quantity,
      'unitPrice': unitPrice,
      'levyAmountA': double.parse(nhil.toStringAsFixed(2)),
      'levyAmountB': double.parse(getfund.toStringAsFixed(2)),
      'levyAmountC': 0.0, // COVID levy — not applicable from Jan 2026 onward
      'levyAmountD': double.parse(cst.toStringAsFixed(2)),
      'levyAmountE': double.parse(tourism.toStringAsFixed(2)),
      'exciseAmount': double.parse(excise.toStringAsFixed(2)),
      'discountAmount': 0.0,
      '_vat': vat, // internal only — stripped before sending to the API
    };
  }

  Widget _buildItemSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appTitle(title: "Add Items"),
        SizedBox(height: 10),

        Stack(
          children: [
            TextFormField(
              controller: itemNameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Search Item...",
                suffixIcon:
                    itemNameController.text.isNotEmpty
                        ? IconButton(
                          onPressed: () {
                            itemNameController.clear();
                            setState(() {
                              showItemDropdown = false;
                              selectedItemData = null;
                              priceController.clear();
                            });
                          },
                          icon: Icon(Icons.clear),
                        )
                        : Icon(Icons.search),
              ),
              onTap: () {
                if (itemNameController.text.isNotEmpty) {
                  setState(() {
                    showItemDropdown = true;
                  });
                }
              },
            ),
            if (showItemDropdown && filteredItems.isNotEmpty)
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ListTile(
                          title: Text(item['name']),
                          subtitle: Text('Price: ${item['amount']}'),
                          onTap: () => _selectItem(item),
                          dense: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
        Gap(10.h),

        if (selectedItemData != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Selected: ${selectedItemData!['name']}"
              "${(selectedItemData!['item_category'] ?? '').toString().isEmpty ? '' : ' - ${selectedItemData!['item_category']}'}",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        Row(
          children: [
            Expanded(
              child: appInput(
                placeholder: "Price",
                textEditingController: priceController,
                textInputType: TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: appInput(
                placeholder: "Quantity",
                textEditingController: quantityController,
                textInputType: TextInputType.number,
              ),
            ),
            Gap(10.w),
            IconButton(
              onPressed: () => _addItemToList(),
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddedItemsList() {
    if (addedItems.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        appTitle(title: "Items List"),
        SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: addedItems.length,
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = addedItems[index];
            final String category = (item['item_category'] ?? '').toString();
            return Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${item['quantity']} x ${item['final_price']}",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "Category: ${category.isEmpty ? 'Standard' : category}",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeItem(index),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildClientSelection() {
    return Column(
      children: [
        Stack(
          children: [
            TextFormField(
              controller: clientNameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Client Name",
                suffixIcon:
                    clientNameController.text.isNotEmpty
                        ? IconButton(
                          onPressed: () {
                            clientNameController.clear();
                            clientTINController.clear();
                            setState(() {
                              showClientDropdown = false;
                              selectedClientData = null;
                            });
                          },
                          icon: Icon(Icons.clear),
                        )
                        : Icon(Icons.search),
              ),
              onTap: () {
                if (clientNameController.text.isNotEmpty) {
                  setState(() {
                    showClientDropdown = true;
                  });
                }
              },
            ),
            if (showClientDropdown && filteredClients.isNotEmpty)
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredClients.length,
                      itemBuilder: (context, index) {
                        final client = filteredClients[index];
                        return ListTile(
                          title: Text(client['name']),
                          subtitle: Text('TIN: ${client['tin']}'),
                          onTap: () => _selectClient(client),
                          dense: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 20),

        TextFormField(
          controller: clientTINController,
          enabled: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: "Client TIN",
            filled: true,
            fillColor:
                selectedClientData != null
                    ? Colors.green.shade50
                    : Colors.grey.shade100,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accentDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 8,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back, size: 40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 70),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormField<String>(
                        validator: (value) {
                          if (selectedFlag == null) {
                            return 'Please select an invoice type';
                          }
                          return null;
                        },
                        builder: (FormFieldState<String> state) {
                          return Column(
                            children: [
                              appTitle(title: "Create Invoice"),
                              SizedBox(height: 10),

                              appTitle(title: "Select Document Type"),
                              SizedBox(height: 10),
                              Gap(20.h),

                              // Invoice Number TextForm field
                              appInput(
                                placeholder: "Invoice Number",
                                textEditingController: invoiceNumberController,
                                errorMsg: AppText.invoiceNumberError,
                                errorLengthMsg:
                                    AppText.invoiceNumberLengthError,
                              ),
                              Gap(20.h),

                              // Flag Dropdown
                              DropdownButtonFormField(
                                value: selectedFlag,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelText: 'Invoice Type',
                                ),
                                items:
                                    flags.map((String option) {
                                      return DropdownMenuItem(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedFlag = newValue;
                                    });
                                    state.didChange(newValue);
                                  }
                                },
                              ),
                              Gap(20.h),

                              // Currency Dropdown
                              DropdownButtonFormField(
                                value: selectedCurrency,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelText: 'Currency',
                                ),
                                items:
                                    currencyOptions.map((String option) {
                                      return DropdownMenuItem(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedCurrency = newValue;
                                    });
                                  }
                                },
                              ),
                              Gap(20.h),

                              if (selectedCurrency != null &&
                                  selectedCurrency != 'GHS')
                                Column(
                                  children: [
                                    appInput(
                                      placeholder: "Exchange Rate",
                                      textEditingController:
                                          exchangeRateController,
                                      textInputType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                    ),
                                    Gap(20.h),
                                  ],
                                ),
                              Gap(20.h),

                              // Sale Type Textform field
                              DropdownButtonFormField(
                                value: selectedSaleType,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelText: 'Sale Type',
                                ),
                                items:
                                    saleType.map((String option) {
                                      return DropdownMenuItem(
                                        value: option,
                                        child: Text(option),
                                      );
                                    }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedSaleType = newValue;
                                    });
                                  }
                                },
                              ),
                              Gap(20.h),

                              // Username TextForm field
                              appInput(
                                placeholder: "Username",
                                textEditingController: usernameController,
                                isEnabled: false,
                              ),
                              Gap(20.h),

                              _buildClientSelection(),
                              Gap(20.h),

                              // Invoice Date TextForm field
                              Row(
                                children: [
                                  Expanded(
                                    child: appInput(
                                      placeholder: "Invoice Date",
                                      textEditingController:
                                          invoiceDateController,
                                      textInputType: TextInputType.datetime,
                                      onTap:
                                          (value) =>
                                              print('Invoice Date: $value'),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed:
                                        () => _selectInvoiceDate(context),
                                    icon: Icon(Icons.calendar_month, size: 30),
                                  ),
                                ],
                              ),
                              Gap(20.h),

                              // Invoice Time TextForm field
                              Row(
                                children: [
                                  Expanded(
                                    child: appInput(
                                      placeholder: "Invoice Time",
                                      textEditingController:
                                          invoiceTimeController,
                                      onTap:
                                          (value) =>
                                              print('Invoice Time: $value'),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed:
                                        () => _selectInvoiceTime(context),
                                    icon: Icon(Icons.calendar_month, size: 30),
                                  ),
                                ],
                              ),
                              Gap(20.h),

                              // Due Date (kept for internal/local tracking —
                              // not part of the E-VAT payload)
                              Row(
                                children: [
                                  Expanded(
                                    child: appInput(
                                      placeholder: "Due Date",
                                      textEditingController: dueDateController,
                                      textInputType: TextInputType.datetime,
                                      onTap:
                                          (value) => print('Due Date: $value'),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _selectDueDate(context),
                                    icon: Icon(Icons.calendar_month, size: 30),
                                  ),
                                ],
                              ),
                              Gap(20.h),

                              _buildItemSelection(),
                              Gap(20.h),

                              _buildAddedItemsList(),

                              // Total VAT TextForm field
                              appInput(
                                placeholder: "Total VAT",
                                textEditingController: totalVATController,
                                isEnabled: false,
                              ),
                              Gap(20.h),

                              appInput(
                                placeholder: "Total Levy",
                                textEditingController: totalLevyController,
                                isEnabled: false,
                              ),
                              Gap(20.h),

                              // Total Amount TextForm field
                              appInput(
                                placeholder: "Total Amount",
                                textEditingController: totalAmountController,
                                isEnabled: false,
                              ),
                              Gap(20.h),

                              // Tax inclusive/exclusive toggle
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  appParagraph(
                                    title: "Prices include tax",
                                    fontSize: 16,
                                  ),
                                  Switch(
                                    value: isTaxInclusive,
                                    onChanged: (value) {
                                      setState(() {
                                        print("Switch changed to: $value");

                                        isTaxInclusive = value;
                                        _calculateTotals();
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Gap(20.h),

                              // Button
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange[400],
                                  ),
                                  onPressed: () {
                                    handleInvoice();
                                  },
                                  child: appParagraph(
                                    title: "Submit",
                                    fontSize: 17,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                              Gap(40.h),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleInvoice() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_validateRequiredFields()) {
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      final invoiceData = await _prepareInvoiceData();

      final bool isNote =
          selectedFlag == 'Credit Note' || selectedFlag == 'Debit Note';
      final response =
          isNote
              ? await _sendNoteToAPI(invoiceData)
              : await _sendInvoiceToAPI(invoiceData);

      if (mounted) Navigator.of(context).pop(); // hide loading indicator

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invoice created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _clearForm();
        if (mounted) Navigator.of(context).pop();
      } else {
        _showErrorDialog(response['message'] ?? 'Failed to create invoice');
      }
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      _showErrorDialog('Network error: ${e.toString()}');
    }
  }

  bool _validateRequiredFields() {
    List<String> missingFields = [];

    if (selectedFlag == null || selectedFlag!.isEmpty) {
      missingFields.add('Invoice Type');
    }
    if (invoiceNumberController.text.trim().isEmpty) {
      missingFields.add('Invoice Number');
    }
    if (clientNameController.text.trim().isEmpty) {
      missingFields.add('Client Name');
    }
    if (invoiceDateController.text.trim().isEmpty) {
      missingFields.add('Invoice Date');
    }
    if (invoiceTimeController.text.trim().isEmpty) {
      missingFields.add('Invoice Time');
    }
    if (selectedCurrency == null) {
      missingFields.add('Currency');
    }
    if (addedItems.isEmpty) {
      missingFields.add('At least one item');
    }

    if (missingFields.isNotEmpty) {
      _showErrorDialog(
        'Please fill the following required fields:\n• ${missingFields.join('\n• ')}',
      );
      return false;
    }

    if (selectedInvoiceDate == null) {
      _showErrorDialog('Please select a valid invoice date');
      return false;
    }

    if (selectedCurrency != 'GHS' &&
        (double.tryParse(exchangeRateController.text) == null)) {
      _showErrorDialog('Please enter a valid exchange rate');
      return false;
    }

    return true;
  }

  // ---------------------------------------------------------------------
  // reference = companyTIN-branchCode, used in the URL path.
  // branch_code defaults to "001" (head office) if not set at login.
  // ---------------------------------------------------------------------
  Future<String> _buildReference() async {
    final prefs = await SharedPreferences.getInstance();
    final companyTin = prefs.getString('company_tin') ?? 'CXX000000YY';
    final branchCode = prefs.getString('branch_code') ?? '008';
    return '$companyTin-$branchCode';
  }

  Future<Map<String, dynamic>> _prepareInvoiceData() async {
    final String calculationType = isTaxInclusive ? 'INCLUSIVE' : 'EXCLUSIVE';

    final List<Map<String, dynamic>> itemPayloads =
        addedItems
            .map((item) => _calculateItemTaxes(item, calculationType))
            .toList();

    double totalAmount = 0, totalVat = 0, totalLevy = 0, totalExcise = 0;

    for (var itemPayload in itemPayloads) {
      totalAmount +=
          (itemPayload['unitPrice'] as double) *
          (itemPayload['quantity'] as double);
      totalVat += itemPayload['_vat'] as double;
      totalLevy +=
          (itemPayload['levyAmountA'] as double) +
          (itemPayload['levyAmountB'] as double) +
          (itemPayload['levyAmountC'] as double) +
          (itemPayload['levyAmountD'] as double) +
          (itemPayload['levyAmountE'] as double);
      totalExcise += itemPayload['exciseAmount'] as double;
    }

    // Strip internal-only field before sending to the API
    final cleanItems =
        itemPayloads.map((i) {
          final copy = Map<String, dynamic>.from(i);
          copy.remove('_vat');
          return copy;
        }).toList();

    return {
      "flag": _convertFlagToEnum(selectedFlag!),
      "invoiceNumber": invoiceNumberController.text.trim(),
      "userName": usernameController.text.trim(),
      "currency": selectedCurrency ?? 'GHS',
      "exchangeRate":
          selectedCurrency == 'GHS'
              ? 1.0
              : (double.tryParse(exchangeRateController.text) ?? 1.0),
      "calculationType": calculationType,
      "saleType": selectedSaleType ?? "NORMAL",
      "transactionDate": DateFormat('yyyy-MM-dd').format(selectedInvoiceDate!),
      "businessPartnerName": clientNameController.text.trim(),
      "businessPartnerTin":
          clientTINController.text.trim().isEmpty
              ? "0000000000"
              : clientTINController.text.trim(),
      "totalAmount": double.parse(totalAmount.toStringAsFixed(2)),
      "totalVat": double.parse(totalVat.toStringAsFixed(2)),
      "totalLevy": double.parse(totalLevy.toStringAsFixed(2)),
      "totalExciseAmount": double.parse(totalExcise.toStringAsFixed(2)),
      "items": cleanItems,
    };
  }

  String _convertFlagToEnum(String flag) {
    switch (flag) {
      case 'Invoice':
        return 'INVOICE';
      case 'Purchase':
        return 'PURCHASE';
      case 'Refund':
        return 'REFUND';
      case 'Credit Note':
        return 'CREDIT_NOTE'; // confirm exact value once note endpoint docs are available
      case 'Debit Note':
        return 'DEBIT_NOTE'; // confirm exact value once note endpoint docs are available
      default:
        return 'INVOICE';
    }
  }

  // ---------------------------------------------------------------------
  // Invoice / Purchase / Refund submission.
  // ---------------------------------------------------------------------
  Future<Map<String, dynamic>> _sendInvoiceToAPI(
    Map<String, dynamic> invoiceData,
  ) async {
    const String baseUrl =
        'https://vsdcstaging.vat-gh.com/vsdc/api/v1/taxpayer';
    const String securityKey =
        'Yqu34/kLbewAY1NCH3lKjUEaZFFNtoxpiLzKGI8JrcdrUmxO9ud8dZO2Nx/mQPAE'; // from staging credentials

    return _postToVsdc(
      endpointSuffix: 'invoice',
      baseUrl: baseUrl,
      securityKey: securityKey,
      invoiceData: invoiceData,
    );
  }

  // ---------------------------------------------------------------------
  // Credit Note / Debit Note submission — separate endpoint.

  Future<Map<String, dynamic>> _sendNoteToAPI(
    Map<String, dynamic> invoiceData,
  ) async {
    const String baseUrl =
        'https://vsdcstaging.vat-gh.com/vsdc/api/v1/taxpayer';
    const String securityKey =
        'Yqu34/kLbewAY1NCH3lKjUEaZFFNtoxpiLzKGI8JrcdrUmxO9ud8dZO2Nx/mQPAE';

    return _postToVsdc(
      endpointSuffix: 'note', // TODO: confirm actual path segment
      baseUrl: baseUrl,
      securityKey: securityKey,
      invoiceData: invoiceData,
    );
  }

  Future<Map<String, dynamic>> _postToVsdc({
    required String endpointSuffix,
    required String baseUrl,
    required String securityKey,
    required Map<String, dynamic> invoiceData,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final appAuthToken = prefs.getString('jwt_token');

    if (appAuthToken == null) {
      return {
        'success': false,
        'message': 'You must be logged in to submit an invoice',
      };
    }

    final reference = await _buildReference();
    final endpoint = '$baseUrl/$reference/$endpointSuffix';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'security_key': securityKey,
          'Authorization': 'Bearer $appAuthToken',
        },
        body: json.encode(invoiceData),
      );

      if (response.statusCode >= 201 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        return {
          'success': true,
          'data': responseData,
          'message': 'Invoice created successfully',
        };
      } else {
        String errorMessage = 'Failed to create invoice';
        try {
          final errorData = json.decode(response.body);
          errorMessage =
              errorData['message'] ?? errorData['error'] ?? errorMessage;
        } catch (e) {
          errorMessage =
              'HTTP ${response.statusCode}: ${response.reasonPhrase}';
        }

        return {
          'success': false,
          'message': errorMessage,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    invoiceNumberController.clear();
    clientNameController.clear();
    clientTINController.clear();
    invoiceDateController.clear();
    invoiceTimeController.clear();
    dueDateController.clear();
    totalVATController.clear();
    totalAmountController.clear();
    exchangeRateController.clear();

    setState(() {
      selectedFlag = null;
      selectedCurrency = null;
      activeButton = '';
      selectedInvoiceDate = null;
      selectedDueDate = null;
      selectedInvoiceTime = null;
      selectedClientData = null;
      showClientDropdown = false;
      addedItems = [];
      isTaxInclusive = true;
    });
  }
}

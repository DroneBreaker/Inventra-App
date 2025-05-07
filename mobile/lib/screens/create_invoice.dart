import 'package:flutter/material.dart';
import 'package:inventra/wrappers/main_wrapper.dart';
import 'package:inventra/widgets/app_text.dart';

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({super.key});

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController businessPartnerController =
      TextEditingController();
  final TextEditingController businessTINController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController invoiceNumberController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController itemCodeController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemDescriptionController =
      TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // DATE OPTIONS
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // OPTIONS
  bool isTaxInclusive = true;
  bool isTaxable = true;
  bool isDiscount = false;
  bool isActive = false;
  String activeButton = '';

  // CST OR TOURISM OPTIONS
  final List<String> tourismOrCSTOptions = ['None', 'Tourism', 'CST'];
  String selectedTourismOrCST = "None";

  // ITEM CATEGORY OPTIONS
  final List<String> itemCategoryOptions = ['Regular VAT', 'Rent', 'Exempt'];
  String selectedItemCategory = "Regular VAT";

  // CURRENCY OPTIONS
  final List<String> currencyOptions = ["GHS", "USD", "EUR", "GBP"];
  String selectedCurrency = "GHS";

  // BUSINESS PARTNER OPTIONS
  String selectedBusinessPartner = "Customer";
  final List<String> businessPartnerOptions = [
    'Customer',
    'Supplier',
    "Exempt"
  ];
  List<Map<String, dynamic>> partners = [];
  List<Map<String, dynamic>> filteredPartners = [];

  // FLAG OPTIONS
  String? selectedFlag;
  final List<Map<String, dynamic>> flags = [
    {
      'text': 'Invoice',
      'icon': Icons.inventory,
    },
    {
      'text': 'Purchase',
      'icon': Icons.shopping_cart,
    },
    {
      'text': 'Refund',
      'icon': Icons.assignment_return,
    },
    {
      'text': 'Credit Note',
      'icon': Icons.note,
    },
  ];


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [

              ],
            ),
          ),
        )
      ),
    );
  }
}
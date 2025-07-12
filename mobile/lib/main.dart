import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventra/config/routes.dart';
import 'package:inventra/screens/auth/register.dart';
import 'package:inventra/screens/auth/login.dart';
// import 'package:inventra/screens/clients/export.dart';
// import 'package:inventra/screens/clients/supplier.dart';
import 'package:inventra/screens/create_invoice.dart';
import 'package:inventra/screens/expenses.dart';
// import 'package:inventra/screens/home.dart';
import 'package:inventra/wrappers/main_wrapper.dart';
import 'package:inventra/screens/intro.dart';
import 'package:inventra/screens/invoices.dart';
import 'package:inventra/screens/user.dart';
import 'package:inventra/wrappers/advance_invoice_wrapper.dart';
import 'package:inventra/wrappers/customer_wrapper.dart';
import 'package:inventra/wrappers/income_wrapper.dart';
import 'package:inventra/wrappers/item_wrapper.dart';
import 'package:inventra/screens/items/all_items.dart';
import 'package:inventra/screens/menu.dart';
import 'package:inventra/screens/reports.dart';

void main() {
  runApp(
    const MyApp()
    );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 864),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: RouteNames.intro,
          // onGenerateRoute: GenerateRoute.onGenerateRoute,
          routes: {
            RouteNames.login: (context) => const LoginPage(),
            RouteNames.register: (context) => const RegisterPage(),
            RouteNames.home: (context) => const MainWrapper(),
            RouteNames.invoices: (context) => const InvoicePage(),
            RouteNames.reports: (context) => ReportPage(),
            RouteNames.menu: (context) => MenuPage(),
            RouteNames.createInvoice: (context) => const CreateInvoice(),
            RouteNames.advanceInvoice: (context) => const AdvanceInvoiceWrapper(),
            RouteNames.customers: (context) => const CustomerWrapper(),
            // RouteNames.suppliers: (context) => SupplierPage(),
            // RouteNames.exports: (context) => ExportPage(),
            RouteNames.items: (context) => const ItemWrapper(),
            RouteNames.allItems: (context) => const AllItemsPage(),
          RouteNames.income: (context) => const IncomeWrapper(),
            RouteNames.expenses: (context) => const ExpensesPage(),
            RouteNames.users: (context) => const UserManagementPage(),
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: const IntroPage(),
        );  
      },
    );
  }
}


// mercy black

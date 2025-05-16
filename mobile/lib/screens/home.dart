import 'package:flutter/material.dart';
import 'package:inventra/constants/app_colors.dart';
import 'package:inventra/widgets/app_text.dart';
import 'package:inventra/widgets/categories.dart';
import 'package:inventra/widgets/transaction.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(left: 30.0, top: 20, right: 35),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.notification_add, size: 30, color: Colors.black),
                    Expanded(
                      child: Center(
                          child: AppText(title: "Droners Inc", colors: Colors.black, fontSize: 20)
                        ),
                    ),
                    IconButton(
                      onPressed: () {}, 
                      icon: Icon(Icons.notifications_active, size: 30, color: Colors.black)
                    )
                  ],
                ),
                
                const SizedBox(height: 15),
                
                // Dashboard summary
                Container(
                  height: MediaQuery.of(context).size.height * 0.16,
                  decoration: BoxDecoration(
                    color: AppColors.grey400.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            AppText(title: "Total Invoices", colors: Colors.black),
                            AppText(title: "35", fontSize: 30, colors: Colors.black),
                            AppText(title: "Last 24 hours", colors: Colors.black),
                          ],
                        ),
                        Column(
                          children: [
                            AppText(title: "Paid Invoices", colors: Colors.black),
                            AppText(title: "30", fontSize: 30, colors: Colors.black),
                            AppText(title: "Last 24 hours", colors: Colors.black),
                          ],
                        ),
                        Column(
                          children: [
                            AppText(title: "Total Invoices", colors: Colors.black),
                            AppText(title: "35", fontSize: 30, colors: Colors.black),
                            AppText(title: "Last 24 hours", colors: Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Categories
                buildCategories(),
                
                const SizedBox(height: 10),
                
                // Transaction section
                transaction(),
              ],
            ),
          ),
        ),
    );
  }
}
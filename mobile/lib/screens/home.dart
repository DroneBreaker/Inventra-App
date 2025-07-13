import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:inventra/config/app_colors.dart';
import 'package:inventra/widgets/titles.dart';
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
                          child: appTitle(title: "Droners Inc", color: Colors.black)
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
                    color: AppColors.grey400.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6, top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            appParagraph(title: "Total Invoices", color: Colors.black),
                            appTitle(title: "35", color: Colors.black),
                            appParagraph(title: "Last 24 hours", color: Colors.black),
                          ],
                        ),
                        Gap(4.w),

                        Column(
                          children: [
                            appParagraph(title: "Paid Invoices", color: Colors.black),
                            appTitle(title: "30", color: Colors.black),
                            appParagraph(title: "Last 24 hours", color: Colors.black),
                          ],
                        ),

                        Gap(4.w),
                        Column(
                          children: [
                            appParagraph(title: "Total Invoices", color: Colors.black),
                            appTitle(title: "35", color: Colors.black),
                            appParagraph(title: "Last 24 hours", color: Colors.black),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(20.h),
                
                // Categories
                buildCategories(),
                
                Gap(20.h),
                
                // Transaction section
                transaction(),
              ],
            ),
          ),
        ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:inventra/config/app_colors.dart';
import 'package:inventra/widgets/titles.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 8,
              child: IconButton(
              onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, size: 40,)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Column(
                  children: [
                    Gap(350.h),
                    Center(
                      child: appTitle(title: "THE EXPENSES PAGE IS UNDER CONSTRUCTION!"),
                    ),
                    Center(
                      child: appParagraph(title: "We will be back soon!"),
                    ),
                    Gap(30.h),
                    SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/home");
                        }, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange
                        ),
                        child: appParagraph(title: "Go Back", color: AppColors.white)),
                    )
                  ],
                ),
            ),
          ],
        )
      ),
    );
  }
}
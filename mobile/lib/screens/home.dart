import 'package:flutter/material.dart';
import 'package:inventra/constants/app_colors.dart';
import 'package:inventra/widgets/app_text.dart';
import 'package:inventra/widgets/bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
              padding: const EdgeInsets.only(left: 30.0,  top: 10, right: 35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.notification_add, size: 30, color: Colors.black,),
                        Padding(
                          padding: const EdgeInsets.only(right: 120.0),
                          child: AppText(title: "Droners Inc", colors: Colors.black, fontSize: 20,),
                        ),
                       IconButton(onPressed: () {}, icon: Icon(Icons.notifications_active, size: 30, color: Colors.black,))
                      ],
                    ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.16,
                        decoration: BoxDecoration(
                          // gradient: LinearGradient(colors: [
                          //   AppColors.white,
                          //   AppColors.accentDark
                          // ]),
                          color: AppColors.grey400,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  AppText(title: "Total Invoices", colors: Colors.black,),
                                  AppText(title: "35", fontSize: 30, colors: Colors.black,),
                                  AppText(title: "Last 24 hours", colors: Colors.black,),
                                ],
                              ),
                              Column(
                                children: [
                                  AppText(title: "Paid Invoices", colors: Colors.black,),
                                  AppText(title: "30", fontSize: 30, colors: Colors.black,),
                                  AppText(title: "Last 24 hours", colors: Colors.black,),
                                ],
                              ),
                              Column(
                                children: [
                                  AppText(title: "Total Invoices", colors: Colors.black,),
                                  AppText(title: "35", fontSize: 30, colors: Colors.black,),
                                  AppText(title: "Last 24 hours", colors: Colors.black,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 60,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey
                              ),
                              child: IconButton(onPressed: () {}, icon: Icon(Icons.create)),
                            ),
                            const SizedBox(height: 5,),
                            AppText(title: "Create Invoice")
                          ],
                        ),
                        Text("data"),
                        Text("data"),
                      ],
                    ),
                    Row()
                  ],
                ),
            ),
          ),
        ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:inventra/widgets/app_text.dart';

class AuthorityPage extends StatefulWidget {
  const AuthorityPage({super.key});

  @override
  State<AuthorityPage> createState() => _AuthorityPageState();
}

class _AuthorityPageState extends State<AuthorityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: 
    appText(title: "We are currently under development", fontSize: 30, fontWeight: FontWeight.bold,),
    ),
  );
  }
}
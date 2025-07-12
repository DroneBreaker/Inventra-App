import 'package:flutter/material.dart';

Widget appInput({required String placeholder, required TextEditingController 
  textEditingController, required String errorMsg, required String errorLengthMsg
}) {
  final formKey = GlobalKey<FormState>();
  return Form(
    key: formKey,
    child: TextFormField(
      controller: textEditingController,
      validator: (value) {
        if(value == null || value.isEmpty) {
          return errorMsg;
        }
        if(value.length < 6) {
          errorLengthMsg; 
        }
      },
    )
  );
}
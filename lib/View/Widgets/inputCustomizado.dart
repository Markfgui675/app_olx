import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCustomizado extends StatelessWidget {

  final TextEditingController? controller;
  final String hint;
  final bool obscure;
  final bool autofocus;
  final TextInputType type;
  final int? maxLines;
  final List<TextInputFormatter> inputFormatter;
  final String? Function(String?)? validator;

  InputCustomizado({
      this.controller,
      required this.hint,
      this.obscure = false,
      this.autofocus = false,
      this.type = TextInputType.text,
      required this.inputFormatter,
      this.maxLines,
      required this.validator
    });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      autofocus: this.autofocus,
      obscureText: this.obscure,
      keyboardType: this.type,
      maxLines: this.maxLines,
      validator: this.validator,
      inputFormatters: this.inputFormatter,
      style: const TextStyle(
          fontSize: 20
      ),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
          hintText: this.hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6)
          )
      ),
    );
  }
}


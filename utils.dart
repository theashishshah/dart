library math_utils;

import "dart:convert";

import "package:intl/intl.dart";

int add(int a, int b) => a + b;

int difference(int a, int b) => a - b;

bool isValidEmail(String email) =>
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

bool isStrongPassword(String pass) => pass.length >= 8;

String formatRuppe(double amount) =>
    NumberFormat.currency(symbol: "₹", decimalDigits: 2).format(amount);

// ignore_for_file: file_names

String? validateEmaill(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) return "E-mail adress required.";

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) return "Invalid e-mail adress";
  return null;
}

String? validaPassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return "Password is required.";
  }

  String pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword)) {
    return "Password must be at least 8 chatacters, include latter and number";
  }
  return null;
}

String? validateName(String? formName) {
  if (formName == null || formName.isEmpty) return "Name and surname required";

  String pattern = r"^[a-zA-Z]+(([a-zA-Z ])?[a-zA-Z]*)*$";
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formName)) return "Type your name and surname correctylr";
  return null;
}

String? validateNickname(String? formNickname) {
  if (formNickname == null || formNickname.isEmpty) return "Nickname required";

  String pattern = r'^[a-zA-Z0-9]+$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formNickname)) return "You can use numeric ";
  return null;
}

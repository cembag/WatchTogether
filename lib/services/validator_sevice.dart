class ValidatorService {
  final String? text;
  ValidatorService({required this.text});

  // static bool get validatePhoneNumber {
  //   if(text == null) return false;
  // }

  String validatePhoneNumber() {
    if(text == null) return "Telefon numarası boş bırakılamaz";
    return text!.length < 15 ? "Geçersiz bir telefon numarası girdiniz" : "";
  }
}
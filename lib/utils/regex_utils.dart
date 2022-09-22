class RegexUtils {
  static String matchAll() {
    return ".";
  }

  static String matchWords() {
    return "^[a-zA-Z ]+\$";
  }

  static String matchNumbers() {
    return "^[0-9]+\$";
  }

  static String matchCurrency() {
    return "^[0-9,\\. ]+\$";
  }

  static String matchWordsAndNumbers() {
    return "^[a-zA-Z0-9 ]+\$";
  }

  static String matchPhone() {
    return "^\\+{0,1}[0-9 ]+\$";
  }

  static String matchCNPJ() {
    return "^\\d{2}\\.\\d{3}\\.\\d{3}\\/\\d{4}\\-\\d{2}\$";
  }

  static String matchCPF() {
    return "^\\d{3}\\.\\d{3}\\.\\d{3}\\-\\d{2}\$";
  }

  static String matchEmail() {
    return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
  }

  static String matchCorreios() {
    return "^[A-Z]{2}[0-9]{9}[A-Z]{2}";
  }
}

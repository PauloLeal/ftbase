import 'package:ftbase/ftbase.dart';

import 'http_utils.dart';

class CepData {
  String cep, logradouro, complemento, bairro, localidade, uf, ddd;

  CepData._internal({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.ddd,
  });

  factory CepData.fromMap(dynamic map) {
    return CepData._internal(
      cep: map["cep"] as String,
      logradouro: map["logradouro"] as String,
      complemento: map["complemento"] as String,
      bairro: map["bairro"] as String,
      localidade: map["localidade"] as String,
      uf: map["uf"] as String,
      ddd: map["ddd"] as String,
    );
  }
}

class BrUtils {
  static Future<CepData> checkCEP(String cep) async {
    String c = cep.replaceAll("-", "");
    final res = await HttpUtils.getJson("https://viacep.com.br/ws/$c/json/", {});
    return CepData.fromMap(HttpUtils.unmarshalJson(res.body));
  }

  static int _checkDigitCnpj(String s) {
    int index = 2;

    List<int> reverse = s.split("").map((s) => int.parse(s)).toList().reversed.toList();

    int sum = 0;

    for (var number in reverse) {
      sum += number * index;
      index = (index == 9 ? 2 : index + 1);
    }

    int mod = sum % 11;

    return (mod < 2 ? 0 : 11 - mod);
  }

  static int _mod11(String s) {
    List<int> numbers = s.split("").map((number) => int.parse(number, radix: 10)).toList();

    int modulus = numbers.length + 1;

    List<int> multiplied = [];

    for (var i = 0; i < numbers.length; i++) {
      multiplied.add(numbers[i] * (modulus - i));
    }

    int mod = multiplied.reduce((buffer, number) => buffer + number) % 11;

    return (mod < 2 ? 0 : 11 - mod);
  }

  static bool validadeCpf(String cpf) {
    if (RegExp(r"[a-zA-Z]").firstMatch(cpf) != null) {
      return false;
    }

    cpf = cpf.replaceAll(RegExp(r"[^\d]"), "");

    bool allDigitsEqual = true;

    for (int i = 1; i < cpf.length; i++) {
      if (cpf[i] != cpf[i - 1]) {
        allDigitsEqual = false;
        break;
      }
    }

    if (cpf.length != 11 || cpf == "12345678909" || allDigitsEqual) {
      return false;
    }

    String n = cpf.substring(0, 9);
    n += _mod11(n).toString();
    n += _mod11(n).toString();

    return n == cpf;
  }

  static bool validadeCnpj(String cnpj) {
    if (RegExp(r"[a-zA-Z]").firstMatch(cnpj) != null) {
      return false;
    }

    cnpj = cnpj.replaceAll(RegExp(r"[^\d]"), "");

    bool allDigitsEqual = true;

    for (int i = 1; i < cnpj.length; i++) {
      if (cnpj[i] != cnpj[i - 1]) {
        allDigitsEqual = false;
        break;
      }
    }

    if (cnpj.length != 14 || cnpj == "12345678909" || allDigitsEqual) {
      return false;
    }

    // String n = cnpj.substring(0, 12);
    // n += _mod11(n).toString();
    // n += _mod11(n).toString();

    // return n == cnpj;
    String n = cnpj.substring(0, 12);
    n += _checkDigitCnpj(n).toString();
    n += _checkDigitCnpj(n).toString();

    return n == cnpj;
  }
}

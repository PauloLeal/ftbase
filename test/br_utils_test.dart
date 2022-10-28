import 'package:ftbase/utils/br_utils.dart';
import 'package:test/test.dart';

void main() {
  test("Test CPF validator", () {
    expect(BrUtils.validadeCpf("334.616.710-02"), true);
    expect(BrUtils.validadeCpf("334.616.710-01"), false);
    expect(BrUtils.validadeCpf("35999906032"), true);
    expect(BrUtils.validadeCpf("35999906031"), false);
    expect(BrUtils.validadeCpf("033461671002"), false);
    expect(BrUtils.validadeCpf("03346teste1671002@mail"), false);
    expect(BrUtils.validadeCpf("57abc803.6586-52"), false);
    expect(BrUtils.validadeCpf("03.3461.67100-2"), false);

    List<String> blackListed = [
      "00000000000",
      "11111111111",
      "22222222222",
      "33333333333",
      "44444444444",
      "55555555555",
      "66666666666",
      "77777777777",
      "88888888888",
      "99999999999",
      "12345678909"
    ];

    for (var cpf in blackListed) {
      expect(BrUtils.validadeCpf(cpf), false);
    }
  });

  test("Test CNPJ validator", () {
    expect(BrUtils.validadeCnpj("12.175.094/0001-19"), true);
    expect(BrUtils.validadeCnpj("12.175.094/0001-18"), false);
    expect(BrUtils.validadeCnpj("17942159000128"), true);
    expect(BrUtils.validadeCnpj("17942159000128@mail.com"), false);
    expect(BrUtils.validadeCnpj("17942159000128"), true);
    expect(BrUtils.validadeCnpj("17942159000127"), false);
    expect(BrUtils.validadeCnpj("017942159000128"), false);

    List<String> blackListed = [
      "00000000000000",
      "11111111111111",
      "22222222222222",
      "33333333333333",
      "44444444444444",
      "55555555555555",
      "66666666666666",
      "77777777777777",
      "88888888888888",
      "99999999999999"
    ];

    for (var cnpj in blackListed) {
      expect(BrUtils.validadeCnpj(cnpj), false);
    }
  });
}

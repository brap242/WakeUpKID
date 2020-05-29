import 'dart:ui';

class KidColors {
  static const background = Color(0xFF713684);
  static const ikona = Color(0xFFA317A9);
  static const fore = Color(0xFF2BF6FE);
  static const vstavani = Color(0xFF482C8C); // 0
  static const mazleni = Color(0xFF55328E); // 1
  static const oblenkani = Color(0xFF613990); // 2
  static const rozcvicka = Color(0xFF6E3F92); // 3
  static const snidane = Color(0xFF7A4594); // 4
  static const kontrola_aktovky = Color(0xFF8B509B); // 5
  static const zuby_vlasy = Color(0xFFA560B0); // 6
  static const adekvatni_ustrojovani = Color(0xFFB76DB7); // 7
  static const odchazeni = Color(0xFFC978C9); // 8
  static const cesta_do_skoly = Color(0xFFD38AD3); // 9
  static const covid = Color(0xFFA05DA0); // 10

  static Map<int, Color> itemGradient = {
    0: vstavani,
    1: mazleni,
    2: oblenkani,
    3: rozcvicka,
    4: snidane,
    5: kontrola_aktovky,
    6: zuby_vlasy,
    7: adekvatni_ustrojovani,
    8: odchazeni,
    9: cesta_do_skoly,
    10: covid,
    11: covid,
    12: covid,
  };
}

class Langugage {
  final int id;
  final String flag;
  final String name;
  final String langugeCode;

  Langugage(this.id, this.flag, this.name, this.langugeCode);

  static List<Langugage> languageList() {
    return <Langugage>[
      Langugage(1, "🇺🇸", "English", "en"),
      Langugage(2, "🇻🇳", "Tiếng Việt", "vi"),
    ];
  }
}
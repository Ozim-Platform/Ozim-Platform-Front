class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "🇺🇿", "Uzbek", "uz"),
      Language(2, "🇷🇺", "Pусский", "ru"),
      // Language(4, "🇺🇿", "English", "en"),
    ];
  }

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      json['id'],
      json['flag'],
      json['name'],
      json['language_code'],
    );
  }
}

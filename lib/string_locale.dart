import 'package:flutter/material.dart';

class StringLocale {
  Locale _locale;
  final BuildContext context;

  StringLocale(this.context) {
    this._locale = Localizations.localeOf(this.context);
  }

  Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title':
          "Enter the binary value in the field below to obtain its decimal equivalent.",
          'result': 'Result...'
    },
    'pt': {
      'title': 'Insira o valor binário no campo abaixo para obter seu equivalente decimal.',
      'result': 'Resultado...'
    },
  };

  String get title {
    return _value('title');
  }

  String get result {
    return _value('result');
  }

  String _value(String prop){
    if(_localizedValues[_locale.languageCode] != null) {
      return _localizedValues[_locale.languageCode][prop];
    }else{
      return _localizedValues['en'][prop];
    }
  }
}

import 'package:flutter/widgets.dart';

import 'traducoes/traducoes.dart';

/// Centraliza todos os recursos do aplicativ
class R {
  static Strings strings = PtBr();

  static void carrega(Locale local) {
    switch (local.toString()) {
      case 'en_US':
        strings = EnUs();
        break;

      default:
        strings = PtBr();
        break;
    }
  }
}

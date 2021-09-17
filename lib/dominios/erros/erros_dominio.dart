enum ErrosDominio { inesperado, credenciaisInvalidas }

extension ExtensaoErrosDominio on ErrosDominio {
  String get descricao {
    switch (this) {
      case ErrosDominio.credenciaisInvalidas:
        return 'Credenciais inválidas';
      default:
        return '';
    }
  }
}

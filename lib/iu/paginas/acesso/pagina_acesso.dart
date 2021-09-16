import 'package:flutter/material.dart';

import '../../componentes/componentes.dart';
import 'apresentacao_acesso.dart';

class PaginaAcesso extends StatelessWidget {
  final ApresentacaoAcesso apresentacao;

  const PaginaAcesso(this.apresentacao);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(
      builder: (context) {
        apresentacao.paginaEstaCarregandoStream.listen((estaCarregando) {
          if (estaCarregando) {
            showDialog(
              context: context,
              barrierDismissible:
                  false, // não quero que o usuario consiga clicar de fora do Carregando e fechar
              builder: (context) {
                return SimpleDialog(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Aguarde ... ',
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ],
                );
              },
            );
          } else {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            }
          }
        });
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CabecalhoAcesso(),
              Titulo1(
                texto: 'Login',
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      StreamBuilder<String>(
                        stream: apresentacao.emailComErroStream,
                        builder: (context, snapshot) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: apresentacao.validaEmail,
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 32),
                        child: StreamBuilder<String>(
                          stream: apresentacao.senhaComErroStream,
                          builder: (context, snapshot) {
                            return TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                icon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
                              ),
                              obscureText: true,
                              onChanged: apresentacao.validaSenha,
                            );
                          },
                        ),
                      ),
                      StreamBuilder(
                        stream: apresentacao.camposSaoValidosStream,
                        builder: (context, snapshot) {
                          return RaisedButton(
                            onPressed: snapshot.data == true ? apresentacao.autenticador : null,
                            child: Text('Entrar'.toUpperCase()),
                          );
                        },
                      ),
                      FlatButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.person),
                        label: Text('Criar Conta'),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    ));
  }
}

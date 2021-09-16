import 'package:flutter/material.dart';

import '../../componentes/componentes.dart';
import 'apresentacao_acesso.dart';

class PaginaAcesso extends StatefulWidget {
  final ApresentacaoAcesso apresentacao;

  const PaginaAcesso(this.apresentacao);

  @override
  _PaginaAcessoState createState() => _PaginaAcessoState();
}

class _PaginaAcessoState extends State<PaginaAcesso> {
  @override
  void dispose() {
    super.dispose();
    widget.apresentacao.liberaMemoria();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(
      builder: (context) {
        widget.apresentacao.paginaEstaCarregandoStream.listen((estaCarregando) {
          if (estaCarregando) {
            exibeCarregando(context);
          } else {
            escondeCarregando(context);
          }
        });

        widget.apresentacao.falhaAcessoStream.listen((erro) {
          if (erro != null) {
            exibeMensagemErro(context, erro);
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
                        stream: widget.apresentacao.emailComErroStream,
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
                            onChanged: widget.apresentacao.validaEmail,
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 32),
                        child: StreamBuilder<String>(
                          stream: widget.apresentacao.senhaComErroStream,
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
                              onChanged: widget.apresentacao.validaSenha,
                            );
                          },
                        ),
                      ),
                      StreamBuilder(
                        stream: widget.apresentacao.camposSaoValidosStream,
                        builder: (context, snapshot) {
                          return RaisedButton(
                            onPressed: snapshot.data == true ? widget.apresentacao.autenticador : null,
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

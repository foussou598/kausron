import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/model/Firebasehelper.dart';

class LogController extends StatefulWidget {
  LogControllerState createState() => LogControllerState();
}

class LogControllerState extends State<LogController> {
  bool _log = true;
  String _adresseMail;
  String _password;
  String _prenom;
  String _nom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Authentification"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              height: MediaQuery.of(context).size.height / 2,
              child: Card(
                elevation: 7.0,
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: textfields(),
                  ),
                ),
              )),
          FlatButton(
              onPressed: () {
                setState(() {
                  _log = !_log;
                });
              },
              child: Text((_log) ? "Authentification" : "Creation de compte")),
          RaisedButton(
            onPressed: _handleLog,
            child: Text("C'est Parti"),
          )
        ],
      )),
    );
  }

  _handleLog() {
    if (_adresseMail != null) {
      if (_password != null) {
        if (_log) {
          //Connexion
          FirebaseHelper().handleSignIn(_adresseMail, _password).then((user) {
            print(user.uid);
          }).catchError((error) {
            alerte(error.toString());
          });
        } else {
          //Creation de compte
          if (_prenom != null) {
            if (_nom != null) {
              //Methode de creation d'utilisateur
              FirebaseHelper()
                  .create(_adresseMail, _password, _prenom, _nom)
                  .then((user) {
                print(user.uid);
              }).catchError((error) {
                alerte(error.toString());
              });
            } else {
              //Pas de nom
              alerte("Aucun nom n'a été renseigné");
            }
          } else {
            //Pas de prenom
            alerte("Aucun prenom n'a été renseigné");
          }
        }
      } else {
        //Entrez un mot de passe
        alerte("Aucun mot de passe renseigné");
      }
    } else {
      //Entrez un mail
      alerte("Aucune adresse mail n'a été renseignée");
    }
  }

  List<Widget> textfields() {
    List<Widget> widgets = [];
    widgets.add(
      TextField(
          decoration: InputDecoration(hintText: "Adresse Mail"),
          onChanged: (string) {
            setState(() {
              _adresseMail = string;
            });
          }),
    );

    widgets.add(
      TextField(
          decoration: InputDecoration(hintText: "Mot de passe "),
          obscureText: true,
          onChanged: (string) {
            setState(() {
              _password = string;
            });
          }),
    );

    if (!_log) {
      widgets.add(TextField(
          decoration: InputDecoration(hintText: "Prenom"),
          onChanged: (string) {
            setState(() {
              _prenom = string;
            });
          }));

      widgets.add(TextField(
          decoration: InputDecoration(hintText: "Nom"),
          onChanged: (string) {
            setState(() {
              _nom = string;
            });
          }));
    }
    return widgets;
  }

  Future<void> alerte(String message) async {
    Text title = Text("Erreur");
    Text msg = Text(message);
    FlatButton okButton = FlatButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text("OK"),
    );
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext cxt) {
          return (Theme.of(context).platform == TargetPlatform.iOS)
              ? CupertinoAlertDialog(
                  title: title,
                  content: msg,
                  actions: <Widget>[okButton],
                )
              : AlertDialog(
                  title: title, content: msg, actions: <Widget>[okButton]);
        });
  }
}

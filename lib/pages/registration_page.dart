import 'package:flutter/material.dart';
import 'package:hello_world_flutter/api/api_service.dart';
import 'package:hello_world_flutter/model/registration_model.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  RegistrationRequestModel requestModel;
  bool isApiCallProcess = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    requestModel = new RegistrationRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Theme.of(context).accentColor,
          title: Text(
            "Registration",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            margin: EdgeInsets.symmetric(vertical: 85, horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                      offset: Offset(0, 10),
                      blurRadius: 20)
                ]),
            child: Form(
              key: globalFormKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Text("Registration",
                      style: Theme.of(context).textTheme.headline2),
                  SizedBox(
                    height: 20,
                  ),
                  new TextFormField(
                    keyboardType: TextInputType.name,
                    onSaved: (input) => requestModel.email = input,
                    decoration: new InputDecoration(
                      hintText: "Email",
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.2))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).accentColor,
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  new TextFormField(
                    keyboardType: TextInputType.text,
                    onSaved: (input) => requestModel.username = input,
                    validator: (input) => input.length < 3
                        ? "Логин должен состоять из 3 символов и более"
                        : null,
                    decoration: new InputDecoration(
                      hintText: "Username",
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.2))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).accentColor,
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  new TextFormField(
                    keyboardType: TextInputType.text,
                    onSaved: (input) => requestModel.password = input,
                    validator: (input) => input.length < 6
                        ? "Пароль должен состоять из 6 символов и более"
                        : null,
                    obscureText: true,
                    decoration: new InputDecoration(
                      hintText: "Password",
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.2))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Theme.of(context).accentColor,
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FlatButton(
                    padding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 100),
                    onPressed: () {
                      if (validateAndSave()) {
                        setState(() {
                          isApiCallProcess = true;
                        });
                      }

                      APIService apiservice = new APIService();
                      apiservice.register(requestModel).then((value) {
                        setState(() {
                          isApiCallProcess = false;
                        });
                        if (value.success.isNotEmpty) {
                          print('USER DOBAVLEN');
                          Navigator.pushNamed(context, '/');
                        } else {
                          final snackBar = SnackBar(content: Text(value.error));
                          scaffoldKey.currentState.showSnackBar(snackBar);
                        }
                      });
                      print(requestModel.toJson());
                    },
                    child: Text(
                      "Registration",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Theme.of(context).accentColor,
                    shape: StadiumBorder(),
                  ),
                ],
              ),
            ),
          )
        ])));
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

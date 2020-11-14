import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_world_flutter/api/api_service.dart';
import 'package:hello_world_flutter/model/login_model.dart';
import 'package:hello_world_flutter/progressHUD.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  LoginRequestModel requestModel;
  bool isApiCallProcess = false;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _saveDeviceToken();
    requestModel = new LoginRequestModel();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      showDialog(context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message['notification']['title']),
          subtitle: Text(message['notification']['body']),
        ),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text("OK"))
        ],
      )
      );
    },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  @override
  Widget _uiSetup(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).accentColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                    Text("Login", style: Theme.of(context).textTheme.headline2),
                    SizedBox(
                      height: 20,
                    ),
                    new TextFormField(
                      keyboardType: TextInputType.name,
                      onSaved: (input) => requestModel.username = input,
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
                      validator: (input) => input.length < 3
                          ? "Пароль должен состоять из 4 символов и более"
                          : null,
                      obscureText: hidePassword,
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
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            color:
                                Theme.of(context).accentColor.withOpacity(0.4),
                            icon: Icon(hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                          )),
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

                          APIService apiService = new APIService();
                          apiService.login(requestModel).then((value) {
                            setState(() {
                              isApiCallProcess = false;
                            });

                            if (value.success.isNotEmpty) {
                              final snackBar = SnackBar(
                                  content: Text("Login Successfull"));
                              scaffoldKey.currentState.showSnackBar(snackBar);
                            } else {
                              final snackBar =
                                  SnackBar(content: Text(value.error));
                              scaffoldKey.currentState.showSnackBar(snackBar);
                            }
                          });
                          print(requestModel.toJson());
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).accentColor,
                      shape: StadiumBorder(),
                    ),
                    FlatButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 80),
                      onPressed: () {
                        Navigator.pushNamed(context, '/registration');
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
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _saveDeviceToken() async {
    String uid = 'Spiritcow';
    String fcmToken = await _fcm.getToken();
    print(fcmToken);
  }

}

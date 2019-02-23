import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final LocalAuthentication _localAuthentication = LocalAuthentication();
  bool _canCheckBiometric = false;
  String _authorizedOrNot = "Not Authorized";
  List<BiometricType> _availableBiometricTypes = List<BiometricType>();
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        appBar: new AppBar(),
        body: new Center(
          child: new SingleChildScrollView(
            child: Column(
              children: <Widget>[

                new Text("Can we check Biometric: $_canCheckBiometric"),
                new RaisedButton(
                  onPressed: _checkBiometric,
                  child: new Text('Check Biometric'),
                ),

                new SizedBox(height: 20,),

                new Text("List Of Biometric: ${_availableBiometricTypes.toString()}"),
                new RaisedButton(
                  onPressed: _getListOfBiometricTypes,
                  child: new Text('List Of Biometric Types'),
                ),

                new SizedBox(height: 20,),

                new Text("Authorized: $_authorizedOrNot"),
                new RaisedButton(
                  onPressed: _authorizedNow,
                  child: new Text('Authorized Now'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;
    try {
      canCheckBiometric = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch(e) {
      print("error $e");
    }

    if(!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  void _getListOfBiometricTypes() async {
    List<BiometricType> listBiometrics;

    try {
      listBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch(e) {
      print("error $e");
    }

    if(!mounted) return;

    setState(() {
      _availableBiometricTypes = listBiometrics;
    });
  }

  void _authorizedNow() async {
    bool isAuthorized = false;
    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticaticate to complete your transaction",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch(e) {
      print("error $e");
    }

    if(!mounted) return;

    setState(() {
      if(isAuthorized) {
        _authorizedOrNot = "Authorized";
      }else{
        _authorizedOrNot = "Not Authorized";
      }
    });
    
  }
}

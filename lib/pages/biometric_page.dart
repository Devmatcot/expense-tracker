import 'package:flutter/material.dart';
import 'package:flutter_3/constatnt.dart';
import 'package:local_auth/local_auth.dart';

class BioMetric extends StatefulWidget {
  BioMetric({Key? key}) : super(key: key);

  @override
  State<BioMetric> createState() => _BioMetricState();
}

class _BioMetricState extends State<BioMetric> {
  final LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> bios = [];
  bool? didAuthenticate;
  bool? canAuth;
  Future<void> authType() async {
    final bioList = await auth.getAvailableBiometrics();
    final bioType = await auth.canCheckBiometrics;

    bios = bioList;
    canAuth = bioType;
    setState(() {
      print(canAuth);
    });
  }

  authenticate() async {
    try {
      didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to show account balance',
          options: const AuthenticationOptions(useErrorDialogs: false, ));
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock,
              size: 120,
              color: PrimaryMaterialColor,
            ),
            Text(
              'Authentication is Required To Proceed.',
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30,
            ),
            // ElevatedButton(onPressed: (){}, child: Text('Authenticate'))
            GestureDetector(
              onTap: () {
                authType();
                authenticate();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      colors: [PrimaryMaterialColor, Colors.blue]),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.fingerprint,
                      color: Colors.white,
                      size: 40,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

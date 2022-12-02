import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upmarket/screens/home.dart';

import '../controller/registerC.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final otp = TextEditingController();
  bool _isLoading = false;
  final otpService = Get.put(RegisterC());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:Container(alignment: Alignment.center,
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Enter Otp",style: GoogleFonts.lexendDeca(fontSize: 30)),
                        const SizedBox(height: 20,),
                        TextFormField(

                          controller: otp,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Otp";
                            }
                          },
                          decoration:
                              const InputDecoration(border: OutlineInputBorder(),labelText: "Otp"),
                        ),const SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                          height: size.height*0.06,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          minWidth: size.width *0.5,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              AuthCredential phoneAuth =
                                  PhoneAuthProvider.credential(
                                      verificationId:
                                          otpService.verificationIDToken.value,
                                      smsCode: otp.text.trim());

                              await otpService.verify(phoneAuth).then((value) {
                                if (otpService.verificationIDToken.value != '' &&
                                    otpService.uid.value != '') {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Get.offAll(() => Home());
                                } else {
                                  print('Error');
                                }
                              });
                            }
                          },
                          color: Colors.green,
                          child:_isLoading ? const Text("Verifying..."):const Text('verify'),
                        )
                      ]),
                ),
              ),
            ),
    );
  }
}

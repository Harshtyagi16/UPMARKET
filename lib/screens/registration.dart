
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/registerC.dart';
import 'otpScreen.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool progressIndicator = false;
  final GlobalKey<FormState> _formKey = GlobalKey();


  final emailController = TextEditingController();
  final registerC = Get.put(RegisterC());

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(30),
            child: Column(
              children: [
                SizedBox(height: 100,),
                AnimatedTextKit(animatedTexts: [
                  TyperAnimatedText('Welcome',
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 40),
                      speed: const Duration(milliseconds: 200)),
                ]),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Phone Number',border: OutlineInputBorder()),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Phone Number";
                    }
                    return null;

                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  height: size.height*0.06,
                  minWidth: size.width*0.5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  color: Colors.green,
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        progressIndicator = true;
                      });
                      await registerC.RegisterM(emailController.text.trim()).then((value){
                        setState(() {
                          progressIndicator = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sending Otp")));
                        Get.to(()=>OtpScreen());

                      });

                      return;
                    }
                  },
                  child: progressIndicator
                      ? Text("Loading...")
                      : const Text('Send Otp'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

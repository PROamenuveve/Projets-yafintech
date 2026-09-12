import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yafintech/core/outils/outils.dart';
import 'package:yafintech/core/theme/app_color.dart';
import 'package:yafintech/services/auth_service.dart';
import 'package:yafintech/core/theme/app_font.dart';

// ignore: must_be_immutable
class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  bool _passevisible = false;
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loginError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: 30),
          child: Text(
            'YAFINTECH',
            style: AppFonts.font1Gras.copyWith(
              color: AppColors.couleur1,
              fontSize: 50,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            //color: Colors.red,
            margin: EdgeInsets.symmetric(vertical: 60),
            child: Column(
              children: [
                AppOutils.espace20,
                Text(
                  'Veiller entre vos identifient de connexion',
                  style: AppFonts.font1.copyWith(
                    color: AppColors.couleur1,
                    fontSize: 20,
                  ),
                ),
                AppOutils.espace10,
                AppOutils.espace20,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Visibility(
                          visible: loginError,
                          child: Text(
                            'Email ou mot de passe invalide',
                            style: GoogleFonts.daiBannaSil(
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                        ),

                        AppOutils.espace05,
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Veuillez entrer votre email';
                            }

                            if (!value.contains('@')) {
                              return 'Email invalide';
                            }

                            return null;
                          },
                          decoration: AppOutils.inputDecoration(
                            hintText: 'example@gmail.com',
                          ),
                        ),
                        AppOutils.espace10,
                        AppOutils.espace20,
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            return null;
                          },
                          decoration: AppOutils.inputDecoration(
                            hintText: 'mot de passe',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passevisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passevisible = !_passevisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_passevisible,
                        ),
                        SizedBox(height: 5),
                        Container(
                          //color: Colors.amberAccent,
                          alignment: Alignment.topLeft,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                // faire quelque chose
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.couleur1,
                              overlayColor: Colors.transparent,
                            ),
                            child: Text(
                              'mots de passe oublié',
                              style: TextStyle(
                                decorationColor: const Color.fromARGB(
                                  255,
                                  6,
                                  6,
                                  6,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AppOutils.espace20,
                        AppOutils.espace20,
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool d = await login(
                                  emailController.text,
                                  passwordController.text,
                                );
                                setState(() {
                                  if (d) {
                                    print('🟢🟢🟢🟢🟢🟢 connexion reussie');
                                    context.push('/');
                                    loginError = false;
                                  } else {
                                    print('🔴🔴🔴🔴🔴🔴 connexion echoué');
                                    loginError = true;
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: AppColors.couleur1,
                            ),
                            child: Text(
                              'Connexion',
                              style: GoogleFonts.daiBannaSil(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppOutils.espace20,
                AppOutils.espace20,
                TextButton(
                  onPressed: () {
                    context.push('/inscriptionNom');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.couleur1,
                    overlayColor: Colors.transparent,
                  ),
                  child: Text('Inscription', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

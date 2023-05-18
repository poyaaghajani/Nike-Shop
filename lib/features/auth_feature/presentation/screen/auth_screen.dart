import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/config/light_color.dart';
import 'package:nike/core/utils/devise_size.dart';
import 'package:nike/core/widgets/custom_buton.dart';
import 'package:nike/core/widgets/custom_snackbar.dart';
import 'package:nike/features/auth_feature/data/repository/auth_repository.dart';
import 'package:nike/features/auth_feature/presentation/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isVisable = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: LightThemeColors.deepNavy,
        body: BlocProvider(
          create: (context) {
            final authBloc = AuthBloc(authRepository: authRepository);
            authBloc.stream.forEach((state) {
              if (state is AuthSuccessState) {
                Navigator.pop(context);
              }
              if (state is AuthErrorState) {
                CustomSnackbar.showSnack(
                  context,
                  state.exeption.message,
                  Colors.white,
                  LightThemeColors.navy,
                );
              }
            });
            authBloc.add(AuthInit());
            return authBloc;
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) {
              return current is AuthLoadingState ||
                  current is AuthInitState ||
                  current is AuthErrorState;
            },
            builder: (context, state) {
              return SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/nike_logo.png',
                          height: 50,
                          color: Colors.white,
                        ),
                        SizedBox(height: DeviseSize.getHeight(context) / 50),
                        Text(
                          state.isLogedinMode ? 'خوش آمدید' : 'ثبت نام',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 22),
                        ),
                        Text(
                          'لطفا وارد حساب کاربری خود شوید',
                          style: TextStyle(
                              color: Colors.grey.shade300, fontSize: 16),
                        ),
                        SizedBox(height: DeviseSize.getHeight(context) / 8),
                        TextField(
                          controller: emailController,
                          style: TextStyle(color: Colors.grey.shade300),
                          decoration: InputDecoration(
                            labelText: 'آدرس ایمیل',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: LightThemeColors.navy, width: 3),
                            ),
                          ),
                        ),
                        SizedBox(height: DeviseSize.getHeight(context) / 50),
                        TextField(
                          controller: passwordController,
                          style: TextStyle(color: Colors.grey.shade300),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isVisable,
                          decoration: InputDecoration(
                            labelText: 'رمز عبور',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisable = !isVisable;
                                });
                              },
                              icon: Icon(
                                isVisable
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade500, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: LightThemeColors.navy, width: 3),
                            ),
                          ),
                        ),
                        SizedBox(height: DeviseSize.getHeight(context) / 50),

                        // login button
                        loginButton(context, state),

                        SizedBox(height: DeviseSize.getHeight(context) / 50),

                        // change mode
                        changeMode(context, state),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  GestureDetector changeMode(BuildContext context, AuthState state) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<AuthBloc>(context).add(AuthModeChangePressed());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.isLogedinMode ? 'حساب کاربری ندارید؟' : 'حساب کاربری دارید؟',
            style: TextStyle(color: Colors.grey[300]),
          ),
          const SizedBox(width: 8),
          Text(
            state.isLogedinMode ? 'ثبت نام' : 'ورود',
            style: const TextStyle(color: LightThemeColors.primaryColor),
          ),
        ],
      ),
    );
  }

  CustomButton loginButton(BuildContext context, AuthState state) {
    return CustomButton(
      width: DeviseSize.getWidth(context),
      height: DeviseSize.getHeight(context) / 13,
      radius: 12,
      onPressed: () async {
        BlocProvider.of<AuthBloc>(context).add(AuthButtonPressed(
          email: emailController.text,
          password: passwordController.text,
        ));
      },
      text: state is AuthLoadingState
          ? 'درحال بررسی...'
          : state.isLogedinMode
              ? 'ورود'
              : 'ثبت نام',
      textStyle: const TextStyle(
        color: LightThemeColors.deepNavy,
        fontSize: 16,
      ),
      color: Colors.white,
    );
  }
}

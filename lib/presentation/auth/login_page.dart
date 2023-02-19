import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/presentation/common/responsive_size.dart';
import 'package:who_writes/presentation/common/widgets/ww_button.dart';
import 'package:who_writes/presentation/common/widgets/ww_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(context.responsiveWidth(27)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.responsiveHeight(80),
                  ),
                  child: const Text(
                    'Who writes?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Login with email and password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: context.responsiveHeight(32),
                ),
                WWTextField(
                  controller: _emailController,
                  // focusNode: _emailFocusNode,
                  fieldName: 'Email',
                  fieldNameStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: 'Email',
                  hintStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  // inputTextStyle: null,
                  keyboardType: TextInputType.emailAddress,
                  // errorText: _validateEmail(status),
                  // errorTextStyle:
                  //     AppTextStyles.of(ref).loginErrorText,
                  // fieldNameErrorStyle:
                  //     AppTextStyles.of(ref).loginErrorTitle,
                  textInputAction: TextInputAction.next,
                  // onChanged: _onEmailChanged,
                  // onEditingComplete: () => FocusScope.of(context)
                  //     .requestFocus(_passwordFocusNode),
                ),
                const SizedBox(
                  height: 20,
                ),
                WWTextField(
                  controller: _passwordController,
                  // focusNode: _passwordFocusNode,
                  fieldName: 'Password',
                  fieldNameStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  //     AppTextStyles.of(ref).loginTextFieldTitle,
                  hintText: 'Password',
                  hintStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  //     AppTextStyles.of(ref).loginTextFieldHint,
                  // inputTextStyle:
                  //     AppTextStyles.of(ref).loginTextInput,
                  keyboardType: TextInputType.visiblePassword,
                  isPassword: true,
                  // errorText: _validatePassword(status),
                  // errorTextStyle:
                  //     AppTextStyles.of(ref).loginErrorText,
                  // fieldNameErrorStyle:
                  //     AppTextStyles.of(ref).loginErrorTitle,
                  textInputAction: TextInputAction.done,
                  // onChanged: _onPasswordChanged,
                  // onEditingComplete: () =>
                  //     FocusScope.of(context).unfocus(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    bottom: 6,
                  ),
                  child: WWButton(
                    text: 'Login',
                    height: context.responsiveHeight(47),
                    width: context.responsiveWidth(215),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    //     AppTextStyles.of(ref).loginButtonText,
                    // onPressed: buttonStatus is ButtonActive
                    //     ? _onLoginButtonPressed
                    //     : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

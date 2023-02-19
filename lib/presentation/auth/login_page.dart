import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/presentation/common/colors/ref_colors.dart';
import 'package:who_writes/presentation/common/responsive_size.dart';
import 'package:who_writes/presentation/common/text_styles/ref_text_styles.dart';
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
      backgroundColor: ref.backGroundColor,
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
                  child: Text(
                    'Who writes?',
                    style: ref.loginPageAppNameTS,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Login',
                        style: ref.loginPageTitleTS,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Login with email and password',
                        style: ref.loginPageSubTitleTS,
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
                  fieldNameStyle: ref.loginPageTextFieldNameTS,
                  hintText: 'Email',
                  hintStyle: ref.loginPageTextFieldHintTS,
                  inputTextStyle: ref.loginPageTextFieldInputTextTS,
                  keyboardType: TextInputType.emailAddress,
                  // errorText: _validateEmail(status),
                  errorTextStyle: ref.loginPageTextFieldErrorTS,
                  fieldNameErrorStyle: ref.loginPageTextFieldFieldNameErrorTS,
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
                  fieldNameStyle: ref.loginPageTextFieldNameTS,
                  hintText: 'Password',
                  hintStyle: ref.loginPageTextFieldHintTS,
                  inputTextStyle: ref.loginPageTextFieldInputTextTS,
                  keyboardType: TextInputType.visiblePassword,
                  isPassword: true,
                  // errorText: _validatePassword(status),
                  errorTextStyle: ref.loginPageTextFieldErrorTS,
                  fieldNameErrorStyle: ref.loginPageTextFieldFieldNameErrorTS,
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
                    textStyle: ref.loginPageTextButtonTextTS,
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
                        child: Text(
                          'Register',
                          style: ref.loginPageTextButtonRegisterTextTS,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot password',
                          style: ref.loginPageTextButtonForgotTextTS,
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

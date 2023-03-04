import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/presentation/common/colors/ref_colors.dart';
import 'package:who_writes/presentation/common/overlay_state_mixin.dart';
import 'package:who_writes/presentation/common/responsive_size.dart';
import 'package:who_writes/presentation/common/text_styles/ref_text_styles.dart';
import 'package:who_writes/presentation/common/widgets/ww_button.dart';
import 'package:who_writes/presentation/common/widgets/ww_text_field.dart';

class RecoverPage extends ConsumerStatefulWidget {
  const RecoverPage({super.key});

  @override
  ConsumerState<RecoverPage> createState() => _RecoverPageState();
}

class _RecoverPageState extends ConsumerState<RecoverPage>
    with OverlayStateMixin {
  final _emailController = TextEditingController();

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
                    vertical: context.responsiveHeight(70),
                  ),
                  child: Text(
                    'Recover',
                    style: ref.loginPageAppNameTS,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recover',
                        style: ref.recoverPageTitleTS,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Recover with email',
                        style: ref.recoverPageSubTitleTS,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: context.responsiveHeight(32),
                ),
                WWTextField(
                  controller: _emailController,
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
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 80,
                    bottom: 6,
                  ),
                  child: Visibility(
                    visible: false,
                    // visible: buttonStatus == ButtonStatus.loading,
                    replacement: WWButton(
                      text: 'Recover',
                      height: context.responsiveHeight(47),
                      width: context.responsiveWidth(215),
                      textStyle: ref.loginPageTextButtonTextTS,
                      // onPressed: buttonStatus == ButtonStatus.active
                      //     ? _onLoginPressed
                      //     : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: CircularProgressIndicator(
                        color: ref.circularIndicatorColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

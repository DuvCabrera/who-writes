import 'package:domain/exceptions.dart';
import 'package:domain/use_case/firebase_recover_uc.dart';
import 'package:domain/use_case/validate_email_uc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:who_writes/presentation/auth/recover/recover_fail_state.dart';
import 'package:who_writes/presentation/common/status/button_status.dart';
import 'package:who_writes/presentation/common/status/input_status.dart';
import 'package:who_writes/presentation/common/subscription_holder.dart';

class RecoverBloc with SubscriptionHolder {
  RecoverBloc({
    required FirebaseRecoverUC firebaseRecoverUC,
    required ValidateEmailUC validateEmailUC,
  })  : _firebaseRecoverUC = firebaseRecoverUC,
        _validateEmailUC = validateEmailUC {
    _onEmailChangedSubject
        .debounceTime(const Duration(microseconds: 500))
        .listen((_) => _validateEmail(_emailInputStatusSubject.sink))
        .addTo(subscriptions);

    Rx.combineLatest2<bool, bool, ButtonStatus>(
        _emailInputStatusSubject.map((status) => status == InputStatus.valid),
        Stream.value(true), (isValidEmail, isTrue) {
      if (_buttonStatusValue == ButtonStatus.loading) {
        return ButtonStatus.loading;
      }
      if (!isValidEmail) {
        return ButtonStatus.inactive;
      }
      return ButtonStatus.active;
    }).listen(_buttonStatusSubject.add).addTo(subscriptions);

    _onRecoverPressedSubject
        .flatMap((_) => _tryRecover())
        .listen(_buttonStatusSubject.add)
        .addTo(subscriptions);
  }

  final FirebaseRecoverUC _firebaseRecoverUC;
  final ValidateEmailUC _validateEmailUC;

  final _onRecoverSuccessSubject = BehaviorSubject<void>();
  Stream<void> get onRecoverSuccessStream => _onRecoverSuccessSubject.stream;

  final _onRecoverFailSubject = BehaviorSubject<RecoverFailState>();
  Stream<RecoverFailState> get onRecoverFailStream =>
      _onRecoverFailSubject.stream;

  final _onEmailChangedSubject = BehaviorSubject<String>();
  Stream<String> get onEmailChangedStream => _onEmailChangedSubject.stream;
  Sink<String> get onEmailChangedSink => _onEmailChangedSubject.sink;
  String? get _emailValue => _onEmailChangedSubject.valueOrNull;

  final _emailInputStatusSubject = BehaviorSubject<InputStatus>();
  Stream<InputStatus> get emailInputStatusStream =>
      _emailInputStatusSubject.stream;

  final _onRecoverPressedSubject = BehaviorSubject<void>();
  Sink<void> get onRecoverPressedSink => _onRecoverPressedSubject.sink;

  final _buttonStatusSubject = BehaviorSubject<ButtonStatus>();
  Stream<ButtonStatus> get buttonStatusStream => _buttonStatusSubject.stream;
  ButtonStatus get _buttonStatusValue =>
      _buttonStatusSubject.valueOrNull ?? ButtonStatus.inactive;

  Future<void> _validateEmail(Sink<InputStatus> sink) async {
    try {
      await _validateEmailUC.getFuture(
        ValidateEmailUCParams(_emailValue ?? ''),
      );
      sink.add(InputStatus.valid);
    } catch (e) {
      if (e is InvalidFormFieldException) {
        sink.add(InputStatus.wrong);
      } else {
        sink.add(InputStatus.empty);
      }
    }
  }

  Stream<ButtonStatus> _tryRecover() async* {
    yield ButtonStatus.loading;
    try {
      await _firebaseRecoverUC
          .getFuture(FirebaseRecoverUCParams(_emailValue ?? ''));
      _onRecoverSuccessSubject.add(null);
      yield ButtonStatus.inactive;
    } catch (e) {
      if (e is WhoWritesException) {
        if (e is FirebaseAuthInvalidEmailException) {
          _onRecoverFailSubject.add(RecoverFailState.invalidEmail);
        } else if (e is FirebaseAuthUserNotFoundException) {
          _onRecoverFailSubject.add(RecoverFailState.userNotFound);
        }
      } else {
        _onRecoverFailSubject.add(RecoverFailState.unexpectedError);
      }
      yield ButtonStatus.inactive;
    }
  }

  void dispose() {
    _buttonStatusSubject.close();
    _onRecoverPressedSubject.close();
    _onRecoverFailSubject.close();
    _onRecoverSuccessSubject.close();
    _onEmailChangedSubject.close();
    disposeAll();
  }
}

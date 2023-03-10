import 'package:domain/use_case/open_ai_get_completion_uc.dart';
import 'package:domain/use_case/open_ai_verify_api_key_uc.dart';
import 'package:domain/use_case/use_case.dart';
import 'package:rxdart/rxdart.dart';
import 'package:who_writes/presentation/common/status/button_status.dart';
import 'package:who_writes/presentation/common/status/input_status.dart';
import 'package:who_writes/presentation/common/subscription_holder.dart';
import 'package:who_writes/presentation/completion/home/home_state.dart';

class HomeBloc with SubscriptionHolder {
  HomeBloc({
    required OpenAiGetCompletionUC getCompletionUC,
    required OpenAiVerifyApiKeyUC verifyApiKeyUC,
  })  : _getCompletionUC = getCompletionUC,
        _verifyApiKeyUC = verifyApiKeyUC {
    Rx.merge<dynamic>([Stream.value(null), _onTryAgainSubject])
        .flatMap((_) => _initPage())
        .listen(_homePageStateSubject.add)
        .addTo(subscriptions);

    _onTextChangedSubject
        .debounceTime(const Duration(milliseconds: 300))
        .listen((_) {
      _isTextEmpty(_textInputStatusSubject.sink);
    }).addTo(subscriptions);

    _textInputStatusSubject
        .map((event) {
          if (event == InputStatus.valid) {
            return ButtonStatus.active;
          } else {
            return ButtonStatus.inactive;
          }
        })
        .listen(_buttonStatusSubject.add)
        .addTo(subscriptions);

    _onSendPressedSubject
        .listen((_) => _getCompletion(_buttonStatusSubject.sink))
        .addTo(subscriptions);
  }

  final OpenAiGetCompletionUC _getCompletionUC;
  final OpenAiVerifyApiKeyUC _verifyApiKeyUC;

  final _onTryAgainSubject = BehaviorSubject<void>();
  Stream<void> get onTryAgainStream => _onTryAgainSubject.stream;
  Sink<void> get onTryAgainSink => _onTryAgainSubject.sink;

  final _homePageStateSubject = BehaviorSubject<HomePageState>();
  Stream<HomePageState> get homePageStateStream => _homePageStateSubject.stream;

  final _onTextChangedSubject = BehaviorSubject<String>();
  Sink<String> get onTextChangedSink => _onTextChangedSubject.sink;
  String? get textValue => _onTextChangedSubject.valueOrNull;

  final _textInputStatusSubject = BehaviorSubject<InputStatus>();

  final _buttonStatusSubject = BehaviorSubject<ButtonStatus>();
  Stream<ButtonStatus> get buttonStatusStream => _buttonStatusSubject.stream;

  final _isApiKeyOKSubject = BehaviorSubject<bool>();
  Stream<bool> get isApiKeyOKStream => _isApiKeyOKSubject.stream;

  final _onCompletionSuccessSubject = BehaviorSubject<void>();
  Stream<void> get onCompletionSuccessStream =>
      _onCompletionSuccessSubject.stream;

  final _onSendPressedSubject = BehaviorSubject<void>();
  Sink<void> get onSendPressedSink => _onSendPressedSubject.sink;

  Stream<HomePageState> _initPage() async* {
    yield Loading();
    try {
      final isApiKeyOk = await _verifyApiKeyUC.getFuture(NoParams());
      _isApiKeyOKSubject.add(isApiKeyOk);
      yield Success();
    } catch (e) {
      yield Error();
    }
  }

  void _isTextEmpty(Sink<InputStatus> sink) {
    if (textValue != null) {
      sink.add(InputStatus.valid);
    } else {
      sink.add(InputStatus.empty);
    }
  }

  Future<void> _getCompletion(Sink<ButtonStatus> sink) async {
    sink.add(ButtonStatus.loading);
    try {
      final completion = await _getCompletionUC.getFuture(
        OpenAiGetCompletionUCParams(textValue!),
      );
      sink.add(ButtonStatus.inactive);
      _onCompletionSuccessSubject.add(null);
    } catch (e) {
      sink.add(ButtonStatus.inactive);
    }
  }

  void dispose() {
    _onSendPressedSubject.close();
    _buttonStatusSubject.close();
    _textInputStatusSubject.close();
    _onTextChangedSubject.close();
    _isApiKeyOKSubject.close();
    _onTryAgainSubject.close();
    _homePageStateSubject.close();
    _onCompletionSuccessSubject.close();
    disposeAll();
  }
}

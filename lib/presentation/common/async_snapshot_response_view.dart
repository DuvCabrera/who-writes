import 'package:flutter/material.dart';

class AsyncSnapshotResponseView<Loading, Error, Success>
    extends StatelessWidget {
  AsyncSnapshotResponseView({
    required this.snapshot,
    required this.successWidgetBuilder,
    required this.onTryAgainTap,
    this.loadingWidgetBuilder,
    this.errorWidgetBuilder,
    super.key,
  })  : assert(Loading != dynamic),
        assert(Error != dynamic),
        assert(Success != dynamic);

  final AsyncSnapshot<dynamic> snapshot;
  final Widget Function(BuildContext context, Success success)
      successWidgetBuilder;
  final Widget Function(BuildContext context, Loading? loading)?
      loadingWidgetBuilder;
  final Widget Function(
    BuildContext context,
    Error? error,
    VoidCallback onTryAgain,
  )? errorWidgetBuilder;
  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) {
    final data = snapshot.data;
    if (data == null || data is Loading) {
      if (loadingWidgetBuilder != null) {
        return loadingWidgetBuilder!(context, data as Loading?);
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (data is Error) {
      if (errorWidgetBuilder != null) {
        return errorWidgetBuilder!(context, data, onTryAgainTap);
      }
      return const Center(
        child: Text('Error'),
      );
    }

    if (data is Success) {
      return successWidgetBuilder(context, data);
    }
    throw UnknownStateTypeException();
  }
}

class UnknownStateTypeException implements Exception {}

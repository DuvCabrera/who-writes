import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:who_writes/presentation/common/subscription_holder.dart';

class ActionHandler<T> extends StatefulWidget {
  const ActionHandler({
    required this.child,
    required this.stream,
    required this.onReceive,
    super.key,
  });

  final Widget child;
  final Stream<T> stream;
  final void Function(T action) onReceive;
  @override
  State<ActionHandler<T>> createState() => _ActionHandlerState<T>();
}

class _ActionHandlerState<T> extends State<ActionHandler<T>>
    with SubscriptionHolder {
  @override
  void initState() {
    widget.stream.listen(widget.onReceive).addTo(subscriptions);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

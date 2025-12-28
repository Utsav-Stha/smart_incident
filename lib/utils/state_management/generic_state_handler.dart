import 'package:flutter/material.dart';
import 'package:smart_incident/utils/state_management/generic_state.dart';

class GenericStateHandler<T> extends StatelessWidget {
  final GenericState<T> state;
  final Widget Function() onError;
  final Widget Function(T) onLoaded;
  final Widget Function(T) onEmpty;
  final Widget Function()? onLoading;

  const GenericStateHandler({
    super.key,
    required this.state,
    required this.onLoaded,
    required this.onEmpty,
    required this.onError,
    required this.onLoading,
  });

  @override
  Widget build(BuildContext context) {
    final state = this.state;
    if (state case LoadingState()) {
      return onLoading?.call() ?? const CircularProgressIndicator();
    }

    if (state case SuccessState()) {
      if (state.data is List && (state.data as List).isEmpty) {
        return onEmpty(state.data);
      }
      return onLoaded(state.data);
    }
    if (state case ErrorState()) {
      return Center(child: Text(state.error.toString()));
    }

    return const SizedBox.shrink();
  }
}

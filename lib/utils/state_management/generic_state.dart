import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';

sealed class GenericState<T> {}

class InitialState<T> extends GenericState<T> {}

class LoadingState<T> extends GenericState<T> {}

class SuccessState<T> extends GenericState<T> {
  final T data;

  SuccessState({required this.data});
}

class ErrorState<T> extends GenericState<T> {
  final String error;
  final Object stackTrace;

  ErrorState({required this.error, required this.stackTrace}) {
    Logger().e("State Error: $error");
    Logger().e("\nState Stack Trace: $stackTrace");
  }
}

extension ListenState<T> on GenericState<T> {
  void handleState({
    required BuildContext context,
    required Function(T) onSuccess,
    Function(Object, Object)? onError,
    VoidCallback? onLoading,
    VoidCallback? onCancelApi,
  }) {
    switch (this) {
      case LoadingState():
        onLoading == null
            ? showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        onCancelApi?.call();
                      },
                      child: const Icon(Icons.close_rounded, size: 80),
                    ),
                    const Center(
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              )
            : onLoading.call();

      case SuccessState<T>(:final data):
        Navigator.of(context).pop();
        onSuccess(data);

      case ErrorState<T>(:final error, :final stackTrace):
        Navigator.of(context).pop();
        onError == null
            ? ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(error)))
            : onError.call(error, stackTrace);
      case InitialState():
    }
  }

  isLoading() {
    if (this case LoadingState()) {
      return true;
    } else {
      return false;
    }
  }

  isError() {
    if (this case ErrorState()) {
      return true;
    } else {
      return false;
    }
  }
}

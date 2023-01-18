import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mx_exchange/common/base/bloc/loading/loading_cubit.dart';
import 'package:mx_exchange/common/base/bloc/loading/loading_state.dart';

class LoadingApp extends StatelessWidget {
  final Widget? child;

  const LoadingApp({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child!,
        BlocBuilder<LoadingCubit, LoadingState>(
          bloc: context.read<LoadingCubit>(),
          builder: (context, state) {
            return Visibility(
              visible: state.loading!,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

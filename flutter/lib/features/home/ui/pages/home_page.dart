import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zure_ai/features/home/cubit/socket_cubit.dart';
import 'package:zure_ai/features/home/repository/socket_repository.dart';

import 'package:zure_ai/features/home/ui/widgets/home_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              SocketCubit(socketRepository: context.read<SocketRepository>())
                ..initSocket(),
      child: const HomeWidget(),
    );
  }
}

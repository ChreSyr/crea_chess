import 'dart:async';

import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_crud.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_cubit.dart';
import 'package:crea_chess/package/firebase/authentication/authentication_model.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ResendDelayCubit extends Cubit<int> {
  ResendDelayCubit() : super(15) {
    reset();
  }

  void _decrease() => emit(state - 1);

  void reset() {
    emit(15);
  }
}

class EmailVerificationBody extends RouteBody {
  const EmailVerificationBody({super.key});

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.signin; // TODO
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationModel>(
      listener: (context, auth) {
        if (auth.emailVerified ?? false) context.pop();
      },
      child: const _EmailVerificationBody(),
    );
  }
}

class _EmailVerificationBody extends StatelessWidget {
  const _EmailVerificationBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        // mail icon
        const Text(
          '📬',
          style: TextStyle(fontSize: CCWidgetSize.xxsmall),
          textAlign: TextAlign.center,
        ),

        CCGap.large,

        // sign up button
        Text(
          'Verify your email',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),

        CCGap.xxlarge,

        // or continue with
        const Text(
          'Please verify your email by clicking the link we just sent, then return to the app and click "Continue."',
          textAlign: TextAlign.center,
        ),

        CCGap.xxlarge,

        // google + apple sign in buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ResendButton(),
            CCGap.large,
            FilledButton(
              onPressed: authenticationCRUD.checkEmailVerified,
              child: const Text('Continue'),
            ),
          ],
        ),
      ],
    );
  }
}

class ResendButton extends StatefulWidget {
  const ResendButton({super.key});

  @override
  State<ResendButton> createState() => _ResendButtonState();
}

class _ResendButtonState extends State<ResendButton> {
  int delay = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    delay = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _decrease();
      if (delay == 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _decrease() {
    setState(() {
      delay--;
    });
  }

  void _reset() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _decrease();
      if (delay == 0) {
        timer.cancel();
      }
    });
    setState(() {
      delay = 15;
    });
  }

  @override
  Widget build(BuildContext context) {
    return delay == 0
        ? ElevatedButton(
            onPressed: () {
              authenticationCRUD.sendEmailVerification();
              _reset();
            },
            child: const Text('Resend email link'),
          )
        : ElevatedButton(
            onPressed: null,
            child: Text('Resend email link ($delay)'),
          );
  }
}

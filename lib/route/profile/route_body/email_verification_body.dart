import 'dart:async';

import 'package:crea_chess/package/atomic_design/size.dart';
import 'package:crea_chess/package/atomic_design/widget/gap.dart';
import 'package:crea_chess/package/firebase/authentication/user_crud.dart';
import 'package:crea_chess/package/l10n/l10n.dart';
import 'package:crea_chess/route/route_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EmailVerificationBody extends RouteBody {
  const EmailVerificationBody({super.key});

  @override
  String getTitle(AppLocalizations l10n) {
    return l10n.signin; // TODO: change
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, User?>(
      listener: (context, user) {
        if (user == null) return;
        if (user.emailVerified) context.push('/profile/modify_name');
      },
      child: const _EmailVerificationBody(),
    );
  }
}

class _EmailVerificationBody extends StatelessWidget {
  const _EmailVerificationBody();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: CCWidgetSize.large3,
      child: ListView(
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
            context.l10n.verifyMailbox,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),

          CCGap.xxlarge,

          // or continue with
          Text(
            context.l10n.verifyEmailExplainLink(
              context.read<UserCubit>().state?.email ?? 'ERROR',
            ),
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
                onPressed: userCRUD.reloadUser,
                child: Text(context.l10n.continue_),
              ),
            ],
          ),
        ],
      ),
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
    userCRUD.sendEmailVerification();
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
              userCRUD.sendEmailVerification();
              _reset();
            },
            child: Text(context.l10n.verifyEmailResendLink),
          )
        : ElevatedButton(
            onPressed: null,
            child: Text('${context.l10n.verifyEmailResendLink} ($delay)'),
          );
  }
}
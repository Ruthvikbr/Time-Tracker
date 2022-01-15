import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/bloc/email_sign_in_bloc.dart';
import 'package:time_tracker/app/components/formSubmitButton.dart';
import 'package:time_tracker/app/components/showExceptionAlertDialog.dart';
import 'package:time_tracker/services/auth.dart';

import '../email_sign_in_model.dart';

class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({Key? key, required this.bloc}) : super(key: key);

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInForm(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Something went wrong",
        exception: e,
      );
    }
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel? model) {
    return [
      _buildEmailTextField(model),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(model),
      SizedBox(
        height: 16.0,
      ),
      FormSubmitButton(
        onPressed: model!.canSubmit ? _onSubmit : null,
        text: model.primaryText,
      ),
      SizedBox(
        height: 8.0,
      ),
      TextButton(
          child: Text(
            model.secondaryText,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16.0,
            ),
          ),
          onPressed: _toggleFormType)
    ];
  }

  TextField _buildPasswordTextField(EmailSignInModel? model) {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: "Password",
        errorText: model!.passwordErrorText,
        enabled: !model.loading,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onChanged: widget.bloc.updatePassword,
      onEditingComplete: _onSubmit,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel? model) {
    bool showErrorText = model != null &&
        model.submitted &&
        !model.emailValidator.isValid(model.email);
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter a valid email id",
        errorText: model!.emailErrorText,
        enabled: !model.loading,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onChanged: widget.bloc.updateEmail,
      onEditingComplete: () => _emailEditingCompleted(model),
    );
  }

  void _emailEditingCompleted(EmailSignInModel? model) {
    final nextFocus = model != null && model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel? model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(model),
            ),
          );
        });
  }
}

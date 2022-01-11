import 'package:bai29_flutter_app_bookstore/base/base_widget.dart';
import 'package:bai29_flutter_app_bookstore/data/remote/user_service.dart';
import 'package:bai29_flutter_app_bookstore/data/repo/user_repo.dart';
import 'package:bai29_flutter_app_bookstore/event/signin_event.dart';
import 'package:bai29_flutter_app_bookstore/module/signin/sign_bloc.dart';
import 'package:bai29_flutter_app_bookstore/shared/widget/app_color.dart';
import 'package:bai29_flutter_app_bookstore/shared/widget/normal_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: "Sign In",
      bloc: [],
      di: [
        Provider<UserService>(
          create: (context) => UserService(),
        ),
        ProxyProvider<UserService, UserRepo>(
          update: (context, userService, previous) => UserRepo(
            userService: userService,
          ),
        ),
      ],
      child: SignInFormWidget(),
    );
  }
}

class SignInFormWidget extends StatelessWidget {
  final _txtPhoneController = TextEditingController();
  final _txtPassController = TextEditingController();

  SignInFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<SignInBloc>(
      create: (context) => SignInBloc(
        userRepo: Provider.of<UserRepo>(context, listen: false),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Consumer<SignInBloc>(
          builder: (context, bloc, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPhoneField(bloc),
              _buildPassField(bloc),
              _buildSignInButton(bloc),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(top: 30.0),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Đăng ký tài khoản",
          style: TextStyle(
            fontSize: 17,
            color: AppColor.blue,
          ),
        ),
      ),
      borderRadius: BorderRadius.circular(10.0),
      onTap: () {},
    );
  }

  Widget _buildPhoneField(SignInBloc bloc) {
    return StreamProvider(
      initialData: "",
      create: (context) => bloc.phoneStream,
      child: Consumer<String>(
        builder: (context, message, child) => Container(
          margin: const EdgeInsets.only(bottom: 15.0),
          child: TextField(
            onChanged: (text) {
              bloc.phoneSink.add(text);
            },
            controller: _txtPhoneController,
            cursorColor: Colors.black,
            // keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              errorText: message.isEmpty ? null : message,
              icon: Icon(
                Icons.phone,
                color: AppColor.blue,
              ),
              hintText: "(+84) 394773456",
              labelText: "Phone",
              labelStyle: TextStyle(
                color: AppColor.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPassField(SignInBloc bloc) {
    return StreamProvider(
      initialData: "",
      create: (context) => bloc.passStream,
      child: Consumer<String>(
        builder: (context, message, child) => Container(
          margin: const EdgeInsets.only(bottom: 25.0),
          child: TextField(
            onChanged: (text) {
              bloc.passSink.add(text);
            },
            controller: _txtPassController,
            obscureText: true,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              errorText: message.isEmpty ? null : message,
              icon: Icon(
                Icons.lock,
                color: AppColor.blue,
              ),
              hintText: "Password",
              labelText: "Password",
              labelStyle: TextStyle(
                color: AppColor.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(SignInBloc bloc) {
    return StreamProvider<bool>(
      initialData: false,
      create: (context) => bloc.btnStream,
      child: Consumer<bool>(
        builder: (context, enable, child) => NormalButton(
          onPressed: enable
              ? () {
                  bloc.event.add(SignInEvent(
                    phone: _txtPhoneController.text,
                    pass: _txtPassController.text,
                  ));
                }
              : null,
        ),
      ),
    );
  }
}

//create with CommonWidget of riverpod

import 'package:exam/common_widgets/common_pressable.dart';
import 'package:exam/common_widgets/common_scaffold.dart';
import 'package:exam/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../common_widgets/common_textfield.dart';
import '../../config/router/app_paths.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(
        children: [
          SizedBox(height: 40.h),
          Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10.h,
            children: [
              Text('Chào mừng bạn đến với', style: Theme.of(context).textTheme.headlineMedium),
              Assets.images.exam.image(width: 100.w, height: 60.h),
              Text('Đăng nhập tài khoản của bạn'),
              CommonTextField(
                label: 'Tài khoản',
                hint: Text('example123@gmail.com'),
                colorFilled: Colors.grey.shade300,
                filled: true,
                prefixIcon: Icon(Icons.person),
              ),
              CommonTextField(
                colorFilled: Colors.grey.shade300,
                filled: true,
                label: "Mật khẩu",
                hint: Text('********'),
                prefixIcon: Icon(Icons.lock_outline),
                obscureText: hidePassword,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  child:
                      hidePassword
                          ? Icon(Icons.visibility_off_outlined)
                          : Icon(Icons.visibility_outlined),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Quên mật khẩu?", style: TextStyle(fontSize: 12, color: Colors.blue)),
                  ],
                ),
              ),
              PressableWidget(
                label: 'Đăng nhập',
                backgroundColor: Colors.blueAccent,
                width: double.infinity,
                onPressed: () {
                  context.go(AppPaths.loginEmail.path);
                },
              ),
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(child: Divider(color: Colors.grey, height: 10)),
                  const Flexible(child: Text("OR")),
                  const Flexible(child: Divider(color: Colors.grey)),
                ],
              ),
              PressableWidget(
                backgroundColor: Colors.grey.shade300,
                width: double.infinity,
                child: Row(
                  spacing: 4.w,
                  mainAxisSize: MainAxisSize.min,
                  children: [Text('Đăng nhập với'), Icon(Icons.email_outlined)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/auth_cubit/auth_cubit.dart';
import 'package:shan_shan/core/component/custom_elevated.dart';
import 'package:shan_shan/core/component/loading_widget.dart';
import 'package:shan_shan/core/const/color_const.dart';
import 'package:shan_shan/core/utils/navigation_helper.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/model/request_models/shop_login_request_model.dart';
import 'package:shan_shan/view/home/home.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkLoginStatus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(child: _buildLoginForm(screenSize)),
            Expanded(child: _buildImageSection(screenSize)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(Size screenSize) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width / 12),
      color: Colors.white,
      child: SingleChildScrollView(
        
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 25),
              _buildTextField(
                label: "အသုံးပြုသူ နာမည်",
                controller: _nameController,
                validatorMsg: "အသုံးပြုသူ နာမည် ဖြည့်ရန် လိုအပ်ပါသည်",
                icon: CupertinoIcons.person_fill,
              ),
              SizedBox(height: 20),
              _buildTextField(
                label: "စကားဝှက်",
                controller: _passwordController,
                validatorMsg: "စကားဝှက်လိုအပ်သည်",
                icon: CupertinoIcons.lock_fill,
                obscureText: _obscureText,
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: ColorConstants.primaryColor),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
              SizedBox(height: 25),
              _buildLoginButton(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Center(child: Text("မင်္ဂလာပါ", style: TextStyle(fontSize: 20))),
        Center(
          child: Text(
            "ရှန်းရှန်း",
            style: TextStyle(
                fontSize: 49,
                fontWeight: FontWeight.bold,
                color: ColorConstants.primaryColor),
          ),
        ),
        SizedBox(height: 25),
        Center(
          child: Text(
            "အကောင့်ဖြင် ဝင်ပါ။",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String validatorMsg,
    IconData? icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => value!.isEmpty ? validatorMsg : null,
          decoration: customTextDecoration(
            labelText: "$label ရိုက်ထည့်ပါ။",
            prefixIcon: icon != null
                ? Icon(icon, color: ColorConstants.primaryColor)
                : null,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        customPrint("=> auth state : $state");
        if (state is ShopLoggedInState) {
          if (!context.mounted) return;
          NavigationHelper.pushReplacement(context, HomeScreen());
        } else if (state is ShopFailedState) {
          showSnackBar(text: state.error, context: context);
        }
      },
      builder: (context, state) {
        if (state is ShopLoadingState) return LoadingWidget();

        return CustomElevatedButton(
          width: double.infinity,
          height: 63,
          elevation: 0,
          radius: 15,
          child: Text("ဝင်ရောက်ပါမည်"),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<AuthCubit>().login(
                    shopLoginRequest: ShopLoginRequest(
                      username: _nameController.text,
                      password: _passwordController.text,
                    ),
                  );
            }
          },
        );
      },
    );
  }

  Widget _buildImageSection(Size screenSize) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(170),
        height: screenSize.height,
        color: ColorConstants.primaryColor,
        child: Image.asset("assets/images/cashier.png", fit: BoxFit.contain),
      ),
    );
  }
}

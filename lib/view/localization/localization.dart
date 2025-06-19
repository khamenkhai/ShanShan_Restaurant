import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shan_shan/core/component/app_bar_leading.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/const/localekeys.g.dart';
import 'package:shan_shan/core/utils/navigation_helper.dart';
import 'package:shan_shan/view/home/home.dart';

class LocalizationPage extends StatefulWidget {
  const LocalizationPage({super.key});

  @override
  State<LocalizationPage> createState() => _LocalizationPageState();
}

class _LocalizationPageState extends State<LocalizationPage> {
  // Initial language selection, default is English

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        NavigationHelper.pushAndRemove(context, HomeScreen());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 150,
          centerTitle: true,
          leading: AppBarLeading(
            onTap: () {
              NavigationHelper.pushAndRemove(context, HomeScreen());
            },
          ),
          title: Text(tr(LocaleKeys.language)),
        ),
        body: _mainForm(context),
      ),
    );
  }

  /// Main form
  Container _mainForm(BuildContext context) {
    String selectedLanguage = context.locale.languageCode;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConst.kGlobalPadding, vertical: 5),
      child: Column(
        children: [
          RadioListTile<String>(
            title: Text(
              tr("english"),
              style: TextStyle(fontSize: 16),
            ),
            value: 'en',
            groupValue: selectedLanguage,
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
                context.setLocale(Locale('en','US')); // Set locale to English
            
              });
            },
          ),
          RadioListTile<String>(
            title: Text(
               tr("myanmar"),
              style: TextStyle(
                fontSize: 16
              ),
            ),
            value: 'my',
            groupValue: selectedLanguage,
            onChanged: (value) {
              setState(() {
                selectedLanguage = value!;
                context.setLocale(Locale('my', 'MM')); // Set locale to Myanmar
               
              });
            },
          ),
         
        ],
      ),
    );
  }
}

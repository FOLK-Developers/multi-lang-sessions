import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:multi_language_sessions/custom_widgets/loading_indicator_with_text.dart';
import 'package:multi_language_sessions/helpers/background_painter.dart';
import 'package:multi_language_sessions/helpers/textstyles.dart';
import 'package:multi_language_sessions/helpers/utility.dart';
import 'package:multi_language_sessions/providers/country_code_provider.dart';
import 'package:multi_language_sessions/screens/home_page.dart';
import 'package:multi_language_sessions/services/firebase_queries.dart';
import 'package:multi_language_sessions/widgets/logged_in.dart';
import 'package:multi_language_sessions/widgets/signup_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsScreen extends StatefulWidget {
  final bool hasSignedIn;
  final User? user;
  // ignore: avoid_init_to_null
  DetailsScreen({Key? key, this.hasSignedIn = false, this.user = null})
      : super(key: key);
  static const routeName = '/details-screen';

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final cityController = TextEditingController();

  final numberController = TextEditingController();

  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? _initValue = 97;
  bool isLoading = false;
  Map<String, dynamic> data = {};

  void autofillData() {
    FirebaseQueries().getUserData(widget.user!.email!).then((value) {
      if (value != null)
        setState(() {
          nameController.text = value['name'];
          numberController.text = value['number'];
          cityController.text = value['city'];
          isLoading = false;
        });
      else {
        setState(() {
          isLoading = false;
          nameController.text = widget.user!.displayName!;
          numberController.text = '';
          cityController.text = '';
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.hasSignedIn)
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {
          isLoading = true;
        });
        autofillData();
      });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    cityController.dispose();
    numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              fit: StackFit.loose,
              children: [
                CustomPaint(
                  painter: BackgroundPainter(),
                  size: Size.infinite,
                ),
                Positioned(
                  top: height / 4,
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        height: height / 1.1,
                        width: width / 1.1,
                        child: Column(
                          //padding: const EdgeInsets.all(15.0),
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SelectableText(
                              'Tell us a bit about you',
                              style: RobotoBoldStyle(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            // SelectableText(
                            //   'Name',
                            //   style: RobotoBoldStyle(weight: FontWeight.w400),
                            // ),
                            myTextFormField('Name', nameController, 'name'),
                            SizedBox(
                              height: 30,
                            ),
                            // SelectableText(
                            //   'Phone Number',
                            //   style: RobotoBoldStyle(weight: FontWeight.w400),
                            // ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Consumer<CountryCodeProvider>(
                                    builder: (context, countryProvider, child) {
                                  return Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: SizedBox(
                                      width: 79,
                                      child: DropdownButton(
                                        onChanged: (dynamic val) {
                                          setState(() {
                                            _initValue = val;
                                          });
                                          print(_initValue);
                                        },
                                        value: _initValue,
                                        items: List.generate(
                                          countryProvider
                                              .countryCodeList.length,
                                          (i) => DropdownMenuItem(
                                            child: Text(
                                                ' ${countryProvider.countryCodeList[i].phoneCode}'),
                                            value: i + 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                myTextFormField(
                                    'Number', numberController, 'number'),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            // SelectableText(
                            //   'City',
                            //   style: RobotoBoldStyle(weight: FontWeight.w400),
                            // ),
                            myTextFormField('City', cityController, 'city'),
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              height: 70,
                              child: ElevatedButton(
                                onPressed: () {
                                  final _country =
                                      Provider.of<CountryCodeProvider>(context,
                                              listen: false)
                                          .currentCountry;
                                  // if (widget.hasSignedIn) {
                                  SharedPreferences.getInstance().then((value) {
                                    value.setBool('user_data', true);
                                    value.setString(
                                        'mobile',
                                        (numberController.text
                                                .contains(_country.phoneCode!)
                                            ? numberController.text
                                            : _country.phoneCode! +
                                                numberController.text.trim()));
                                  });
                                  //}
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => Dialog(
                                            child: LoadingIndicatorWithMessage(
                                                text:
                                                    'Checking if the details exists.'),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ));
                                  FirebaseQueries()
                                      .checkNumberExists((numberController.text
                                              .contains(_country.phoneCode!)
                                          ? numberController.text
                                          : _country.phoneCode! +
                                              numberController.text.trim()))
                                      .then((value) {
                                    Navigator.of(context).pop();
                                    if (value == null) {
                                      data.addAll({
                                        'name': nameController.text,
                                        'number': (numberController.text
                                                .contains(_country.phoneCode!)
                                            ? numberController.text
                                            : _country.phoneCode! +
                                                numberController.text.trim()),
                                        'city': cityController.text,
                                        'language': 'English',
                                        'gmail': widget.user == null
                                            ? ''
                                            : widget.user!.email,
                                        'photo_url': widget.user == null
                                            ? 'https://www.pngkey.com/png/full/282-2820067_taste-testing-at-baskin-robbins-empty-profile-picture.png'
                                            : widget.user!.photoURL,
                                        'last_seen': Utility.getCurrentEpoch
                                      });
                                      print(
                                          '===================\n Data: $data\n=================');
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LoggedInWidget(
                                                    widget.user,
                                                    data,
                                                    (_country.phoneCode! +
                                                            numberController
                                                                .text)
                                                        .trim()),
                                          ),
                                          (route) => false);

                                      FirebaseQueries().setUserData(data);
                                    } else if (value['gmail'] != null &&
                                        value['gmail'] != '' &&
                                        !widget.hasSignedIn) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text('Alert'),
                                                content: Text(
                                                    'The number already exists and is linked with the gmail id : ${value['gmail']} '),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Okay'),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                  ),
                                                ],
                                              )).then((value) {
                                        if (value) {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(),
                                                  ),
                                                  (route) => false);
                                        }
                                      });
                                    } else if (value['gmail'] != null &&
                                        value['gmail'] != '' &&
                                        widget.hasSignedIn) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LoggedInWidget(
                                                    widget.user,
                                                    value.data()!,
                                                    value['number'].trim()),
                                          ),
                                          (route) => false);
                                    } else {
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LoggedInWidget(
                                                    widget.user,
                                                    value.data()!,
                                                    (_country.phoneCode! +
                                                            numberController
                                                                .text)
                                                        .trim()),
                                          ),
                                          (route) => false);
                                    }
                                  });
                                },
                                child: Text('Done'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget myTextFormField(
      String name, TextEditingController ctrl, String keyVal) {
    return Container(
      height: 70,
      width: 200,
      child: TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
          hintText: name,
          hintStyle: RobotoBoldStyle(),
        ),
        style: RobotoBoldStyle(),
        onChanged: (val) {
          final text = val;
          data.update(keyVal, (value) {
            return text;
          }, ifAbsent: () {
            return text;
          });
        },
        onFieldSubmitted: (s) {
          setState(() {
            ctrl.text = s;
          });
        },
        validator: name == 'Number'
            ? (value) {
                var _num = int.tryParse(value!);
                if (_num == null || value.length != 10) {
                  return 'Enter valid number';
                }
                return null;
              }
            : ctrl.text == ''
                ? (_) {}
                : (val) {
                    print('Name VAL $val');
                    if (val!.isEmpty) {
                      return 'Please enter your $name.';
                    } else {
                      return null;
                    }
                  },
      ),
    );
  }
}

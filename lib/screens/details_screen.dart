import 'package:flutter/material.dart';
import 'package:multi_language_sessions/helpers/background_painter.dart';
import 'package:multi_language_sessions/helpers/textstyles.dart';
import 'package:multi_language_sessions/providers/country_code_provider.dart';
import 'package:multi_language_sessions/widgets/logged_in.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({Key? key}) : super(key: key);
  static const routeName = '/details-screen';

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final cityController = TextEditingController();

  final numberController = TextEditingController();

  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    cityController.dispose();
    numberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? _initValue;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: BackgroundPainter(),
          ),
          Positioned(
            top: height / 3,
            child: buildForm(height, width, _initValue),
          ),
        ],
      ),
    );
  }

  Widget buildForm(double height, double width, int? value) {
    return Form(
      key: _formKey,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10.0),
        height: height / 1.2,
        width: width / 1.1,
        child: ListView(
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
            myTextFormField('Name', nameController),
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
                          print(val);
                          setState(() {
                            value = val;
                          });
                        },
                        value: value,
                        items: List.generate(
                          countryProvider.countryCodeList.length,
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
                myTextFormField('Number', numberController),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            // SelectableText(
            //   'City',
            //   style: RobotoBoldStyle(weight: FontWeight.w400),
            // ),
            myTextFormField('City', cityController),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(LoggedInWidget.routeName);
              },
              child: Text('Next Screen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget myTextFormField(String name, TextEditingController ctrl) {
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

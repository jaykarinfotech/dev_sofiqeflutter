// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:country_code_picker/country_code.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sofiqe/controller/msProfileController.dart';
import 'package:sofiqe/provider/account_provider.dart';
import 'package:sofiqe/screens/Ms1/editProfileAppbar.dart';
import 'package:sofiqe/utils/constants/api_tokens.dart';
import 'package:sofiqe/widgets/custom_form_field.dart';

import '../../widgets/account/phone_number_field.dart';

class SofiqueEditProfile extends StatefulWidget {
  const SofiqueEditProfile({Key? key}) : super(key: key);

  @override
  _SofiqueEditProfileState createState() => _SofiqueEditProfileState();
}

class _SofiqueEditProfileState extends State<SofiqueEditProfile> {
  MsProfileController _ = Get.find<MsProfileController>();

  // String selectedGender = "";
  // bool sameAsShippingAddress = false;
  final _formKey = GlobalKey<FormState>();
  bool isUpdate = true;

  @override
  void initState() {
    super.initState();
    //  selectedGender = _.getUserProfile();
    // print(selectedGender);
    // ;
  }

  @override
  Widget build(BuildContext context) {
    AccountProvider ap = Provider.of<AccountProvider>(context);
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                EditProfileAppbar(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'THANKS FOR BEING A SOFIQE',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Here you can amend your profile etc.',
                  style: TextStyle(fontSize: 10, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                coverWidgetWithPadding(
                  child: Row(
                    children: [
                      Text(
                        'I’M A',
                        style: TextStyle(fontSize: 9, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                coverWidgetWithPadding(
                  child: Container(
                    height: 85,
                    width: Get.width,
                    // color: Colors.yellow,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        displayGenderContainer(
                            image: "woman.png", title: 'FEMALE'),
                        displayGenderContainer(
                            image: "male.png", title: 'MALE'),
                        displayGenderContainer(
                            image: "heart-3.png", title: 'GENDERLESS'),
                        displayGenderContainer(
                            image: "heart-2.png", title: 'LBGT'),
                      ],
                    ),
                  ),
                ),
                displayColorDivider(),
                displayTextFieldContainer(
                  title: 'MY FIRST NAME IS',
                  controller: _.firstNameController,
                ),
                Container(
                  height: 5,
                  color: Color(0xffF4F2F0),
                ),
                displayTextFieldContainer(
                  title: 'MY LAST NAME IS',
                  controller: _.lastNameController,
                  //  backgroundColor: Color(0xffF4F2F0)
                ),
                Container(
                  height: 5,
                  color: Color(0xffF4F2F0),
                ),
                displayTextFieldContainer(
                    title: 'MY EMAIL IS',
                    controller: _.emailController,
                    hint: "Email"),
                Container(
                  height: 25,
                  color: Color(0xffF4F2F0),
                  alignment: Alignment.centerLeft,
                  child: coverWidgetWithPadding(
                      child: Text(
                    'SHIPPING ADDRESS',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  )),
                ),
                // displayTextFieldContainer(
                //     title: 'COUNTRY',
                //     controller: _.countryController,
                //     hint: "Denmark"),
                // displayColorDivider(),

                displayTextFieldContainer(
                  title: 'STREET',
                  controller: _.streetController,
                  hint: "",
                  // backgroundColor: Color(0xffF4F2F0),
                ),
                displayColorDivider(),
                displayTextFieldContainer(
                    title: 'POST/ZIP CODE',
                    textInputType: TextInputType.phone,
                    controller: _.postCodeController),
                Container(
                  height: 5,
                  color: Color(0xffF4F2F0),
                ),
                // Container(
                //   color: Color(0xffF4F2F0),
                //   // padding: EdgeInsets.],
                //   child: Row(
                //     children: [
                //       // Container(
                //       //   width: Get.width * 0.4,
                //       //   child: displayTextFieldContainer(
                //       //     title: 'POST/ZIP CODE',
                //       //   ),
                //       // ),

                //     ],
                //   ),
                // ),
                displayTextFieldPhoneContainer(
                    title: 'PHONE',
                    controller: _.phoneController,
                    prefix: /*CountryCodePicker(
                      onInit: widget.init,
                      onChanged: widget.callback,
                      initialSelection: initialSelection,
                      padding: EdgeInsets.all(0.0),
                      textStyle: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.black,
                        fontSize: size.height * 0.019,
                      ),
                      showFlag: false,
                      showCountryOnly: true,
                    );*/
                        CountryCodeDropDown(
                      byDefaultSelection:
                          _.phoneNumberCodeController.text.toString(),
                      callback: (CountryCode code) {
                        _.phoneNumberCodeController.text =
                            code.dialCode as String;
                        print(code);
                      },
                      init: (CountryCode? code) {
                        _.phoneNumberCodeController.text =
                            code!.dialCode as String;
                      },
                    ),
                    hint: '',
                    textInputType: TextInputType.phone),
                // PhoneNumberField(
                //   onTap: () {
                //     setState(() {});
                //   },
                //   isBeingEdited: false,
                //   phoneNumberController:_.phoneController,
                //   phoneNumberCodeController: _.phoneNumberCodeController,
                //   // phoneNumberCodeController: widget.phoneNumberCodeController,
                // ),

                displayColorDivider(),
                Container(
                  height: 90,
                  child: coverWidgetWithPadding(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // SizedBox(height: 20,),

                        Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "BILLING ADDRESS",
                                  style:
                                      TextStyle(fontSize: 11, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Same as shipping address",
                              style:
                                  TextStyle(fontSize: 11, color: Colors.black),
                            ),
                            Transform.scale(
                              scale: 0.8,
                                child: CupertinoSwitch(
                                    value: _.isShiping.value,
                                    activeColor: Colors.green ,
                                    trackColor:  Colors.black,
                                    thumbColor: Colors.white ,
                                    onChanged: (val) {
                                      _.isShiping.value = val;
                                      setState(() {});
                                    }),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _.isShiping.value
                    ? Container()
                    : Column(
                        children: [
                          // Container(
                          //   height: 25,
                          //   color: Color(0xffF4F2F0),
                          //   alignment: Alignment.centerLeft,
                          //   child: coverWidgetWithPadding(
                          //       child: Text(
                          //     'SHIPPING ADDRESS',
                          //     style: TextStyle(
                          //         fontSize: 11, fontWeight: FontWeight.bold),
                          //   )),
                          // ),
                          displayTextFieldContainer(
                              title: 'COUNTRY',
                              controller: _.countryController,
                              hint: "Denmark"),
                          displayColorDivider(),
                          displayTextFieldContainer(
                            title: 'STREET',
                            controller: _.streetController,
                            hint: "",
                            // backgroundColor: Color(0xffF4F2F0),
                          ),
                          displayColorDivider(),
                          displayTextFieldContainer(
                              title: 'POST/ZIP CODE',
                              textInputType: TextInputType.phone,
                              controller: _.postCodeController),
                        ],
                      ),

                displayColorDivider(),
                Container(
                  height: 220,
                  color: Color(0xffF4F2F0),
                  child: coverWidgetWithPadding(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // SizedBox(height: 20,),
                        Row(
                          children: [
                            Text(
                              "CARD DETAILS",
                              style:
                                  TextStyle(fontSize: 11, color: Colors.black),
                            ),
                            Text(
                              ' *',
                              style: TextStyle(fontSize: 11, color: Colors.red),
                            ),
                          ],
                        ),

                        TextFormField(
                          controller: _.cardNumberController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              border: InputBorder.none,
                              hintText: 'CARD NUMBER',
                              suffix: Icon(Icons.credit_card)),
                        ),

                        Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: Container(
                                // width: 150,
                                child: TextFormField(
                                  controller: _.monthCardController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: InputBorder.none,
                                    hintText: 'MONTH / YEAR',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 2,
                              // width: 150,
                              child: TextFormField(
                                controller: _.cvcController,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  hintText: 'CVC',
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Container(
                        //       height: 20,
                        //       width: 20,
                        //       decoration: BoxDecoration(shape: BoxShape.circle),
                        //       child: Icon(
                        //         Icons.camera_alt_outlined,
                        //         size: 18,
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: 10,
                        //     ),
                        //     Text(
                        //       "SCAN YOUR CARD",
                        //       style: TextStyle(fontSize: 9, color: Colors.black),
                        //     ),
                        //     Spacer(),
                        //     Container(
                        //         height: 20,
                        //         width: 20,
                        //         alignment: Alignment.center,
                        //         decoration: BoxDecoration(
                        //             shape: BoxShape.circle, color: Colors.black),
                        //         child: Text(
                        //           "?",
                        //           style: TextStyle(color: Colors.white),
                        //         ) //Icon(,size: 18,),
                        //         ),
                        //     SizedBox(
                        //       width: 10,
                        //     ),
                        //     Text(
                        //       "SCAN YOUR CARD",
                        //       style: TextStyle(fontSize: 9, color: Colors.black),
                        //     ),
                        //   ],
                        // ),

                        coverWidgetWithPadding(
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {});
                              //need to use form validator
                              final isValid = _formKey.currentState?.validate();
                              if (!checkEmpty()) {
                                print("true");
                                if (await _.updateUserProfile()) {
                                  print("Success Login");
                                  ap.getUserDetails(
                                      await APITokens.customerSavedToken);
                                  _.getUserProfile();
                                  setState(() {});

                                  // Get.back();
                                }
                              } else {
                                Get.showSnackbar(GetBar(
                                  message: 'please fill all the fields',
                                  duration: Duration(seconds: 2),
                                ));
                              }
                            },
                            child: Container(
                              height: 45,
                              width: Get.width,
                              decoration: BoxDecoration(
                                  color: Color(0xffF2CA8A),
                                  borderRadius: BorderRadius.circular(50)),
                              alignment: Alignment.center,
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget coverWidgetWithPadding({Widget? child}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }

  Widget displayGenderContainer(
      {required String image, required String title}) {
    return InkWell(
      onTap: () {
        _.selectedGender = title;
        setState(() {});
      },
      child: Container(
        height: 65,
        width: 58,
        decoration: BoxDecoration(
          border: (title == _.selectedGender)
              ? Border(bottom: BorderSide(color: Color(0xffF2CA8A)))
              : null,
          color: (title == _.selectedGender) ? Color(0xffF4F2F0) : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/images/$image',
              height: 28,
              width: 15,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 8, color: Colors.black),
            )
          ],
        ),
      ),
    );
  }

  bool checkEmpty() {
    if (_.firstNameController.value.text.isEmpty ||
        _.lastNameController.value.text.isEmpty ||
        _.emailController.value.text.isEmpty ||
        _.countryController.value.text.isEmpty ||
        _.streetController.value.text.isEmpty ||
        _.phoneController.value.text.isEmpty ||
        _.selectedGender == "") {
      return true;
    } else {
      return false;
    }
  }

  displayTextFieldContainer(
      {String? title,
      TextEditingController? controller,
      Color? backgroundColor,
      String? prefix,
      TextInputType? textInputType,
      String? hint}) {
    return Container(
      height: 66,
      color: backgroundColor,
      padding: EdgeInsets.only(top: 5),
      child: coverWidgetWithPadding(
          child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Text(
                    title!,
                    style: TextStyle(fontSize: 11, color: Colors.black),
                  ),
                  Text(
                    ' *',
                    style: TextStyle(fontSize: 11, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          TextFormField(
            validator: (str) {
              if (str == '' || str == null) {
                isUpdate = false;
              }
              return null;
            },
            keyboardType: textInputType ?? TextInputType.text,
            controller: controller,
            decoration: InputDecoration(
                hintText: hint, prefixText: prefix, border: InputBorder.none),
          ),
        ],
      )),
    );
  }

  displayTextFieldPhoneContainer(
      {String? title,
      TextEditingController? controller,
      Color? backgroundColor,
      Widget? prefix,
      TextInputType? textInputType,
      String? hint}) {
    return Container(
      height: 66,
      color: backgroundColor,
      padding: EdgeInsets.only(top: 5),
      child: coverWidgetWithPadding(
          child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Text(
                    title!,
                    style: TextStyle(fontSize: 11, color: Colors.black),
                  ),
                  Text(
                    ' *',
                    style: TextStyle(fontSize: 11, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          TextFormField(
            validator: (str) {
              if (str == '' || str == null) {
                isUpdate = false;
              }
              return null;
            },
            keyboardType: textInputType ?? TextInputType.text,
            controller: controller,
            decoration: InputDecoration(
                hintText: hint, prefixIcon: prefix, border: InputBorder.none),
          ),
        ],
      )),
    );
  }

  displayColorDivider() {
    return Divider(
      color: Color(0xffF4F2F0),
      thickness: 5,
    );
  }
}

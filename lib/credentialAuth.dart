import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iskoolz/components/loaderDialog/loaderDialog.dart';
import 'package:iskoolz/home/components/home.dart';
import 'package:iskoolz/home/widgets/customAppBar.dart';
import 'package:iskoolz/localization/app_translations.dart';
import 'package:iskoolz/provider/updateData.dart';
import 'package:iskoolz/routers/generated_route.dart';
import 'package:iskoolz/services/database_services.dart';
import 'package:iskoolz/services/preferenceServices.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:iskoolz/services/authservice.dart';

AuthService authService = AuthService();
LoacalDataBase lb = LoacalDataBase();

class OTPScreen extends StatefulWidget {
  final String phone;
  OTPScreen(this.phone);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _verificationCode;
  bool enableButton = false;
  var otpPin;
  PhoneAuthCredential? loginCredentials;
  Timer? _timer;
  var counter = 59;
  var duration = Duration(seconds: 59);
  bool timeout = false;
  final TextEditingController _pinPutController = TextEditingController();
  final BoxDecoration pinPutDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: Colors.grey));

  final BoxDecoration pinSelectionDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(width: 1.2, color: Colors.grey));

  customTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (duration > Duration(seconds: 0)) {
        setState(() {
          duration = duration - Duration(seconds: 1);
        });
      } else if (duration == Duration(seconds: 0)) {
        setState(() {
          timeout = true;
        });
        _timer!.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    customTimer();
    _verifyPhone();
    appSignature();
    super.initState();
  }

  appSignature() async {
    var x = await SmsAutoFill().getAppSignature;
    print(x.toString());
  }

  _verifyPhone() async {
    try {
      await authService.firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await authService.firebaseAuth
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user?.uid != null) {
              userVerify(value, context);
              var checkSubscribedPlans =
                  Provider.of<SubscriptionData>(context, listen: false);
              var deviceId = checkSubscribedPlans.deviceName;
              await checkSubscribedPlans.setCurrentUID(value.user?.uid);
              await checkSubscribedPlans.setUserData();
              await FirebaseFirestore.instance
                  .collection('signedInUser')
                  .doc(value.user?.uid)
                  .get()
                  .then((DocumentSnapshot documentSnapshot) async {
                if (documentSnapshot.exists &&
                    documentSnapshot.get("deviceId") != deviceId) {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actionsPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          title: Text(
                              AppTranslations.of(context)!.text('Log out'),
                              style: Theme.of(context).textTheme.button),
                          content: Text(AppTranslations.of(context)!.text(
                              "It seems you are already logged in to another device")),
                          actions: [
                            TextButton(
                              onPressed: () {
                                authService.firebaseAuth.signOut();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login', (Route<dynamic> route) => false);
                              },
                              child: Text(
                                  AppTranslations.of(context)!.text("Cancel"),
                                  style: Theme.of(context).textTheme.button),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('signedInUser')
                                      .doc(value.user?.uid)
                                      .set({
                                    "deviceId": deviceId,
                                  }, SetOptions(merge: true));
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(value.user!.uid)
                                        .get()
                                        .then((DocumentSnapshot
                                            documentSnapshot) async {
                                      await lb.setValue("uuid",
                                          documentSnapshot.get("uid") ?? "");
                                      await lb.setValue(
                                          "udisplayName",
                                          documentSnapshot.get("displayName") ??
                                              "");
                                      await lb.setValue(
                                          "uphotoURL",
                                          documentSnapshot.get("photoURL") ??
                                              "");
                                      await lb.setValue("ucourse",
                                          documentSnapshot.get("course") ?? "");
                                      await lb.setValue("uemail",
                                          documentSnapshot.get("email") ?? "");
                                      await lb.setValue("uphone",
                                          documentSnapshot.get("phone"));
                                      await lb.setValue("nophone",
                                          documentSnapshot.get("phoneNumber"));
                                      await lb.setValue("ugender",
                                          documentSnapshot.get("gender") ?? "");
                                      await lb.setValue("uschool",
                                          documentSnapshot.get("school") ?? "");
                                      await lb.setValue(
                                          "ureferalId",
                                          documentSnapshot.get("referalId") ??
                                              "");
                                      await lb.setValue(
                                          "referrar",
                                          documentSnapshot.get("referral") ??
                                              "");
                                    });
                                  } catch (e) {
                                    print(e);
                                  }
                                } catch (e) {
                                  debugPrint(
                                      "Error is updating status on firestore : $e");
                                }
                                debugPrint("Force Logout Button pressed");
                                Navigator.of(context).pop();
                                GeneratedRoute.navigatorpushandremove(
                                    Home.routeName);
                              },
                              child: Text(AppTranslations.of(context)!
                                  .text("Log out other devices")),
                            ),
                          ],
                        );
                      });
                } else {
                  var deviceId = checkSubscribedPlans.deviceName;
                  await FirebaseFirestore.instance
                      .collection("signedInUser")
                      .doc(value.user!.uid)
                      .set({
                    "deviceId": deviceId,
                    "userEmail": value.user!.email,
                    "phone": value.user!.phoneNumber,
                    "logoutfromAllDevices": false,
                    "isLoggedIn": true,
                  });
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(value.user!.uid)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) async {
                      await lb.setValue(
                          "uuid", documentSnapshot.get("uid") ?? "");
                      await lb.setValue("udisplayName",
                          documentSnapshot.get("displayName") ?? "");
                      await lb.setValue(
                          "uphotoURL", documentSnapshot.get("photoURL") ?? "");
                      await lb.setValue(
                          "ucourse", documentSnapshot.get("course") ?? "");
                      await lb.setValue(
                          "uemail", documentSnapshot.get("email") ?? "");
                      await lb.setValue(
                          "uphone", documentSnapshot.get("phone"));
                      await lb.setValue(
                          "nophone", documentSnapshot.get("phoneNumber"));
                      await lb.setValue(
                          "ugender", documentSnapshot.get("gender") ?? "");
                      await lb.setValue(
                          "uschool", documentSnapshot.get("school") ?? "");
                      await lb.setValue("ureferalId",
                          documentSnapshot.get("referalId") ?? "");
                      await lb.setValue(
                          "referrar", documentSnapshot.get("referral") ?? "");
                    });
                  } catch (e) {
                    print(e);
                  }
                  final dialogContextCompleter = Completer<BuildContext>();
                  showDialog<void>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext dialogContext) {
                      if (!dialogContextCompleter.isCompleted) {
                        dialogContextCompleter.complete(dialogContext);
                      }
                      return UserVerificationDialog();
                    },
                  );
                  GeneratedRoute.navigatorpushandremove(Home.routeName);
                }
              });
            } else {
              Fluttertoast.showToast(
                  msg: AppTranslations.of(context)!.text("Please try again"),
                  timeInSecForIosWeb: 4,
                  gravity: ToastGravity.BOTTOM);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) async {
          FocusScope.of(context).unfocus();
          Fluttertoast.showToast(
              msg: "${e.message}",
              timeInSecForIosWeb: 4,
              gravity: ToastGravity.BOTTOM);
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          Fluttertoast.showToast(
              msg: AppTranslations.of(context)!.text("OTP sent"),
              timeInSecForIosWeb: 4,
              gravity: ToastGravity.BOTTOM);
          await SmsAutoFill().listenForCode;
          setState(() {
            _verificationCode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          _verificationCode = verificationID;
          print('timeout');
        },
        timeout: const Duration(seconds: 30),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message!);
      Fluttertoast.showToast(
          msg: e.message!, timeInSecForIosWeb: 4, gravity: ToastGravity.BOTTOM);
    }
  }

  signInWithCredentials(otp) async {
    final dialogContextCompleter = Completer<BuildContext>();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        if (!dialogContextCompleter.isCompleted) {
          dialogContextCompleter.complete(dialogContext);
        }
        return UserVerificationDialog();
      },
    );
    try {
      await authService.firebaseAuth
          .signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: _verificationCode!, smsCode: otp),
      )
          .then((value) async {
        if (value.user?.uid != null) {
          userVerify(value, context);
          var checkSubscribedPlans =
              Provider.of<SubscriptionData>(context, listen: false);
          await checkSubscribedPlans.setCurrentUID(value.user?.uid);
          await checkSubscribedPlans.setUserData();
          var deviceId = checkSubscribedPlans.deviceName;
          await FirebaseFirestore.instance
              .collection('signedInUser')
              .doc(value.user?.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) async {
            if (documentSnapshot.exists &&
                documentSnapshot.get("deviceId") != deviceId) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      title: Text(AppTranslations.of(context)!.text('Log out')),
                      content: Text(AppTranslations.of(context)!.text(
                          "It seems you are already logged in to another device")),
                      actions: [
                        TextButton(
                          onPressed: () {
                            authService.firebaseAuth.signOut();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (Route<dynamic> route) => false);
                          },
                          child: Text(
                              AppTranslations.of(context)!.text("Cancel"),
                              style: Theme.of(context).textTheme.button),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              var checkSubscribedPlans =
                                  Provider.of<SubscriptionData>(context,
                                      listen: false);
                              var deviceId = checkSubscribedPlans.deviceName;
                              await FirebaseFirestore.instance
                                  .collection('signedInUser')
                                  .doc(value.user?.uid)
                                  .set({
                                "deviceId": deviceId,
                              }, SetOptions(merge: true));
                              try {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(value.user!.uid)
                                    .get()
                                    .then((DocumentSnapshot
                                        documentSnapshot) async {
                                  await lb.setValue("uuid",
                                      documentSnapshot.get("uid") ?? '');
                                  await lb.setValue(
                                      "uid", documentSnapshot.get("uid") ?? '');
                                  await lb.setValue(
                                      "udisplayName",
                                      documentSnapshot.get("displayName") ??
                                          '');
                                  await lb.setValue("uphotoURL",
                                      documentSnapshot.get("photoURL") ?? '');
                                  await lb.setValue("ucourse",
                                      documentSnapshot.get("course") ?? '');
                                  await lb.setValue("uemail",
                                      documentSnapshot.get("email") ?? '');
                                  await lb.setValue(
                                      "uphone", documentSnapshot.get("phone"));
                                  await lb.setValue("nophone",
                                      documentSnapshot.get("phoneNumber"));
                                  await lb.setValue("ugender",
                                      documentSnapshot.get("gender") ?? "");
                                  await lb.setValue("uschool",
                                      documentSnapshot.get("school") ?? "");
                                  await lb.setValue("ureferalId",
                                      documentSnapshot.get("referalId") ?? "");
                                  await lb.setValue("referrar",
                                      documentSnapshot.get("referral") ?? "");
                                });
                              } catch (e) {
                                print(e);
                              }
                            } catch (e) {
                              print(e);
                            }
                            GeneratedRoute.navigatorpushandremove(
                                Home.routeName);
                          },
                          child: Text(
                              AppTranslations.of(context)!
                                  .text("Log out other devices"),
                              style: Theme.of(context).textTheme.button),
                        ),
                      ],
                    );
                  });
            } else {
              await FirebaseFirestore.instance
                  .collection("signedInUser")
                  .doc(value.user!.uid)
                  .set({
                "deviceId": deviceId,
                "userEmail": value.user!.email,
                "phone": value.user!.phoneNumber,
                "logoutfromAllDevices": false,
                "isLoggedIn": true,
              });
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(value.user!.uid)
                    .get()
                    .then((DocumentSnapshot documentSnapshot) async {
                  await lb.setValue("uuid", documentSnapshot.get("uid") ?? "");
                  await lb.setValue("uid", documentSnapshot.get("uid") ?? "");
                  await lb.setValue("udisplayName",
                      documentSnapshot.get("displayName") ?? '');
                  await lb.setValue(
                      "uphotoURL", documentSnapshot.get("photoURL") ?? '');
                  await lb.setValue(
                      "ucourse", documentSnapshot.get("course") ?? '');
                  await lb.setValue(
                      "uemail", documentSnapshot.get("email") ?? '');
                  await lb.setValue("uphone", documentSnapshot.get("phone"));
                  await lb.setValue(
                      "nophone", documentSnapshot.get("phoneNumber"));
                  await lb.setValue(
                      "nophone", documentSnapshot.get("phoneNumber"));
                  await lb.setValue(
                      "ugender", documentSnapshot.get("gender") ?? '');
                  await lb.setValue(
                      "uschool", documentSnapshot.get("school") ?? "");
                  await lb.setValue(
                      "ureferalId", documentSnapshot.get("referalId") ?? "");
                  await lb.setValue(
                      "referrar", documentSnapshot.get("referral") ?? '');
                });
                GeneratedRoute.navigatorpushandremove(Home.routeName);
              } catch (e) {
                GeneratedRoute.navigatorpushandremove(Home.routeName);
              }
            }
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      print("Error is : $e");
      FocusScope.of(context).unfocus();
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM,
          msg: AppTranslations.of(context)!.text("Something went wrong"),
          timeInSecForIosWeb: 20);
    }
  }

  userVerify(value, ctx) async {
    try {
      if (value.user?.uid != null) {
        var updateData = Provider.of<SubscriptionData>(context, listen: false);
        updateData.streamUserData();
        SharedPreferences froles = await SharedPreferences.getInstance();
        String checkRoles;
        checkRoles = await DatabaseService().getRoles(value.user?.uid, ctx);
        await froles.setString('roles', checkRoles);
      } else {
        Fluttertoast.showToast(
            msg: AppTranslations.of(context)!.text("Please try again"),
            timeInSecForIosWeb: 4,
            gravity: ToastGravity.BOTTOM);
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.message!, timeInSecForIosWeb: 4, gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: _height < 550 ? false : true,
      appBar: CustomAppBar(title: '', height: 72.0),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(AppTranslations.of(context)!.text('Verify OTP'),
                    style: Theme.of(context).textTheme.headline6),
                SizedBox(height: 8.0),
                Wrap(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: AppTranslations.of(context)!
                            .text("We've sent it on : +91 "),
                        style: Theme.of(context).textTheme.caption!.merge(
                              TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14.0,
                              ),
                            ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${widget.phone}',
                            style: Theme.of(context).textTheme.caption!.merge(
                                  TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14.0,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.0),
                    InkWell(
                      child: Text(
                        AppTranslations.of(context)!.text('Edit number'),
                        style: Theme.of(context).textTheme.caption!.merge(
                              TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14.0),
                            ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                SizedBox(height: 24.0),
                PinPut(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  inputDecoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.red, width: 1.5),
                    ),
                  ),
                  autofillHints: [AutofillHints.oneTimeCode],
                  onChanged: (a) {
                    if (_pinPutController.text.length == 6) {
                      setState(() {
                        enableButton = true;
                      });
                    } else {
                      setState(() {
                        enableButton = false;
                      });
                    }
                  },
                  autofocus: true,
                  fieldsCount: 6,
                  textInputAction: TextInputAction.done,
                  controller: _pinPutController,
                  enabled: true,
                  withCursor: true,
                  textStyle: const TextStyle(fontSize: 20.0),
                  eachFieldHeight: 50.0,
                  submittedFieldDecoration: pinPutDecoration,
                  selectedFieldDecoration: pinSelectionDecoration,
                  followingFieldDecoration: pinPutDecoration,
                  pinAnimationType: PinAnimationType.scale,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter OTP';
                    }
                    return null;
                  },
                  onSubmit: (pin) async {
                    setState(() {
                      otpPin = pin;
                    });
                    FocusScope.of(context).unfocus();
                    signInWithCredentials(otpPin);
                  },
                ),
                SizedBox(height: 24.0),
                Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${duration.toString().substring(3, 7)} ",
                          style: Theme.of(context).textTheme.caption!.merge(
                              TextStyle(fontSize: 18, letterSpacing: .9)),
                        ),
                        SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            text: AppTranslations.of(context)!
                                .text("Didn't receive OTP? "),
                            style: Theme.of(context).textTheme.subtitle1!.merge(
                                TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300)),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    AppTranslations.of(context)!.text('Resend'),
                                style: timeout
                                    ? Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .merge(TextStyle(color: Colors.red))
                                    : Theme.of(context).textTheme.caption,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = !timeout
                                      ? null
                                      : () {
                                          setState(() {
                                            duration = Duration(seconds: 59);
                                          });
                                          _verifyPhone();
                                          setState(() {
                                            timeout = false;
                                          });
                                          customTimer();
                                        },
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

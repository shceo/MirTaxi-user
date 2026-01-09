import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';
import 'package:tagyourtaxi_driver/src/presentation/translations/translation.dart';
import 'package:tagyourtaxi_driver/src/presentation/viewmodels/auth_view_model.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/get_started.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/select_task_screen.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/booking_confirmation.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/invoice.dart';
import 'package:tagyourtaxi_driver/src/presentation/widgets/widgets.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final TextEditingController otpController = TextEditingController();
  String _error = '';
  late final AuthViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel();
    _viewModel.startResendTimer();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    otpController.dispose();
    super.dispose();
  }

  void _navigate(AuthDestination destination) {
    switch (destination) {
      case AuthDestination.invoice:
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => const Invoice()), (route) => false);
        break;
      case AuthDestination.bookingConfirmationRental:
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => BookingConfirmation(type: 1)), (route) => false);
        break;
      case AuthDestination.bookingConfirmation:
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => BookingConfirmation()), (route) => false);
        break;
      case AuthDestination.selectTask:
        Navigator.pushAndRemoveUntil(
            context, MaterialPageRoute(builder: (context) => const SelectTaskScreen()), (route) => false);
        break;
      case AuthDestination.getStarted:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GetStarted()));
        break;
    }
  }

  Future<void> _verifyOtp() async {
    final result = await _viewModel.verifyOtp(otpController.text);
    if (result.hasError) {
      setState(() {
        _error = result.error ?? '';
      });
      return;
    }
    setState(() {
      _error = '';
    });
    if (result.destination != null) {
      _navigate(result.destination!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl') ? TextDirection.rtl : TextDirection.ltr,
        child: ValueListenableBuilder(
          valueListenable: valueNotifierHome.value,
          builder: (context, value, child) {
            return AnimatedBuilder(
              animation: _viewModel,
              builder: (context, _) {
                final resendTime = _viewModel.resendSeconds;
                final otpLength = otpController.text.length;
                final buttonText = (otpLength == 6)
                    ? languages[choosenLanguage]['text_verify']
                    : (resendTime == 0)
                        ? languages[choosenLanguage]['text_resend_code']
                        : "${languages[choosenLanguage]['text_resend_code']} $resendTime";
                final isButtonDisabled = resendTime != 0 && otpLength != 6;

                return Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: media.width * 0.08, right: media.width * 0.08),
                      color: page,
                      height: media.height * 1,
                      width: media.width * 1,
                      child: Column(
                        children: [
                          Container(
                            height: media.height * 0.12,
                            width: media.width * 1,
                            color: topBar,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.arrow_back),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: media.height * 0.04),
                                SizedBox(
                                  width: media.width * 1,
                                  child: Text(
                                    languages[choosenLanguage]['text_phone_verify'],
                                    style: GoogleFonts.roboto(
                                      fontSize: media.width * twentyeight,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  languages[choosenLanguage]['text_enter_otp'],
                                  style: GoogleFonts.roboto(
                                      fontSize: media.width * sixteen, color: textColor.withValues(alpha: 0.3)),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  countries[phcode]['dial_code'] + phnumber,
                                  style: GoogleFonts.roboto(
                                    fontSize: media.width * sixteen,
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                SizedBox(height: media.height * 0.1),
                                Container(
                                  height: media.width * 0.15,
                                  width: media.width * 0.9,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: page,
                                    border: Border.all(color: borderLines, width: 1.2),
                                  ),
                                  child: TextField(
                                    controller: otpController,
                                    autofocus: (phoneAuthCheck == false) ? false : true,
                                    onChanged: (val) {
                                      setState(() {
                                        _error = '';
                                      });
                                      if (val.length == 6) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      counterText: '',
                                      hintText: languages[choosenLanguage]['text_enter_otp_login'],
                                    ),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      fontSize: media.width * twenty,
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLength: 6,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                if (_error.isNotEmpty)
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: media.height * 0.02),
                                    child: Text(
                                      _error,
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * sixteen, color: Colors.red),
                                    ),
                                  ),
                                SizedBox(height: media.height * 0.05),
                                Container(
                                  alignment: Alignment.center,
                                  child: Button(
                                    onTap: () async {
                                      if (otpLength == 6) {
                                        await _verifyOtp();
                                      } else if (resendTime == 0) {
                                        await _viewModel.requestOtp(phnumber);
                                        _viewModel.startResendTimer();
                                      }
                                    },
                                    text: buttonText,
                                    color: isButtonDisabled ? underline : null,
                                    borcolor: isButtonDisabled ? underline : null,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    if (_viewModel.hasInternet == false)
                      Positioned(
                        top: 0,
                        child: NoInternet(
                          onTap: () {
                            _viewModel.retryFetchCountries();
                          },
                        ),
                      ),
                    if (_viewModel.isLoading == true)
                      Positioned(
                        top: 0,
                        child: SizedBox(
                          height: media.height * 1,
                          width: media.width * 1,
                          child: const Loading(),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

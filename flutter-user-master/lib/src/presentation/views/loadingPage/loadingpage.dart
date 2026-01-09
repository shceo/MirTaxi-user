import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/select_task_screen.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/booking_confirmation.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/invoice.dart';
import 'package:tagyourtaxi_driver/src/presentation/viewmodels/loading_view_model.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/login.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/src/presentation/widgets/widgets.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late final LoadingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LoadingViewModel();
    _viewModel.addListener(_handleNavigation);
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_handleNavigation);
    _viewModel.dispose();
    super.dispose();
  }

  void _handleNavigation() {
    final destination = _viewModel.consumeDestination();
    if (destination == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      switch (destination) {
        case LoadingDestination.invoice:
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => const Invoice()), (route) => false);
          break;
        case LoadingDestination.bookingConfirmationRental:
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => BookingConfirmation(type: 1)), (route) => false);
          break;
        case LoadingDestination.bookingConfirmation:
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => BookingConfirmation()), (route) => false);
          break;
        case LoadingDestination.selectTask:
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => const SelectTaskScreen()), (route) => false);
          break;
        case LoadingDestination.login:
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
          });
          break;
        case LoadingDestination.chooseLanguage:
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Material(
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, _) {
            final showUpdate = _viewModel.updateAvailable;
            final showLoader = _viewModel.isLoading && _viewModel.hasInternet;
            return Stack(
              children: [
                Container(
                  height: media.height * 1,
                  width: media.width * 1,
                  decoration: BoxDecoration(
                    color: page,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(media.width * 0.01),
                        width: media.width * 0.429,
                        height: media.width * 0.429,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //update available
                if (showUpdate)
                  Positioned(
                      top: 0,
                      child: Container(
                        height: media.height * 1,
                        width: media.width * 1,
                        color: Colors.transparent.withOpacity(0.6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                width: media.width * 0.9,
                                padding: EdgeInsets.all(media.width * 0.05),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: page,
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        width: media.width * 0.8,
                                        child: Text(
                                          'New version of this app is available in store, please update the app for continue using',
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * sixteen, fontWeight: FontWeight.w600),
                                        )),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Button(onTap: _viewModel.openStoreListing, text: 'Update')
                                  ],
                                ))
                          ],
                        ),
                      )),

                //loader
                if (showLoader) const Positioned(top: 0, child: Loading()),

                //no internet
                if (_viewModel.hasInternet == false)
                  Positioned(
                      top: 0,
                      child: NoInternet(
                        onTap: () {
                          _viewModel.retry();
                        },
                      )),
              ],
            );
          },
        ),
      ),
    );
  }
}

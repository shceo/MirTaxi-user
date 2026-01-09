import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/core/services/app_state.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';

class SelectTaxiWidget extends StatelessWidget {
  final Map minutes;
  final int? type;
  final Query fdb;
  final List<dynamic> etaDetails;
  final Function(int) select;

  const SelectTaxiWidget({
    super.key,
    required this.minutes,
    required this.type,
    required this.fdb,
    required this.etaDetails,
    required this.select,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: 16),
        // (etaDetails.isNotEmpty && type != 1)
        //     ?
        Expanded(
          child: SizedBox(
            width: media.width * 0.9,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: etaDetails
                          .asMap()
                          .map(
                            (i, value) {
                              return MapEntry(
                                i,
                                StreamBuilder<DatabaseEvent>(
                                  stream: fdb.onValue,
                                  builder: (context, AsyncSnapshot event) {
                                    if (event.data != null &&
                                        etaDetails.isNotEmpty) {
                                      minutes[etaDetails[i]['type_id']] = '';
                                      List vehicleList = [];
                                      List vehicles = [];
                                      List<double> minsList = [];
                                      event.data!.snapshot.children
                                          .forEach((e) {
                                        vehicleList.add(e.value);
                                      });
                                      if (vehicleList.isNotEmpty) {
                                        // ignore: avoid_function_literals_in_foreach_calls
                                        vehicleList.forEach(
                                          (e) async {
                                            if (e['is_active'] == 1 &&
                                                e['is_available'] == true &&
                                                e['vehicle_type'] ==
                                                    etaDetails[i]['type_id']) {
                                              DateTime dt = DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      e['updated_at']);
                                              if (DateTime.now()
                                                      .difference(dt)
                                                      .inMinutes <=
                                                  2) {
                                                vehicles.add(e);
                                                if (vehicles.isNotEmpty) {
                                                  var dist = calculateDistance(
                                                      addressList
                                                          .firstWhere((e) =>
                                                              e.id == 'pickup')
                                                          .latlng
                                                          .latitude,
                                                      addressList
                                                          .firstWhere((e) =>
                                                              e.id == 'pickup')
                                                          .latlng
                                                          .longitude,
                                                      e['l'][0],
                                                      e['l'][1]);

                                                  minsList.add(double.parse(
                                                      (dist / 1000)
                                                          .toString()));
                                                  var minDist =
                                                      minsList.reduce(min);
                                                  if (minDist > 0 &&
                                                      minDist <= 1) {
                                                    minutes[etaDetails[i]
                                                        ['type_id']] = '2 mins';
                                                  } else if (minDist > 1 &&
                                                      minDist <= 3) {
                                                    minutes[etaDetails[i]
                                                        ['type_id']] = '5 mins';
                                                  } else if (minDist > 3 &&
                                                      minDist <= 5) {
                                                    minutes[etaDetails[i]
                                                        ['type_id']] = '8 mins';
                                                  } else if (minDist > 5 &&
                                                      minDist <= 7) {
                                                    minutes[etaDetails[i]
                                                            ['type_id']] =
                                                        '11 mins';
                                                  } else if (minDist > 7 &&
                                                      minDist <= 10) {
                                                    minutes[etaDetails[i]
                                                            ['type_id']] =
                                                        '14 mins';
                                                  } else if (minDist > 10) {
                                                    minutes[etaDetails[i]
                                                            ['type_id']] =
                                                        '15 mins';
                                                  }
                                                } else {
                                                  minutes[etaDetails[i]
                                                      ['type_id']] = '';
                                                }
                                              }
                                            }
                                          },
                                        );
                                      } else {
                                        minutes[etaDetails[i]['type_id']] = '';
                                      }
                                    } else {
                                      minutes[etaDetails[i]['type_id']] = '';
                                    }

                                    return InkWell(
                                      onTap: () => select(i),
                                      child: Container(
                                        // height: 78,
                                        width: 120,
                                        padding:
                                            EdgeInsets.all(media.width * 0.03),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: (choosenVehicle != i)
                                              ? Colors.transparent
                                              : const Color.fromRGBO(
                                                  237, 240, 245, 1),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (etaDetails[i]['icon'] != null)
                                              SizedBox(
                                                height: 32,
                                                child: Image.network(
                                                  etaDetails[i]['icon'],
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            Text(
                                              (minutes[etaDetails[i]
                                                          ['type_id']] !=
                                                      '')
                                                  ? minutes[etaDetails[i]
                                                          ['type_id']]
                                                      .toString()
                                                  : '- -',
                                              style: GoogleFonts.roboto(
                                                fontSize: media.width * twelve,
                                                color: textColor.withValues(
                                                  alpha: 0.3,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              etaDetails[i]['name'],
                                              style: GoogleFonts.roboto(
                                                fontSize: media.width * twelve,
                                                color: textColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            if (etaDetails[i]['has_discount'] !=
                                                true)
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${currencyFormat.format(etaDetails[i]['total'].toInt())} ${etaDetails[i]['currency']}',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: media.width *
                                                            fourteen,
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              )
                                            else
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    etaDetails[i]['currency'] +
                                                        ' ',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: media.width *
                                                            fourteen,
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    etaDetails[i]['total']
                                                        .toStringAsFixed(2),
                                                    style: GoogleFonts.roboto(
                                                      fontSize: media.width *
                                                          fourteen,
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  ),
                                                  Text(
                                                    ' ${etaDetails[i]['discounted_totel'].toStringAsFixed(2)}',
                                                    style: GoogleFonts.roboto(
                                                      fontSize: media.width *
                                                          fourteen,
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          )
                          .values
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // : (etaDetails.isNotEmpty && type == 1)
        //     ? Expanded(
        //         child: SizedBox(
        //           width: media.width * 0.9,
        //           child: Column(
        //             children: [
        //               SizedBox(
        //                 height: media.width * 0.025,
        //               ),
        //               SizedBox(
        //                 width: media.width * 0.9,
        //                 child: SingleChildScrollView(
        //                   scrollDirection: Axis.horizontal,
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.start,
        //                     children: etaDetails
        //                         .asMap()
        //                         .map(
        //                           (i, value) {
        //                             return MapEntry(
        //                               i,
        //                               Container(
        //                                 margin: EdgeInsets.only(
        //                                     right: media.width * 0.05),
        //                                 decoration: BoxDecoration(
        //                                     borderRadius:
        //                                         BorderRadius.circular(8),
        //                                     color:
        //                                         (rentalChoosenOption == i)
        //                                             ? buttonColor
        //                                             : borderLines),
        //                                 padding: EdgeInsets.all(
        //                                     media.width * 0.02),
        //                                 child: InkWell(
        //                                   onTap: () {
        //                                     //2
        //                                     // setState(() {
        //                                     //   rentalOption = etaDetails[i]
        //                                     //           ['typesWithPrice']
        //                                     //       ['data'];
        //                                     //   rentalChoosenOption = i;
        //                                     //   choosenVehicle = null;
        //                                     //   payingVia = 0;
        //                                     // });
        //                                   },
        //                                   child: Text(
        //                                     etaDetails[i]['package_name'],
        //                                     style: GoogleFonts.roboto(
        //                                       fontSize:
        //                                           media.width * sixteen,
        //                                       fontWeight: FontWeight.w600,
        //                                       color:
        //                                           (rentalChoosenOption == i)
        //                                               ? Colors.white
        //                                               : Colors.black,
        //                                     ),
        //                                   ),
        //                                 ),
        //                               ),
        //                             );
        //                           },
        //                         )
        //                         .values
        //                         .toList(),
        //                   ),
        //                 ),
        //               ),
        //               SizedBox(height: media.width * 0.05),
        //               Expanded(
        //                 child: SizedBox(
        //                   width: media.width * 0.9,
        //                   child: SingleChildScrollView(
        //                     physics: const BouncingScrollPhysics(),
        //                     child: Column(
        //                         children: rentalOption
        //                             .asMap()
        //                             .map(
        //                               (i, value) {
        //                                 return MapEntry(
        //                                   i,
        //                                   StreamBuilder<DatabaseEvent>(
        //                                     stream: fdb.onValue,
        //                                     builder: (context,
        //                                         AsyncSnapshot event) {
        //                                       if (event.data != null &&
        //                                           etaDetails.isNotEmpty) {
        //                                         minutes[rentalOption[i]
        //                                             ['type_id']] = '';
        //                                         List vehicleList = [];
        //                                         List vehicles = [];
        //                                         List<double> minsList = [];
        //                                         event
        //                                             .data!.snapshot.children
        //                                             .forEach((e) {
        //                                           vehicleList.add(e.value);
        //                                         });
        //                                         if (vehicleList
        //                                             .isNotEmpty) {
        //                                           // ignore: avoid_function_literals_in_foreach_calls
        //                                           vehicleList.forEach(
        //                                             (e) async {
        //                                               if (e['is_active'] ==
        //                                                       1 &&
        //                                                   e['is_available'] ==
        //                                                       true &&
        //                                                   e['vehicle_type'] ==
        //                                                       rentalOption[
        //                                                               i][
        //                                                           'type_id']) {
        //                                                 DateTime dt = DateTime
        //                                                     .fromMillisecondsSinceEpoch(
        //                                                         e['updated_at']);
        //                                                 if (DateTime.now()
        //                                                         .difference(
        //                                                             dt)
        //                                                         .inMinutes <=
        //                                                     2) {
        //                                                   vehicles.add(e);
        //                                                   if (vehicles
        //                                                       .isNotEmpty) {
        //                                                     var dist = calculateDistance(
        //                                                         addressList
        //                                                             .firstWhere((e) =>
        //                                                                 e.id ==
        //                                                                 'pickup')
        //                                                             .latlng
        //                                                             .latitude,
        //                                                         addressList
        //                                                             .firstWhere((e) =>
        //                                                                 e.id ==
        //                                                                 'pickup')
        //                                                             .latlng
        //                                                             .longitude,
        //                                                         e['l'][0],
        //                                                         e['l'][1]);
        //
        //                                                     minsList.add(double
        //                                                         .parse((dist /
        //                                                                 1000)
        //                                                             .toString()));
        //                                                     var minDist =
        //                                                         minsList
        //                                                             .reduce(
        //                                                                 min);
        //                                                     if (minDist >
        //                                                             0 &&
        //                                                         minDist <=
        //                                                             1) {
        //                                                       minutes[rentalOption[
        //                                                                   i]
        //                                                               [
        //                                                               'type_id']] =
        //                                                           '2 mins';
        //                                                     } else if (minDist >
        //                                                             1 &&
        //                                                         minDist <=
        //                                                             3) {
        //                                                       minutes[rentalOption[
        //                                                                   i]
        //                                                               [
        //                                                               'type_id']] =
        //                                                           '5 mins';
        //                                                     } else if (minDist >
        //                                                             3 &&
        //                                                         minDist <=
        //                                                             5) {
        //                                                       minutes[rentalOption[
        //                                                                   i]
        //                                                               [
        //                                                               'type_id']] =
        //                                                           '8 mins';
        //                                                     } else if (minDist >
        //                                                             5 &&
        //                                                         minDist <=
        //                                                             7) {
        //                                                       minutes[rentalOption[
        //                                                                   i]
        //                                                               [
        //                                                               'type_id']] =
        //                                                           '11 mins';
        //                                                     } else if (minDist >
        //                                                             7 &&
        //                                                         minDist <=
        //                                                             10) {
        //                                                       minutes[rentalOption[
        //                                                                   i]
        //                                                               [
        //                                                               'type_id']] =
        //                                                           '14 mins';
        //                                                     } else if (minDist >
        //                                                         10) {
        //                                                       minutes[rentalOption[
        //                                                                   i]
        //                                                               [
        //                                                               'type_id']] =
        //                                                           '15 mins';
        //                                                     }
        //                                                   } else {
        //                                                     minutes[rentalOption[
        //                                                             i][
        //                                                         'type_id']] = '';
        //                                                   }
        //                                                 }
        //                                               }
        //                                             },
        //                                           );
        //                                         } else {
        //                                           minutes[rentalOption[i]
        //                                               ['type_id']] = '';
        //                                         }
        //                                       } else {
        //                                         minutes[rentalOption[i]
        //                                             ['type_id']] = '';
        //                                       }
        //                                       return InkWell(
        //                                         onTap: () {
        //                                           //3
        //                                           // setState(() {
        //                                           //   choosenVehicle = i;
        //                                           // });
        //                                         },
        //                                         child: Container(
        //                                           padding: EdgeInsets.all(
        //                                               media.width * 0.03),
        //                                           decoration: BoxDecoration(
        //                                             borderRadius:
        //                                                 BorderRadius
        //                                                     .circular(12),
        //                                             color:
        //                                                 (choosenVehicle !=
        //                                                         i)
        //                                                     ? Colors
        //                                                         .transparent
        //                                                     : Colors
        //                                                         .grey[200],
        //                                           ),
        //                                           child: Row(
        //                                             children: [
        //                                               Column(
        //                                                 children: [
        //                                                   (rentalOption[i][
        //                                                               'icon'] !=
        //                                                           null)
        //                                                       ? SizedBox(
        //                                                           width: media
        //                                                                   .width *
        //                                                               0.1,
        //                                                           child: Image
        //                                                               .network(
        //                                                             rentalOption[i]
        //                                                                 [
        //                                                                 'icon'],
        //                                                             fit: BoxFit
        //                                                                 .contain,
        //                                                           ))
        //                                                       : Container(),
        //                                                   (minutes[rentalOption[
        //                                                                   i]
        //                                                               [
        //                                                               'type_id']] !=
        //                                                           "")
        //                                                       ? Text(
        //                                                           minutes[rentalOption[i]
        //                                                                   [
        //                                                                   'type_id']]
        //                                                               .toString(),
        //                                                           style: GoogleFonts.roboto(
        //                                                               fontSize: media.width *
        //                                                                   twelve,
        //                                                               color:
        //                                                                   textColor.withValues(alpha: 0.3)),
        //                                                         )
        //                                                       : Text(
        //                                                           '- -',
        //                                                           style: GoogleFonts.roboto(
        //                                                               fontSize: media.width *
        //                                                                   twelve,
        //                                                               color:
        //                                                                   textColor.withValues(alpha: 0.3)),
        //                                                         )
        //                                                 ],
        //                                               ),
        //                                               SizedBox(
        //                                                 width: media.width *
        //                                                     0.05,
        //                                               ),
        //                                               Column(
        //                                                 crossAxisAlignment:
        //                                                     CrossAxisAlignment
        //                                                         .start,
        //                                                 children: [
        //                                                   Text(
        //                                                       rentalOption[
        //                                                               i]
        //                                                           ['name'],
        //                                                       style: GoogleFonts.roboto(
        //                                                           fontSize:
        //                                                               media.width *
        //                                                                   fourteen,
        //                                                           color:
        //                                                               textColor,
        //                                                           fontWeight:
        //                                                               FontWeight
        //                                                                   .w600)),
        //                                                   Row(
        //                                                     children: [
        //                                                       SizedBox(
        //                                                         width: media
        //                                                                 .width *
        //                                                             0.3,
        //                                                         child: Text(
        //                                                           rentalOption[
        //                                                                   i]
        //                                                               [
        //                                                               'short_description'],
        //                                                           style: GoogleFonts
        //                                                               .roboto(
        //                                                             fontSize:
        //                                                                 media.width *
        //                                                                     twelve,
        //                                                             color:
        //                                                                 textColor,
        //                                                           ),
        //                                                           maxLines:
        //                                                               1,
        //                                                         ),
        //                                                       ),
        //                                                       SizedBox(
        //                                                           width: media
        //                                                                   .width *
        //                                                               0.01),
        //                                                       InkWell(
        //                                                           onTap:
        //                                                               () {
        //                                                             //4
        //                                                             // setState(
        //                                                             //     () {
        //                                                             //   _showInfoInt =
        //                                                             //       i;
        //                                                             //   _showInfo =
        //                                                             //       true;
        //                                                             // });
        //                                                           },
        //                                                           child: Icon(
        //                                                               Icons
        //                                                                   .info_outline,
        //                                                               size: media.width *
        //                                                                   twelve)),
        //                                                     ],
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                               Expanded(
        //                                                 child: (rentalOption[
        //                                                                 i][
        //                                                             'has_discount'] !=
        //                                                         true)
        //                                                     ? Row(
        //                                                         mainAxisAlignment:
        //                                                             MainAxisAlignment
        //                                                                 .end,
        //                                                         children: [
        //                                                           Text(
        //                                                             rentalOption[i]['currency'] +
        //                                                                 " " +
        //                                                                 rentalOption[i]['fare_amount'].toStringAsFixed(2),
        //                                                             style: GoogleFonts.roboto(
        //                                                                 fontSize: media.width *
        //                                                                     fourteen,
        //                                                                 color:
        //                                                                     textColor,
        //                                                                 fontWeight:
        //                                                                     FontWeight.w600),
        //                                                           ),
        //                                                         ],
        //                                                       )
        //                                                     : Row(
        //                                                         mainAxisAlignment:
        //                                                             MainAxisAlignment
        //                                                                 .end,
        //                                                         children: [
        //                                                           Text(
        //                                                             rentalOption[i]['currency'] +
        //                                                                 ' ',
        //                                                             style: GoogleFonts.roboto(
        //                                                                 fontSize: media.width *
        //                                                                     fourteen,
        //                                                                 color:
        //                                                                     textColor,
        //                                                                 fontWeight:
        //                                                                     FontWeight.w600),
        //                                                           ),
        //                                                           Text(
        //                                                             rentalOption[i]['fare_amount']
        //                                                                 .toStringAsFixed(2),
        //                                                             style: GoogleFonts.roboto(
        //                                                                 fontSize: media.width *
        //                                                                     fourteen,
        //                                                                 color:
        //                                                                     textColor,
        //                                                                 fontWeight:
        //                                                                     FontWeight.w600,
        //                                                                 decoration: TextDecoration.lineThrough),
        //                                                           ),
        //                                                           Text(
        //                                                             ' ${rentalOption[i]['discounted_totel'].toStringAsFixed(2)}',
        //                                                             style: GoogleFonts.roboto(
        //                                                                 fontSize: media.width *
        //                                                                     fourteen,
        //                                                                 color:
        //                                                                     textColor,
        //                                                                 fontWeight:
        //                                                                     FontWeight.w600),
        //                                                           ),
        //                                                         ],
        //                                                       ),
        //                                               ),
        //                                             ],
        //                                           ),
        //                                         ),
        //                                       );
        //                                     },
        //                                   ),
        //                                 );
        //                               },
        //                             )
        //                             .values
        //                             .toList()),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       )
        //     : Container(),
        SizedBox(height: media.width * 0.05),
      ],
    );
  }
}

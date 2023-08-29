import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinly/constants.dart';
import 'package:pinly/widgets/gradient_card.dart';

class ProfileBottomSheet extends StatefulWidget {
  const ProfileBottomSheet({super.key});

  @override
  State<ProfileBottomSheet> createState() => ProfileBottomSheetState();
}

class ProfileBottomSheetState extends State<ProfileBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GradientCard(
                          startColor: Color(0xFFCEE5D0),
                          endColor: Color(0xFFCEE5D0).withOpacity(0.7),
                          child: Stack(clipBehavior: Clip.none, children: [
                            Positioned(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Profile",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20),
                                      ),
                                      Icon(Iconsax.arrow_right_3)
                                    ],
                                  ),
                                  const Text(
                                    "━━━━━",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Iconsax.user, size: 16),
                                      Text(" tuudug")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: -12,
                                right: -15,
                                child: Transform.rotate(
                                    angle: 180 * 3.14 / 92,
                                    child: Icon(
                                      Iconsax.user_octagon,
                                      size: 80,
                                      color: Colors.black.withOpacity(0.15),
                                    ))),
                          ])),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: GradientCard(
                          startColor: Color(0xFFF5EBD3),
                          endColor: Color(0xFFF5EBD3).withOpacity(0.7),
                          child: Stack(clipBehavior: Clip.none, children: [
                            Positioned(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Wallet",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20),
                                      ),
                                      Icon(Iconsax.arrow_right_3)
                                    ],
                                  ),
                                  const Text(
                                    "━━━━━",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Iconsax.wallet_1, size: 16),
                                      Text(" 100 points")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: -12,
                                right: -15,
                                child: Transform.rotate(
                                    angle: 180 * 3.14 / 92,
                                    child: Icon(
                                      Iconsax.wallet_3,
                                      size: 80,
                                      color: Colors.black.withOpacity(0.15),
                                    ))),
                          ])),
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: GradientCard(
                    startColor: Color(0xFF6F6283),
                    endColor: Color(0xFF6F6283).withOpacity(0.9),
                    child: Stack(clipBehavior: Clip.none, children: [
                      Positioned(
                          bottom: -10,
                          right: -10,
                          child: Transform.rotate(
                              angle: 180 * 3.14 / 92,
                              child: Icon(
                                Iconsax.star,
                                size: 45,
                                color: Colors.white.withOpacity(0.75),
                              ))),
                      Positioned(
                          bottom: -10,
                          left: -10,
                          child: Transform.rotate(
                              angle: 180 * 3.14 / 92,
                              child: Icon(
                                Iconsax.like_tag,
                                size: 45,
                                color: Colors.white.withOpacity(0.75),
                              ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Pinly+",
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          Icon(
                            Iconsax.arrow_right_3,
                            color: Colors.white,
                          ),
                          Text(
                            " Member since 2023-08-29",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ]),
                  ))),
          Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GradientCard(
                          startColor: Color(0xFFFBD4B5),
                          endColor: Color(0xFFFBD4B5).withOpacity(0.7),
                          child: Stack(clipBehavior: Clip.none, children: [
                            Positioned(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Location Privacy",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20),
                                      ),
                                      Icon(Iconsax.arrow_right_3)
                                    ],
                                  ),
                                  const Text(
                                    "━━━━━",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Iconsax.location_slash, size: 16),
                                      Text(" Frozen")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: -12,
                                right: -15,
                                child: Transform.rotate(
                                    angle: 180 * 3.14 / 92,
                                    child: Icon(
                                      Iconsax.location_tick,
                                      size: 80,
                                      color: Colors.black.withOpacity(0.15),
                                    ))),
                          ])),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: GradientCard(
                          startColor: Color(0xFFF4B6B2),
                          endColor: Color(0xFFF4B6B2).withOpacity(0.7),
                          child: Stack(clipBehavior: Clip.none, children: [
                            Positioned(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Settings",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 20),
                                      ),
                                      Icon(Iconsax.arrow_right_3)
                                    ],
                                  ),
                                  const Text(
                                    "━━━━━",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: -12,
                                right: -15,
                                child: Transform.rotate(
                                    angle: 180 * 3.14 / 92,
                                    child: Icon(
                                      Iconsax.setting_3,
                                      size: 80,
                                      color: Colors.black.withOpacity(0.15),
                                    ))),
                          ])),
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Iconsax.logout,
                          size: 14,
                        ),
                        label: Text(
                          "Logout",
                          style: TextStyle(fontSize: 12),
                        ))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

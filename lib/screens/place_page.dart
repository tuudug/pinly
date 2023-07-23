import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pinly/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart' as spi;

import '../widgets/place_features.dart';

class PlacePage extends StatefulWidget {
  const PlacePage({super.key});

  @override
  State<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> with TickerProviderStateMixin {
  final List<String> imageUrls = [
    "https://picsum.photos/800/300",
    "https://picsum.photos/800/301",
    "https://picsum.photos/800/302",
    "https://picsum.photos/800/303",
    "https://picsum.photos/800/304",
  ];

  @override
  Widget build(BuildContext context) {
    PageController cardController = PageController();
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      appBar: AppBar(
        title: Text("Place"),
        actions: [
          TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.favorite_outline),
              label: Text("0"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: Stack(alignment: Alignment.center, children: [
                  PageView.builder(
                    controller: cardController,
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        imageUrls[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    child: spi.SmoothPageIndicator(
                      controller: cardController, // PageController
                      count: 5,
                      effect: spi.SwapEffect(
                          activeDotColor: pinlyPurple,
                          dotColor: Colors.white), // your preferred effect
                    ),
                  )
                ]),
              ),
            ),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Radio Dept",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                          TextButton.icon(
                                  onPressed: () {
                                    CherryToast.info(
                                      displayCloseButton: false,
                                      animationType: AnimationType.fromTop,
                                      toastDuration: Duration(seconds: 5),
                                      animationDuration:
                                          Duration(milliseconds: 200),
                                      title: Text(
                                          "There are 0 pinly users at this place right now"),
                                    ).show(context);
                                  },
                                  icon: Icon(Icons.groups),
                                  label: Text("0"))
                              .animate(
                                  onPlay: (controller) => controller
                                      .repeat()) // runs after the above w/new duration
                              .shimmer(
                                  color: Colors.red,
                                  delay: Duration(milliseconds: 500),
                                  duration: Duration(milliseconds: 3500))
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text("We invite you in a comfortable environment."),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_outlined,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "7 AM - 6 PM, Monday - Sunday",
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "99887766",
                          ),
                        ],
                      ),
                      Divider(),
                      TabBar(
                        controller: tabController,
                        labelColor: Colors.black,
                        tabs: [
                          Tab(icon: Icon(Icons.star_outline), text: "Features"),
                          Tab(
                              icon: Icon(Icons.reviews_outlined),
                              text: "Reviews"),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(controller: tabController, children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: PlaceFeatures(),
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons
                                      .star_border, // Replace this with your desired icon
                                  size: 72.0,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16.0),
                                Text(
                                  'No reviews yet',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pinly/constants.dart';
import 'package:pinly/firestore/places.dart';
import 'package:pinly/widgets/place_like.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart' as spi;

import '../widgets/no_entries.dart';
import '../widgets/place_features.dart';

class PlacePage extends StatefulWidget {
  final String id;

  const PlacePage(this.id, {super.key});

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

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.white),
          iconTheme: IconThemeData(
            size: 30,
            color: Colors.white,
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withOpacity(0.8),
                  Colors.transparent
                ],
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            PlaceLikeButton(widget.id, 0),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: FutureBuilder(
                future: PlacesDb.getAllPictures(widget.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(65),
                      bottomRight: Radius.circular(65),
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      PageView.builder(
                        controller: cardController,
                        itemCount:
                            snapshot.data!.isEmpty ? 1 : snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: snapshot.data!.isEmpty
                                ? notFoundImage
                                : snapshot.data![index],
                            placeholder: (context, url) => Center(
                                child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator())),
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      Positioned(
                        bottom: 10,
                        child: spi.SmoothPageIndicator(
                          controller: cardController, // PageController
                          count: snapshot.data!.isEmpty
                              ? 1
                              : snapshot.data!.length,
                          effect: spi.SwapEffect(
                              activeDotColor: pinlyPurple,
                              dotColor: Colors.white), // your preferred effect
                        ),
                      )
                    ]),
                  );
                },
              ),
            ),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: FutureBuilder(
                      future: PlacesDb.getOne(widget.id),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.data?.name ?? "",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800),
                                ),
                                TextButton.icon(
                                        onPressed: () {
                                          CherryToast.info(
                                            displayCloseButton: false,
                                            animationType:
                                                AnimationType.fromTop,
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
                                Flexible(
                                    child: Text(snapshot.data?.slogan ?? "")),
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
                                Flexible(
                                  child: Text(
                                    snapshot.data?.schedule ?? "",
                                  ),
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
                                  snapshot.data?.phone ?? "",
                                ),
                              ],
                            ),
                            Divider(),
                            TabBar(
                              controller: tabController,
                              labelColor: Colors.black,
                              tabs: [
                                Tab(
                                    icon: Icon(Icons.star_outline),
                                    text: "Features"),
                                Tab(
                                    icon: Icon(Icons.reviews_outlined),
                                    text: "Reviews"),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: PlaceFeatures(),
                                    ),
                                    NoEntries(
                                      text: "No reviews yet",
                                      icon: Icons.star_border,
                                    )
                                  ]),
                            )
                          ],
                        );
                      }),
                )),
          ],
        ),
      ),
    );
  }
}

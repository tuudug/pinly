import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pinly/constants.dart';
import 'package:pinly/firestore/places.dart';
import 'package:pinly/screens/place_page.dart';

class PlaceBottomSheet extends StatefulWidget {
  String id;
  String name;
  String slogan = "...";
  String schedule = "...";
  PlaceBottomSheet(
      {required this.id,
      required this.name,
      this.slogan = "...",
      this.schedule = "...",
      super.key});

  @override
  State<PlaceBottomSheet> createState() => _PlaceBottomSheetState();
}

class _PlaceBottomSheetState extends State<PlaceBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: FutureBuilder(
                          future: PlacesDb.getFirstPicture(widget.id),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            } else if (snapshot.data == "none") {
                              return Image.network(
                                notFoundImage,
                                fit: BoxFit.cover,
                              );
                            }
                            return Expanded(
                              child: Image.network(
                                snapshot.data!,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;

                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: (loadingProgress != null)
                                          ? (loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                                  .toInt())
                                          : 0,
                                    ),
                                  );
                                },
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w800),
                            ),
                            TextButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.favorite_outline),
                                label: Text("0"))
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
                            Expanded(
                              child: Text(
                                widget.slogan,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                widget.schedule,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlacePage(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.keyboard_double_arrow_up,
                                size: 20,
                              ),
                              label: Text(
                                "More",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              )),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

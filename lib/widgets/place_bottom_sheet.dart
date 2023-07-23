import 'package:flutter/material.dart';
import 'package:pinly/screens/place_page.dart';

class PlaceBottomSheet extends StatefulWidget {
  const PlaceBottomSheet({super.key});

  @override
  State<PlaceBottomSheet> createState() => _PlaceBottomSheetState();
}

class _PlaceBottomSheetState extends State<PlaceBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      'https://picsum.photos/800/300',
                      fit: BoxFit.cover,
                    ),
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
                            "Radio Dept",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                          TextButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.favorite_outlined),
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
                          Text("We invite you in a comfortable environment."),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlacePage(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.keyboard_double_arrow_right,
                                size: 20,
                              ),
                              label: Text(
                                "More",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800),
                              ))
                        ],
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

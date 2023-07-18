import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinly/colors.dart';
import 'package:pinly/providers/selected_place_type_provider.dart';

class MainMapToolbar extends ConsumerStatefulWidget {
  const MainMapToolbar({
    Key? key,
  }) : super(key: key);

  @override
  MainMapToolbarState createState() => MainMapToolbarState();
}

class MainMapToolbarState extends ConsumerState<MainMapToolbar> {
  bool morePlacesToggled = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        morePlacesToggled
                            ? morePlacesToggled = false
                            : morePlacesToggled = true;
                      });
                    },
                    icon: Icon(Icons.menu_open),
                    style: IconButton.styleFrom(
                      backgroundColor:
                          morePlacesToggled ? pinlyPurple : Colors.white,
                      side: BorderSide(width: 1, color: pinlyPurple),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17.0),
                      border: Border.all(
                        color: pinlyPurple,
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 8.0),
                        Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Find a Place',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton.outlined(
                    onPressed: () {},
                    icon: Icon(Icons.notifications_outlined),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(width: 1, color: pinlyPurple),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton.outlined(
                    onPressed: () {},
                    icon: Icon(Icons.calendar_month_outlined),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(width: 1, color: pinlyPurple),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(17),
                        ),
                      ),
                    ),
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          AnimatedOpacity(
            opacity: morePlacesToggled ? 1.0 : 0.0,
            duration: Duration(milliseconds: 250),
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                    flex: 1,
                    child: PlaceTypeButton(
                      icon: Icons.restaurant,
                      text: "Restaurant",
                      id: 1,
                    )),
                Expanded(
                    flex: 1,
                    child: PlaceTypeButton(
                        icon: Icons.weekend, text: "Pub & Lounge", id: 2)),
                Expanded(
                    flex: 1,
                    child: PlaceTypeButton(
                      icon: Icons.coffee,
                      text: "Coffee Shop",
                      id: 3,
                    )),
                Expanded(
                    flex: 1,
                    child: PlaceTypeButton(
                      icon: Icons.gamepad,
                      text: "Play",
                      id: 4,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceTypeButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final int id;

  const PlaceTypeButton(
      {super.key, required this.icon, required this.text, required this.id});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton.icon(
          onPressed: () {},
          icon: Icon(
            icon,
            color: Colors.black,
            size: 12,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            side: BorderSide(width: 1, color: pinlyPurple),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(17),
              ),
            ),
          ),
          label: Text(
            text,
            style: TextStyle(
                color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800),
          )),
    );
  }
}

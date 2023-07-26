import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinly/constants.dart';
import 'package:pinly/providers/selected_place_type_provider.dart';

List<PlaceType> placeTypes = [
  PlaceType(Icons.restaurant_outlined, "Restaurant", 0),
  PlaceType(Icons.coffee_maker_outlined, "Coffee Shop", 1),
  PlaceType(Icons.gamepad_outlined, "Entertainment", 2),
  PlaceType(Icons.party_mode_outlined, "Party", 3),
  PlaceType(Icons.museum_outlined, "Museum", 4),
  PlaceType(Icons.sports_outlined, "Gym & Sports", 5),
  PlaceType(Icons.book_outlined, "Library & Book Shop", 6),
];

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
    int selectedPlaceType = ref.watch(selectedPlaceTypeProvider);

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
                    icon: AnimatedRotation(
                        turns: morePlacesToggled ? 0.75 : 0,
                        duration: Duration(milliseconds: 150),
                        child: Icon(Icons.menu_open)),
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
                        color: selectedPlaceType == -1
                            ? Colors.white
                            : Colors.deepPurple.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(17.0),
                        border: Border.all(
                          color: pinlyPurple,
                          width: 1.0,
                        ),
                      ),
                      child: GestureDetector(
                          onTap: () {
                            if (morePlacesToggled == false) {
                              setState(() {
                                morePlacesToggled = true;
                              });
                            }
                          },
                          child: buildSearchBar(selectedPlaceType))),
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
          SizedBox(
            height: 40,
            child: AnimatedOpacity(
              opacity: morePlacesToggled ? 1.0 : 0.0,
              duration: Duration(milliseconds: 250),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                    placeTypes.length,
                    (index) => PlaceTypeButton(
                        icon: placeTypes[index].icon,
                        text: placeTypes[index].name,
                        id: placeTypes[index].id)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceTypeButton extends ConsumerWidget {
  final IconData icon;
  final String text;
  final int id;

  const PlaceTypeButton(
      {super.key, required this.icon, required this.text, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton.icon(
          onPressed: () {
            ref.read(selectedPlaceTypeProvider.notifier).state = id;
          },
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

class PlaceTypeSelectedIndicator extends ConsumerWidget {
  final IconData icon;
  final String text;
  final int id;

  const PlaceTypeSelectedIndicator(
      {super.key, required this.icon, required this.text, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: 8.0),
            Icon(
              icon,
              color: id == -1 ? Colors.black : Colors.white,
            ),
            SizedBox(width: 8.0),
            Text(
              text,
              style: TextStyle(color: id == -1 ? Colors.black : Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                ref.read(selectedPlaceTypeProvider.notifier).state = -1;
              },
              child: Icon(
                Icons.close,
                color: id == -1 ? Colors.white.withOpacity(0) : Colors.white,
              ),
            ),
            SizedBox(width: 8.0),
          ],
        ),
      ],
    );
  }
}

Widget buildSearchBar(int placeType) {
  if (placeType == -1) {
    return PlaceTypeSelectedIndicator(
        icon: Icons.place_outlined, text: "Select a place", id: -1);
  }
  return PlaceTypeSelectedIndicator(
      icon: placeTypes[placeType].icon,
      text: placeTypes[placeType].name,
      id: placeTypes[placeType].id);
}

class PlaceType {
  IconData icon;
  String name;
  int id;

  PlaceType(this.icon, this.name, this.id);
}

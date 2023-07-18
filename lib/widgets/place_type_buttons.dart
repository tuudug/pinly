import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinly/providers/selected_place_type_provider.dart';

class PlaceTypeButtons extends ConsumerStatefulWidget {
  const PlaceTypeButtons({
    Key? key,
  }) : super(key: key);

  @override
  PlaceTypeButtonsState createState() => PlaceTypeButtonsState();
}

class PlaceTypeButtonsState extends ConsumerState<PlaceTypeButtons> {
  int selection = -1;
  double textSize = 12.5;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: 48,
        width: MediaQuery.of(context).size.width * 0.95,
        child: SegmentedButton<int>(
          emptySelectionAllowed: true,
          segments: <ButtonSegment<int>>[
            ButtonSegment<int>(
                value: 0,
                label: Text(
                  "Restaurant",
                  style: TextStyle(fontSize: textSize),
                ),
                icon: Icon(Icons.restaurant)),
            ButtonSegment<int>(
                value: 1,
                label: Text(
                  "Pub & Lounge",
                  style: TextStyle(fontSize: textSize),
                ),
                icon: Icon(Icons.book_rounded)),
            ButtonSegment<int>(
              value: 2,
              label: Text(
                "Coffee Shop",
                style: TextStyle(fontSize: textSize),
              ),
              icon: Icon(Icons.celebration),
            ),
            ButtonSegment<int>(
              value: 3,
              label: Text(
                "Book Store",
                style: TextStyle(fontSize: textSize),
              ),
              icon: Icon(Icons.sports_esports),
            ),
            ButtonSegment<int>(
              value: 4,
              label: Text(
                "Creative",
                style: TextStyle(fontSize: textSize),
              ),
              icon: Icon(Icons.sports_esports),
            ),
          ],
          selected: <int>{selection},
          onSelectionChanged: (Set<int> newSelection) {
            setState(() {
              if (newSelection.isEmpty) {
                selection = -1;
                ref.read(selectedPlaceTypeProvider.notifier).state = -1;
              } else {
                selection = newSelection.first;
                ref.read(selectedPlaceTypeProvider.notifier).state =
                    newSelection.first;
              }
            });
          },
        ),
      ),
    );
  }
}

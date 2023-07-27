import 'package:flutter/material.dart';
import 'package:pinly/firestore/places.dart';
import 'package:pinly/firestore/user.dart';

class PlaceLikeButton extends StatefulWidget {
  final String placeId;
  final int likeCount;
  PlaceLikeButton(this.placeId, this.likeCount, {super.key});

  @override
  State<PlaceLikeButton> createState() => PlaceLikeButtonState();
}

class PlaceLikeButtonState extends State<PlaceLikeButton> {
  bool isLiked = false;

  void checkIfLiked() async {
    final List<String> likedPlaces = await UserDb.getMyLikedPlaces();
    if (likedPlaces.contains(widget.placeId)) {
      setState(() {
        isLiked = true;
      });
    }
  }

  @override
  void initState() {
    checkIfLiked();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (isLiked) {
          PlacesDb.updateLikeCount(widget.placeId, -1);
        } else {
          PlacesDb.updateLikeCount(widget.placeId, 1);
        }
        UserDb.likeOrUnlikePlace(widget.placeId);
        setState(() {
          isLiked = !isLiked;
        });
      },
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_outline,
        color: Colors.white,
      ),
    );
  }
}

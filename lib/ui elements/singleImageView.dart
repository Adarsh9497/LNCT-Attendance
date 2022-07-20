import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class SingleImageView extends StatefulWidget {
  const SingleImageView({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  State<SingleImageView> createState() => _SingleImageView();
}

class _SingleImageView extends State<SingleImageView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          PhotoView(
            imageProvider: CachedNetworkImageProvider(
              widget.image,
            ),
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(tag: widget.image),
            minScale: PhotoViewComputedScale.contained * 0.9,
            maxScale: PhotoViewComputedScale.contained * 5,
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Material(
              color: Colors.transparent,
              child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 10),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close)))),
        ],
      ),
    );
  }
}

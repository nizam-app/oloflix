// Flutter imports:
import 'package:flutter/material.dart';
import 'package:Oloflix/core/widget/base_widget_tupper_botton.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});
  static final routeName = "/live_screen";

  @override
  Widget build(BuildContext context) {
    return BaseWidgetTupperBotton(child2:
    SingleChildScrollView(
      child: Column(
        children: [
          // Live Stream Section
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Streams',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16.0),
                // Placeholder for live stream content
                // You can replace this with your actual live stream widget
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.live_tv,
                        size: 50.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
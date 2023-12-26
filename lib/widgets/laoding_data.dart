import 'package:etracker/utils/mysize.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingData extends StatelessWidget {
  const LoadingData({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: LinearGradient(
        colors: [
          Colors.grey[200]!,
          Colors.grey[400]!,
          Colors.grey[200]!,
        ],
      ),
      child: ListView.builder(
        itemCount: 5, // Adjust the number of items as needed
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                width: MySize.scaleFactorWidth * 400,
                height: MySize.size60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(MySize.size8),
                ),
              ),
              SizedBox(height: MySize.size10),
            ],
          );
        },
      ),
    );
  }
}

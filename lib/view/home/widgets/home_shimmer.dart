import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'shimmer_widget.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          24.verticalSpace,
          ShimmerWidget.rectangular(height: 200.h),

          24.verticalSpace,
          ShimmerWidget.rectangular(
            width: 170.w,
            height: 24.h,
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ShimmerWidget.rectangular(width: 50.w, height: 100.h),
              8.horizontalSpace,
              ShimmerWidget.rectangular(width: 50.w, height: 100.h),
              8.horizontalSpace,
              ShimmerWidget.rectangular(width: 50.w, height: 100.h),
            ],
          ),
          16.verticalSpace,
          ShimmerWidget.rectangular(height: 144.h),
          16.verticalSpace,
          ShimmerWidget.rectangular(height: 144.h),
          16.verticalSpace,
          ShimmerWidget.rectangular(height: 144.h),
        ],
      ),
    );
  }
}
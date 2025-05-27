import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arta_krama/core/constant/colors_theme.dart';
import 'package:arta_krama/core/constant/font_themes.dart';
import 'package:flutter/material.dart';
import 'package:arta_krama/core/utils/layout_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class FadeInOutIcon extends StatefulWidget {
  bool? withMessage;
  String? message;

  FadeInOutIcon({super.key, required this.withMessage, required this.message});

  @override
  State<FadeInOutIcon> createState() => FadeInOutIconState();
}

class FadeInOutIconState extends State<FadeInOutIcon> with SingleTickerProviderStateMixin {
  AnimationController? animCtrl;
  Animation<double>? animation;
  Duration duration(count) => Duration(milliseconds: count);

  @override
  void initState() {
    super.initState();
    animCtrl = AnimationController(vsync: this, duration: duration(1000));

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animCtrl!)..addListener(() => setState(() {}));
    animCtrl!.repeat(reverse: true);
  }

  @override
  void dispose() {
    animCtrl!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    childItemContent() => AnimatedOpacity(
      curve: Curves.easeInOut,
      opacity: animation!.value,
      duration: duration(100),
      child: SvgPicture.asset(
        "assets/icon/koffie-pos-logo.svg",
        width: widget.withMessage! 
          ? 70.w 
          : 140.w,
        height: widget.withMessage! 
          ? 70.w 
          : 140.w,
        semanticsLabel: 'koffielogo'
      ),
    );

    itemContentWithMessage() => Column(
      children: [
        childItemContent(),
        SizedBox(height: 20.h),
        Text(
          widget.message!,
          style: FontThemes.fontSize11w500W(color: ColorsTheme.grey80),
          textAlign: TextAlign.center
        ),
      ]
    );

    return Card(
      shape: LayoutExtension.boxShape!,
      color: ColorsTheme.white,
      child: Wrap(
        children: [
          Center(
            child: Padding(
              padding: LayoutExtension.symmetricPadding(10, 15),
              child: widget.withMessage!
                ? itemContentWithMessage()
                : childItemContent()
            )
          )
        ]
      )
    );
  }
}

class ProgressLoadingController extends GetxController {
  var isLoading = false.obs;
  var message = ''.obs;

  void showLoading(String? msg) {
    isLoading.value = true;
    message.value = msg ?? '';
  }

  void hideLoading() {
    isLoading.value = false;
  }
}

// Create ProgressLoadingWidget using GetX
class ProgressLoadingWidget extends StatelessWidget {
  final ProgressLoadingController controller = Get.put(ProgressLoadingController());

  ProgressLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Stack(
          children: [
            // Overlay abu-abu di belakang konten
            Positioned.fill(
              child: Container(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.5), // Warna abu-abu transparan
              ),
            ),
            // Konten loading di depan
            Center(
              child: Padding(
                padding: LayoutExtension.symmetricPadding(80, 260),
                child: FadeInOutIcon(
                  withMessage: true,
                  message: controller.message.value,
                ),
              ),
            ),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }
}

// Usage example:
void showProgressLoading(String? message) {
  final controller = Get.find<ProgressLoadingController>();
  controller.showLoading(message);
}

void hideProgressLoading() {
  final controller = Get.find<ProgressLoadingController>();
  controller.hideLoading();
}

import "dart:math";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:smart_incident/feature/common/constants/app_colors.dart";
import "package:smart_incident/feature/common/constants/image_constants.dart";
import "package:smart_incident/feature/common/constants/style_constants.dart";

class AnimatedEmptyState extends StatefulWidget {
  final String? titleMessage;
  final String? subTitleMessage;

  const AnimatedEmptyState({
    super.key,
    this.titleMessage,
    this.subTitleMessage,
  });

  @override
  State<AnimatedEmptyState> createState() => _AnimatedEmptyStateState();
}

class _AnimatedEmptyStateState extends State<AnimatedEmptyState>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late AnimationController _controller5;
  late AnimationController _controller6;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;
  late Animation<double> _animation4;
  late Animation<double> _animation5;
  late Animation<double> _animation6;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _controller4 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _controller5 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _controller6 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation1 = CurvedAnimation(
      parent: _controller1,
      curve: Curves.easeInOutCubic,
    );
    _animation2 = CurvedAnimation(
      parent: _controller2,
      curve: Curves.easeInOutCubic,
    );
    _animation3 = CurvedAnimation(
      parent: _controller3,
      curve: Curves.easeInOutCubic,
    );
    _animation4 = CurvedAnimation(parent: _controller4, curve: Curves.ease);
    _animation5 = CurvedAnimation(parent: _controller5, curve: Curves.ease);
    _animation6 = CurvedAnimation(parent: _controller6, curve: Curves.ease);
    _controller1.forward();
    _controller4.forward();
    _controller1.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller1.stop();
        _controller2.forward();
      }
    });
    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller2.stop();
        _controller3.forward();
      }
    });
    _controller3.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller3.stop();
      }
    });
    _controller4.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller4.stop();
        _controller5.forward();
      }
    });
    _controller5.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller5.stop();
        _controller6.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _controller6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double radius = 50.r;
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          FadeTransition(
            opacity: _animation3,
            child: SizedBox(
              width: double.infinity,
              height: 200.r,
              child: Image.asset(ImageConstant.folderIcon),
            ),
          ),
          Positioned(
            bottom: 0,
            top: 60.r,
            left: 0,
            right: 90.r,
            child: FadeTransition(
              opacity: _animation2,
              child: SizedBox(
                // height: 200.r,
                // width: 200.r,
                child: Image.asset(ImageConstant.folderIcon),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            top: 110.r,
            left: 0,
            right: 170.r,
            child: FadeTransition(
              opacity: _animation1,
              child: SizedBox(
                height: 200.r,
                width: 200.r,
                child: Image.asset(ImageConstant.folderIcon),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            top: 130.r,
            left: 0,
            right: -50.r,
            child: AnimatedBuilder(
              animation: _animation4,
              builder: (context, child) {
                final angle = _animation4.value * 2 * pi; // 0 → 360°
                final offsetX = radius * cos(angle);
                final offsetY = radius * sin(angle);

                return Transform.translate(
                  offset: Offset(offsetX, offsetY),
                  child: child,
                );
              },
              child: Image.asset(ImageConstant.searchIcon),
            ),
          ),
          Positioned(
            bottom: 0,
            top: 110.r,
            left: 0,
            right: -130.r,
            child: FadeTransition(
              opacity: _animation5,
              child: Icon(
                Icons.close,
                color: AppColors.rejectedStatusColor,
                size: 40.r,
              ),
            ),
          ),
          Positioned(
            bottom: -120.r,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _animation6,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: widget.titleMessage ?? "No Data Found",
                  style: StyleConstant.black700Regular24,
                  children: [
                    TextSpan(
                      text:
                          widget.subTitleMessage ?? "\nPlease Try Again Later",
                      style: StyleConstant.grey500Regular18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// A custom curved bottom navigation bar with a center floating action button (FAB).
/// 
/// - It includes four side icons (left & right), each with a scale animation when tapped.
/// - The center FAB is slightly lifted and also animates on tap.
/// - Fully configurable FAB size.
class CustomBottomNav extends StatefulWidget {
  /// Index of the currently selected page.
  final int currentIndex;

  /// Callback when an icon or the FAB is tapped.
  /// Provides the index of the tapped item.
  final ValueChanged<int> onTap;

  /// Size of the center floating action button.
  /// Defaults to 80.
  final double fabSize;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.fabSize = 80,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav>
    with TickerProviderStateMixin {
  late AnimationController _centerController;
  late List<AnimationController> _iconControllers;

  @override
  void initState() {
    super.initState();

    // Animation for the center FAB scaling when tapped.
    _centerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.9,
      upperBound: 1.0,
    );

    // Separate scale animations for each of the 4 side icons.
    _iconControllers = List.generate(4, (_) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
        lowerBound: 0.9,
        upperBound: 1.0,
      );
    });
  }

  @override
  void dispose() {
    _centerController.dispose();
    for (var controller in _iconControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Handles tap on the center FAB with bounce animation.
  void _onCenterTap() async {
    await _centerController.forward();
    await _centerController.reverse();
    widget.onTap(2); // center FAB corresponds to index 2
  }

  /// Handles tap on a side icon with bounce animation.
  void _onIconTap(int controllerIndex, int pageIndex) async {
    await _iconControllers[controllerIndex].forward();
    await _iconControllers[controllerIndex].reverse();
    widget.onTap(pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    double navHeight = widget.fabSize > 60 ? 75 : 70;

    return Container(
      height: navHeight,
      decoration: BoxDecoration(
        color: Colors.green.shade900,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Row with four side icons and a gap for the FAB
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                iconItem(Icons.notifications_outlined, 0, 0),
                iconItem(Icons.list_alt_outlined, 1, 1),
                SizedBox(width: widget.fabSize), // space for center FAB
                iconItem(Icons.device_hub_outlined, 2, 3),
                iconItem(Icons.headset_mic_outlined, 3, 4),
              ],
            ),
          ),
          // Center floating action button (FAB)
          Positioned(
            top: -widget.fabSize / 4, // only 1/4 of FAB outside the nav bar
            left: 0,
            right: 0,
            child: Center(
              child: ScaleTransition(
                scale: _centerController,
                child: GestureDetector(
                  onTap: _onCenterTap,
                  child: Container(
                    height: widget.fabSize,
                    width: widget.fabSize,
                    decoration: BoxDecoration(
                      color: Colors.green.shade700,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.home_outlined,
                      color: widget.currentIndex == 2
                          ? Colors.white
                          : Colors.black,
                      size: widget.fabSize * 0.55,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds each tappable side icon with scale animation and ripple.
  /// 
  /// [icon] - the icon to display.
  /// [controllerIndex] - which animation controller to use.
  /// [pageIndex] - the index to pass back to the parent on tap.
  Widget iconItem(IconData icon, int controllerIndex, int pageIndex) {
    return ScaleTransition(
      scale: _iconControllers[controllerIndex],
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => _onIconTap(controllerIndex, pageIndex),
          child: Padding(
            padding: const EdgeInsets.all(12.0), // increases touch target
            child: Icon(
              icon,
              color: widget.currentIndex == pageIndex
                  ? Colors.orange
                  : Colors.black,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
// This widget can be used in your main app screen to provide a custom bottom navigation experience.
// Just pass the current index and a callback to handle taps, and it will animate the icons
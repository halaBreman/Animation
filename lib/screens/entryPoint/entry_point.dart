import 'dart:math';
import 'package:animation_app/constants.dart';
import 'package:animation_app/screens/entryPoint/components/side_menu.dart';
import 'package:animation_app/screens/home/home_screen.dart';
import 'package:animation_app/utils/rive_utils.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../model/rive_model.dart';
import 'components/animated_bar.dart';
import 'components/menu_btn.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint>
    with SingleTickerProviderStateMixin {
  RiveAsset selectedBottomNav = bottomNav.first;
  late AnimationController _animationController;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;

  late SMIBool isSideBarClosed;
  bool isSideMenuClosed = true;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor2,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            left: isSideMenuClosed ? -288 : 0,
            height: MediaQuery.of(context).size.height,
            child: const SideMenu(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(animation.value - 30 * animation.value * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scaleAnimation.value,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(isSideMenuClosed ? 0 : 24),
                    ),
                    child: const HomeScreen(),),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideMenuClosed ? 0 : 220,
            top: 14,
            child: MenuBtn(
              riveOnInit: (artboard) {
                StateMachineController controller = RiveUtils.getRiveController(
                    artboard,
                    stateMachineName: "State Machine");
                isSideBarClosed = controller.findSMI("isOpen") as SMIBool;
                isSideBarClosed.value = true;
              },
              press: () {
                isSideBarClosed.value = !isSideBarClosed.value;
                if (isSideMenuClosed) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
                setState(() {
                  isSideMenuClosed = isSideBarClosed.value;
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0,100 * animation.value),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: backgroundColor2.withOpacity(0.8),
              borderRadius: const BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(
                  bottomNav.length,
                  (index) => GestureDetector(
                    onTap: () {
                      bottomNav[index].input!.change(true);
                      if (bottomNav[index] != selectedBottomNav) {
                        setState(() {
                          selectedBottomNav = bottomNav[index];
                          Future.delayed(
                            const Duration(seconds: 1),
                            () {
                              bottomNav[index].input!.change(false);
                            },
                          );
                        });
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBar(
                          isActive: bottomNav[index] == selectedBottomNav,
                        ),
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: Opacity(
                            opacity:
                                bottomNav[index] == selectedBottomNav ? 1 : 0.5,
                            child: RiveAnimation.asset(
                              bottomNav.first.src,
                              artboard: bottomNav[index].artboard,
                              onInit: (artboard) {
                                StateMachineController controller =
                                    RiveUtils.getRiveController(artboard,
                                        stateMachineName:
                                            bottomNav[index].stateMachineName);
                                bottomNav[index].input =
                                    controller.findSMI("active") as SMIBool;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

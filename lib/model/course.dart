import 'dart:ui';

class Course {
  final String title, description, iconSrc;
  final Color bgcolor;

  Course(
      {required this.title,
        this.description = "Build and animate an ios app from scratch",
        this.iconSrc = "assets/icons/code.svg",
        this.bgcolor = const Color(0xFF80A4FF)});
}

List<Course> course = [
  Course(title: "Animations in SwiftUI"),
  Course(
    title: "Animations in Flutter",
    iconSrc: "assets/icons/ios.svg",
    bgcolor: const Color(0xFF7553F6),
  ),
];

List<Course> recentCourse = [
  Course(title: "State Machine"),
  Course(
    title: "Animated Menu",
    bgcolor: const Color(0xFF9CC5FF),
    iconSrc: "assets/icons/ios.svg",
  ),
  Course(title: "Flutter with Rive"),
  Course(
    title: "Animated Menu",
    bgcolor: const Color(0xFF9CC5FF),
    iconSrc: "assets/icons/ios.svg",
  ),
];
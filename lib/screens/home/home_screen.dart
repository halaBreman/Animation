import 'package:flutter/material.dart';
import '../../model/course.dart';
import 'components/course_card.dart';
import 'components/secondary_course_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                "Course",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
                            ),
              ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...course
                          .map(
                            (course) => Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: CourseCard(
                                course: course,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Recent",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                ...recentCourse.map(
                  (course) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SecondaryCourseCard(
                      course: course,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
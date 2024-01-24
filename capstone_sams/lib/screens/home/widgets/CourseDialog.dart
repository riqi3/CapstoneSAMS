import 'package:capstone_sams/constants/theme/sizing.dart';  
import 'package:capstone_sams/global-widgets/forms/PatientRegistrationForm.dart';
import 'package:flutter/material.dart';

class CourseDialog extends StatelessWidget {
  const CourseDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> courses = [
      'Nursery',
      'Kindergarten',
      'Elementary',
      'Junior High School',
      'Senior High School',
      'Tertiary',
      'Law School',
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Add New Patient',
                              style: TextStyle(
                                fontSize: Sizing.header5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    Text(
                      'Student Course',
                      style: TextStyle(
                        fontSize: Sizing.header6,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientRegistrationForm(
                                course: courses[index],
                              ),
                            ),
                          );
                        },
                        title: Text(courses[index]),
                      );
                    },
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

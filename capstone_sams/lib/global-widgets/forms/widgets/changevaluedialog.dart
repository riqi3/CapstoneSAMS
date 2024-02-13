import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/global-widgets/forms/present-illness/PresentIllnessForm.dart';
import 'package:capstone_sams/models/PatientModel.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/api/api_diagnosticservice.dart';
import 'package:flutter/material.dart';

class ChangeValueDialog extends StatefulWidget {
  final String initialDisease;
  final Patient patient;

  ChangeValueDialog({required this.initialDisease, required this.patient});

  @override
  _ChangeValueDialogState createState() => _ChangeValueDialogState();
}

class _ChangeValueDialogState extends State<ChangeValueDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialDisease);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: Text(
        'Edit Suspected Disease',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Pallete.palegrayColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'New Disease',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                contentPadding: EdgeInsets.all(10.0),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final newDisease = _controller.text;
                  final isSuccess =
                      await ApiService.updateDisease(context, newDisease);

                  if (isSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PresentIllnessForm(
                            patient: widget.patient,
                            initialDisease: newDisease),
                      ),
                    );
                  } else {
                    print('Failed to update diagnosis.');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Submit and Use'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

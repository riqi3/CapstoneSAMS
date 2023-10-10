import 'package:flutter/material.dart';
import 'package:capstone_sams/screens/ehr-list/patient/order-entry/api/api_service.dart';

class PrognosisUpdateDialog extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Change Prognosis Value'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'New Prognosis'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newPrognosis = controller.text;
              final isSuccess =
                  await ApiService.updatePrognosis(context, newPrognosis);

              if (isSuccess) {
                // Close the dialog when prognosis is updated successfully
                Navigator.of(context).pop();
              } else {
                // Handle the case where updating the prognosis fails
                // You can display an error message or perform any necessary actions here
                print('Failed to update prognosis.');
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}

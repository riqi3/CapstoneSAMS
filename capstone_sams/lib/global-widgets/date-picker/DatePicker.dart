// import 'package:flutter/material.dart';

// import '../../theme/pallete.dart';

// class UserDatePicker extends StatefulWidget {
//   UserDatePicker({
//     super.key,
//     this.label,
//     this.onTap,
//     this.startDate,
//     this.endDate,
//   });

//   final String? label;
//   final showDatePicker? onTap;
//   late final DateTime? startDate, endDate;

//   @override
//   State<UserDatePicker> createState() => _UserDatePickerState();
// }

// class _UserDatePickerState extends State<UserDatePicker> {
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(
//         labelText: widget.label,
//         border: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Pallete.paleblueColor,
//           ),
//         ),
//         filled: true,
//         fillColor: Pallete.palegrayColor,
//         suffixIcon: Icon(Icons.calendar_today),
//       ),
//       readOnly: true,
//       onTap: () {
//         showDatePicker(
//           context: context,
//           initialDate: widget.startDate ?? DateTime.now(),
//           firstDate: widget.startDate ?? DateTime.now(),
//           lastDate: DateTime.now().add(Duration(days: 365)),
//         ).then((selectedDate) {
//           if (selectedDate != null) {
//             setState(() {
//               widget.startDate = selectedDate;
//             });
//           }
//         });
//       },
//       controller: TextEditingController(
//         text: widget.startDate != null
//             ? widget.startDate!.toLocal().toString().split(' ')[0]
//             : '',
//       ),
//     );
//   }
// }

// // class EndDatePicker extends StatefulWidget {
// //   EndDatePicker({
// //     super.key,
// //     this.label,
// //     this.selectedUserDate,
// //   });

// //   final String? label;
// //   late final DateTime? selectedUserDate;
// //   final startDatePicker = _StartDatePickerState();

// //   @override
// //   State<EndDatePicker> createState() => _EndDatePickerState();
// // }

// // class _EndDatePickerState extends State<EndDatePicker> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return TextFormField(
// //       decoration: InputDecoration(
// //         labelText: widget.label,
// //         border: OutlineInputBorder(
// //           borderSide: BorderSide(
// //             color: Pallete.paleblueColor,
// //           ),
// //         ),
// //         filled: true,
// //         fillColor: Pallete.palegrayColor,
// //         suffixIcon: Icon(Icons.calendar_today),
// //       ),
// //       readOnly: true,
// //       onTap: () {
// //         showDatePicker(
// //           context: context,
// //           initialDate: _selectedStartDate ?? DateTime.now(),
// //           firstDate: _selectedStartDate ?? DateTime.now(),
// //           lastDate: DateTime.now().add(Duration(days: 365)),
// //         ).then((selectedDate) {
// //           if (selectedDate != null) {
// //             setState(() {
// //               widget.selectedUserDate = selectedDate;
// //             });
// //           }
// //         });
// //       },
// //       controller: TextEditingController(
// //         text: widget.selectedUserDate != null
// //             ? widget.selectedUserDate!.toLocal().toString().split(' ')[0]
// //             : '',
// //       ),
// //     );
// //   }
// // }

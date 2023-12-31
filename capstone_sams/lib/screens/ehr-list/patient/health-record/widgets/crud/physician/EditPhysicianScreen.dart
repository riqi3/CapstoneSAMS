import 'package:capstone_sams/constants/Env.dart';
import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/global-widgets/buttons/CancelButton.dart';
import 'package:capstone_sams/models/AccountModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPhysicianScreen extends StatefulWidget {
  const EditPhysicianScreen({super.key});

  @override
  State<EditPhysicianScreen> createState() => _EditPhysicianScreenState();
}

class _EditPhysicianScreenState extends State<EditPhysicianScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  final _account = Account(isSuperuser: false);
  late String token = context.read<AccountProvider>().token!;

  void _onSubmit() async {
    setState(() => _isLoading = true);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Assigned Physician'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizing.sectionSymmPadding),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: Sizing.sectionSymmPadding),
            child: Material(
              elevation: Sizing.cardElevation,
              borderRadius: BorderRadius.all(
                Radius.circular(Sizing.borderRadius),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Pallete.mainColor,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(Sizing.borderRadius),
                          topLeft: Radius.circular(Sizing.borderRadius)),
                    ),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                        horizontal: Sizing.sectionSymmPadding),
                    width: MediaQuery.of(context).size.width,
                    height: Sizing.cardContainerHeight,
                    child: Text(
                      'Edit Physician Form',
                      style: TextStyle(
                          color: Pallete.whiteColor,
                          fontSize: Sizing.header3,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Sizing.borderRadius),
                        bottomRight: Radius.circular(Sizing.borderRadius)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Pallete.whiteColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(Sizing.borderRadius),
                            bottomLeft: Radius.circular(Sizing.borderRadius)),
                      ),
                      padding: const EdgeInsets.only(
                        left: Sizing.sectionSymmPadding,
                        right: Sizing.sectionSymmPadding,
                        bottom: Sizing.sectionSymmPadding,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Sizing.sectionSymmPadding),
                                    child: DropdownSearch<Account>(
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                                labelText:
                                                    "Select Physician On Duty "),
                                      ),
                                      clearButtonProps:
                                          ClearButtonProps(isVisible: true),
                                      popupProps: PopupProps.modalBottomSheet(
                                        showSearchBox: true,
                                      ),
                                      asyncItems: (String filter) async {
                                        var response = await Dio().get(
                                          '${Env.prefix}/user/users/physician',
                                          queryParameters: {"filter": filter},
                                          options: Options(headers: {
                                            "Content-Type": "application/json",
                                            "Authorization": "Bearer $token",
                                          }),
                                        );
                                        var models = List<Account>.from(
                                          response.data.map(
                                            (json) => Account.fromJson(json),
                                          ),
                                        );

                                        return models;
                                      },
                                      itemAsString: (Account account) {
                                        var string =
                                            'Dr. ${account.firstName.toString()} ${account.lastName.toString()}';
                                        return string;
                                      },
                                      onChanged: (Account? data) {
                                        _account.accountRole =
                                            data?.accountRole.toString();
                                      },
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: CancelButton(),
                                      ),
                                      SizedBox(width: Sizing.formSpacing),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed:
                                              _isLoading ? null : _onSubmit,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Pallete.mainColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Sizing.borderRadius),
                                            ),
                                          ),
                                          icon: _isLoading
                                              ? Container(
                                                  width: 24,
                                                  height: 24,
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child:
                                                      const CircularProgressIndicator(
                                                    color: Pallete.mainColor,
                                                    strokeWidth: 3,
                                                  ),
                                                )
                                              : const Icon(
                                                  Icons.upload,
                                                ),
                                          label: const Text('Submit'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:capstone_sams/constants/Env.dart';
import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/SearchAppBar.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:capstone_sams/global-widgets/buttons/CancelButton.dart';
import 'package:capstone_sams/global-widgets/buttons/FormSubmitButton.dart';
import 'package:capstone_sams/global-widgets/forms/FormTemplate.dart';
import 'package:capstone_sams/global-widgets/texts/FormSectionTitleWidget.dart';
import 'package:capstone_sams/global-widgets/texts/FormTitleWidget.dart';
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
  bool _isPhysicianInvalid = false;
  final _account = Account(isSuperuser: false);
  late String token = context.read<AccountProvider>().token!;

  void _onSubmit() async {
    setState(() => _isLoading = true);
  }

  void updateInvalidState(var condition, Function(bool) setStateFunction) {
    setState(() {
      setStateFunction(condition);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormTemplate(
      column: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormTitleWidget(title: 'Change Physician Form'),
          ChangePhysicianFormSection(),
          SubmitButton(),
        ],
      ),
    );
  }

  Column ChangePhysicianFormSection() {
    return Column(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FormSectionTitleWidget(title: 'Assign Doctor'),
              DropdownSearch<Account>(
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration:
                      InputDecoration(labelText: "Select Physician On Duty "),
                ),
                clearButtonProps: ClearButtonProps(isVisible: true),
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
                  _account.accountRole = data?.accountRole.toString();
                },
              ),
              Visibility(
                visible: _isPhysicianInvalid,
                child: Text(
                  Strings.requiredField,
                  style: TextStyle(color: Pallete.dangerColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding SubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(top: Sizing.sectionSymmPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: CancelButton()),
          SizedBox(width: Sizing.formSpacing),
          Expanded(
            child: FormSubmitButton(
              title: 'Submit',
              icon: Icons.upload,
              isLoading: _isLoading,
              onpressed: _isLoading ? null : _onSubmit,
            ),
          ),
        ],
      ),
    );
  }
}

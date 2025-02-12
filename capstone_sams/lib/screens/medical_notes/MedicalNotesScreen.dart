// ignore_for_file: prefer_const_constructors

import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/MedicalNotesProvider.dart';
import 'package:capstone_sams/screens/medical_notes/AddTodoScreen.dart';
import 'package:capstone_sams/screens/medical_notes/widgets/CompletedListWidget.dart';
import 'package:capstone_sams/screens/medical_notes/widgets/TodoListWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../constants/theme/pallete.dart';
import '../../constants/theme/sizing.dart';

class MedicalNotes extends StatefulWidget {
  const MedicalNotes({Key? key}) : super(key: key);

  @override
  _MedicalNotesState createState() => _MedicalNotesState();
}

class _MedicalNotesState extends State<MedicalNotes>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);

    final provider = Provider.of<TodosProvider>(context, listen: false);
    final accountID = context.read<AccountProvider>().id;
    final token = context.read<AccountProvider>().token!;
    provider.fetchTodos(accountID!, token);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ValueDashboard(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Sizing.appbarHeight),
        child: ValueMedNotes(
          tabController: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          const TodoListWidget(),
          const CompletedListWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Pallete.mainColor,
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AddTodoPage(),
        ),
        child: FaIcon(FontAwesomeIcons.pencil),
      ),
    );
  }
}

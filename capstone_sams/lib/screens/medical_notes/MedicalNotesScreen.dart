// ignore_for_file: prefer_const_constructors

import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/MedicalNotesProvider.dart';
import 'package:capstone_sams/screens/medical_notes/AddTodoScreen.dart';

import 'package:capstone_sams/screens/medical_notes/widgets/CompletedListWidget.dart';
import 'package:capstone_sams/screens/medical_notes/widgets/TodoListWidget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/sizing.dart';

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
    provider.fetchTodos(accountID!);
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
        backgroundColor: Color(0xFFFF6969),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AddTodoPage(),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit),
            ],
          ),
        ),
      ),
    );
  }
}

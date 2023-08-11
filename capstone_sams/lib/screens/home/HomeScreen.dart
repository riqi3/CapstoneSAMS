import 'package:capstone_sams/constants/Dimensions.dart';
import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/models/MedicalNotesModel.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/MedicalNotesProvider.dart';

import 'package:capstone_sams/screens/ehr-list/EhrListScreen.dart';
import 'package:capstone_sams/screens/home/widgets/PatientSection.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/sizing.dart';
import '../medical_notes/MedicalNotesScreen.dart';
import 'widgets/NotesSection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> _userTodos = [];
  String ehrTitle = 'Health Records';
  String medNotesTitle = 'Your Notes';

  @override
  void initState() {
    super.initState();
    _fetchUserTodos();
  }

  Future<void> _fetchUserTodos() async {
    final provider = Provider.of<TodosProvider>(context, listen: false);
    final accountID = context.read<AccountProvider>().id;
    await provider.fetchTodos(accountID!);

    setState(() {
      _userTodos = provider.todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawer: ValueDashboard(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Sizing.headerHeight),
          child: ValueHomeAppBar(),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth >= Dimensions.mobileWidth) {
                return _tabletView(context, ehrTitle, medNotesTitle);
              } else {
                return _mobileView(context, ehrTitle, medNotesTitle);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _mobileView(context, medNotesTitle, ehrTitle) {
    final todosPreview =
        _userTodos.length > 3 ? _userTodos.sublist(0, 3) : _userTodos;

    return Column(
      children: [
        Center(
          child: EHRSection(
            title: ehrTitle,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EhrListScreen(),
                ),
              );
            },
          ),
        ),
        Center(
          child: NotesSection(
            title: medNotesTitle,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicalNotes(),
                ),
              );
            },
            todosPreview: todosPreview,
          ),
        ),
      ],
    );
  }

  Widget _tabletView(context, ehrTitle, medNotesTitle) {
    final todosPreview =
        _userTodos.length > 3 ? _userTodos.sublist(0, 3) : _userTodos;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: EHRSection(
              title: 'ss',
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EhrListScreen(),
                  ),
                );
                print('object');
              },
            ),
          ),
          Expanded(
            child: NotesSection(
              title: medNotesTitle,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicalNotes(),
                  ),
                );
              },
              todosPreview: todosPreview,
            ),
          ),
        ],
      ),
    );
  }
}

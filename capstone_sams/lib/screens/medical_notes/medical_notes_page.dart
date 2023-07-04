// ignore_for_file: prefer_const_constructors

import 'package:capstone_sams/screens/medical_notes/add_todo_page.dart';
import 'package:capstone_sams/screens/medical_notes/widgets/completed_list_widget.dart';
import 'package:capstone_sams/screens/medical_notes/widgets/todo_list_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF6969),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // back
          },
        ),
        title: Text("Your Notes"),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // menu
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelPadding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              indicatorWeight: 2.0,
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('To Do', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 10,
                  child: Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text('Completed', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
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

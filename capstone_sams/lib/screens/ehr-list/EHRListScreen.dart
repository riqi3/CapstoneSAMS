import 'package:capstone_sams/constants/Dimensions.dart';
import 'package:capstone_sams/declare/ValueDeclaration.dart';
import 'package:capstone_sams/global-widgets/TitleAppBar.dart';
import 'package:capstone_sams/models/PatientModel.dart';

import 'package:capstone_sams/screens/ehr-list/widgets/PatientCard.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:provider/provider.dart';
import 'package:capstone_sams/theme/pallete.dart';

import '../../providers/PatientProvider.dart';
import '../../theme/sizing.dart';

class EhrListScreen extends StatefulWidget {
  @override
  State<EhrListScreen> createState() => _EhrListScreenState();
}

class _EhrListScreenState extends State<EhrListScreen> {
  late Future<List<Patient>> patients;

  @override
  void initState() {
    super.initState();
    patients = context.read<PatientProvider>().fetchPatients();
  }

  final double items = 50;
  final start = 0;
  int currentPageIndex = 0;
  int pageRounded = 0;
  double? totalPatients = 0;
  double pages1 = 0;

  @override
  Widget build(BuildContext context) {
    var pages = SingleChildScrollView(
      padding: EdgeInsets.only(
        left: Sizing.sectionSymmPadding,
        right: Sizing.sectionSymmPadding,
        top: Sizing.sectionSymmPadding * 2,
        bottom: Sizing.sectionSymmPadding * 4,
      ),
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: FutureBuilder<List<Patient>>(
        future: patients,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }

          List<Patient> dataToShow = snapshot.data!;

          // final start = max(0, (currentPageIndex - 1) * items.toInt());
          // final end = (currentPageIndex * items.toInt() + items.toInt() <=
          //         totalPatients!.toInt())
          //     ? ((currentPageIndex * items.toInt()) + items.toInt())
          //     : totalPatients!.toInt();
          // final start = max(0, (currentPageIndex - 1) * items.toInt());

          final start = currentPageIndex * items.toInt();
          final end =
              (currentPageIndex.toInt() * items.toInt() + items.toInt() <=
                      totalPatients!.toInt())
                  ? (currentPageIndex.toInt() * items.toInt() + items.toInt())
                  : totalPatients!.toInt();

          // end = (currentPageIndex * items.toInt() + items.toInt() <=
          //         totalPatients!.toInt())
          //     ? ((currentPageIndex * items.toInt()) + items.toInt())
          //     : totalPatients!.toInt();
          print('start ${start} end ${end}');

          dataToShow = dataToShow.sublist(start, end);

          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              totalPatients = snapshot.data?.length.toDouble();
              pages1 = (totalPatients! / items);

              print('items display per page ${items}');
              if (pages1 > items) pages1++;
              pageRounded = pages1.ceil();

              // if (currentPageIndex > totalPatients!.ceil() ) {
              //   int remainingItems = totalPatients.to % itemsPerPage;
              //   int remainingPages = (remainingItems / itemsPerPage).ceil();

              //   if (remainingItems > 0) {
              //     totalPages += remainingPages;
              //     // Create a new page and add the remaining items to it
              //     // ...
              //   }
              // }

              print(
                  "number of pagess ${pageRounded} aa  number of patients ${totalPatients}");
              if (constraints.maxWidth >= Dimensions.mobileWidth) {
                return _tabletView(snapshot, dataToShow, start);
              } else {
                return _mobileView(snapshot, dataToShow, start);
              }
            },
          );
        },
      ),
    );

    return Scaffold(
      endDrawer: ValueDashboard(),
      appBar: PreferredSize(
        child: TitleAppBar(
            text: 'Health Records',
            iconColorLeading: Pallete.whiteColor,
            iconColorTrailing: Pallete.whiteColor,
            backgroundColor: Pallete.mainColor),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: pages,
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ChevronPrev(),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: Sizing.sectionSymmPadding),
            child: Text(
              '${currentPageIndex + 1} out of ${pageRounded}',
              style: TextStyle(fontSize: Sizing.header5),
            ),
          ),
          ChevronNext(),
        ],
      ),
      //     NumberPagination(
      //   onPageChanged: (int pageNumber) {
      //     setState(() {
      //       currentPageIndex = pageNumber;
      //     });
      //   },
      //   pageTotal: pageRounded,
      //   pageInit: currentPageIndex,
      //   colorPrimary: Pallete.whiteColor,
      //   colorSub: Pallete.mainColor,
      // ),
    );
  }

  ElevatedButton ChevronPrev() {
    return ElevatedButton(
      onPressed: () => {
        if (currentPageIndex > 0)
          {
            setState(() {
              currentPageIndex -= 1;
            })
          }
      },
      child: const FaIcon(FontAwesomeIcons.chevronLeft),
      style: ElevatedButton.styleFrom(
        primary: Pallete.mainColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        minimumSize: Size(50, 50), //////// HERE
      ),
    );
  }

  ElevatedButton ChevronNext() {
    return ElevatedButton(
      onPressed: () => {
        if (currentPageIndex < pageRounded - 1)
          {
            setState(() {
              currentPageIndex += 1;
            })
          }
      },
      child: const FaIcon(FontAwesomeIcons.chevronRight),
      style: ElevatedButton.styleFrom(
        primary: Pallete.mainColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        minimumSize: Size(50, 50), //////// HERE
      ),
    );
  }

  GridView _mobileView(AsyncSnapshot<List<Patient>> snapshot,
      List<Patient> dataToShow, int start) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(),
      physics: const BouncingScrollPhysics(),
      itemCount: dataToShow.length,
      itemBuilder: (context, index) {
        final patient = dataToShow[index];
        print("phone ${pageRounded}");
        return PatientCard(patient: patient, index: (start + index + 1));
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 16 / 8,
      ),
    );
  }

  GridView _tabletView(AsyncSnapshot<List<Patient>> snapshot,
      List<Patient> dataToShow, int start) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: dataToShow.length,
      itemBuilder: (context, index) {
        final patient = dataToShow[index];
        print("tablet ${pageRounded}");
        return PatientCard(patient: patient, index: (start + index + 1));
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 16 / 10,
      ),
    );
  }
}

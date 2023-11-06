import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/providers/MedicineProvider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/sizing.dart';
import '../../models/MedicineModel.dart';

 

class SearchMedicineDelegate extends SearchDelegate<String> {
  MedicineProvider _medicineList = MedicineProvider();

  late Future<List<Medicine>> medicines;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, 'Search result');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Medicine>>(
      future: _medicineList.searchMedicines(query: query, token: context.read<AccountProvider>().token),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Medicine>? medicine = snapshot.data;
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: medicine!.length,
          itemBuilder: (context, index) {
            final result = medicine[index];
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Sizing.sectionSymmPadding, vertical: 4),
              child: Card(
                elevation: Sizing.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Sizing.borderRadius / 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizing.sectionSymmPadding / 2,
                  ),
                  child: ListTile(
                    onTap: () {
                      query = result.toString();
                      // close(context, result.toString());
                      this.close(context, this.query);
                      // showResults(context, index);
                      // print((context, this.query));
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${medicine[index].drugCode}',
                          style: TextStyle(
                            fontSize: Sizing.header5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '${medicine[index].drugName}',
                          style: TextStyle(
                            fontSize: Sizing.header5,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Search Medicine'),
    );
  }
}

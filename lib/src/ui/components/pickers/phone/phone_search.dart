import 'package:flutter/material.dart';

import '../../../../models/phone/country_phone_data.dart';
import '../../../components/styled/styled_text_field.dart' show StyledTextField;

class CustomSearchDelegate extends SearchDelegate<CountryPhoneData> {
  CustomSearchDelegate({
    this.favorites,
    @required this.countryPhoneDataList,
    @required this.onSelected,
  });

  List<CountryPhoneData> favorites;
  List<CountryPhoneData> countryPhoneDataList;
  Function onSelected;

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<CountryPhoneData> dummySearchList = <CountryPhoneData>[];
    if (query.isNotEmpty && query != '+') {
      final List<CountryPhoneData> totalList = <CountryPhoneData>[];
      if (favorites.isNotEmpty) {
        totalList.addAll(favorites);
      }
      totalList.addAll(countryPhoneDataList);
      dummySearchList.addAll(totalList.where((CountryPhoneData item) =>
          (item.name.toLowerCase() + '+' + item.code.toString())
              .contains(query.toLowerCase())));

      if (dummySearchList.isNotEmpty) {
        return _buildSearchRows(dummySearchList);
      }
    }
    if (dummySearchList.isEmpty || query == '+') {
      return _buildRows();
    }
    return Container();
  }

  Widget _buildRows() {
    final List<CountryPhoneData> list = <CountryPhoneData>[];
    if (favorites.isNotEmpty) {
      list.addAll(favorites);
    }
    list.addAll(countryPhoneDataList);

    final List<CountryPhoneData> totalList = list.toSet().toList();

    return ListView.builder(
        itemCount: totalList.length,
        itemBuilder: (BuildContext context, int index) {
          return favorites.isNotEmpty && index == favorites.length - 1
              ? Column(
                  children: <Widget>[
                    _buildListTile(totalList, index, context),
                    const Divider(height: 10.0, color: Colors.black)
                  ],
                )
              : _buildListTile(totalList, index, context);
        });
  }

  Widget _buildListTile(
      List<CountryPhoneData> totalList, int index, BuildContext context) {
    return ListTile(
        title: Text(
            '${totalList[index].flag + ' ' + totalList[index].name + ' +' +
                totalList[index].code.toString()}',
            style: TextStyle(fontSize: 16.0)),
        onTap: () {
          return onSelected is Function
              ? onSelected(close(context, totalList[index]))
              : Navigator.pop(context);
        });
  }

  Widget _buildSearchRows(List<CountryPhoneData> totalList) {
    return ListView.builder(
        itemCount: totalList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildListTile(totalList, index, context);
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty || query == '+') {
      return _buildRows();
    } else {
      final List<CountryPhoneData> dummySearchList = <CountryPhoneData>[];
      if (query.isNotEmpty) {
        final List<CountryPhoneData> totalList = <CountryPhoneData>[];
        if (favorites.isNotEmpty) {
          totalList.addAll(favorites);
        }
        totalList.addAll(countryPhoneDataList);
        dummySearchList.addAll(totalList.where((CountryPhoneData item) =>
            (item.name.toLowerCase() + '+' + item.code.toString())
                .contains(query.toLowerCase())));

        if (dummySearchList.isNotEmpty) {
          return _buildSearchRows(dummySearchList);
        }
      }
    }
    return Container();
  }
}

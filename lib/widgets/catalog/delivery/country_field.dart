import 'package:flutter/material.dart';
import 'package:sofiqe/utils/states/local_storage.dart';
import 'package:sofiqe/utils/states/location_status.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CountryField extends StatefulWidget {
  final Function onSelect;
  final List countryList;
  CountryField({Key? key, required this.onSelect, required this.countryList})
      : super(key: key);

  @override
  _CountryFieldState createState() => _CountryFieldState();
}

class _CountryFieldState extends State<CountryField> {
  late var country = widget.countryList[0];
  late var region;
  var showRegion = false;
  final countryController = TextEditingController();
  final regionController = TextEditingController();

  @override
  initState() {
    super.initState();
    checkAvailableCountryData();
  }

  Future<void> checkAvailableCountryData() async {
    Map<String, dynamic> resultCountryCode = await sfQueryForSharedPrefData(
        fieldName: 'country', type: PreferencesDataType.STRING);
    Map<String, dynamic> resultRegionCode = await sfQueryForSharedPrefData(
        fieldName: 'region', type: PreferencesDataType.STRING);

    if (resultCountryCode['found']) {
      widget.countryList.forEach(
        (listItem) {
          if (listItem['two_letter_abbreviation'] ==
              resultCountryCode['country']) {
            country = listItem;
          }
        },
      );
      countryController.text = country['full_name_english'];
    } else {
      var countryFromLocation = await sfGetLocation();
      widget.countryList.forEach(
        (listItem) {
          if (listItem['full_name_english'] == countryFromLocation) {
            country = listItem;
          }
        },
      );
      countryController.text = country['full_name_english'];
    }

    if (resultRegionCode['found']) {
      country['available_regions'].forEach(
        (listItem) {
          if (listItem['code'] == resultRegionCode['region']) {
            region = listItem;
            regionController.text = region['name'];
          }
        },
      );
    }
    widget.onSelect(country, region);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (country.containsKey('available_regions')) {
      showRegion = true;
      if (region == null) {
        region = country['available_regions'][0];
      }
    } else {
      showRegion = false;
      region = null;
      regionController.text = '';
    }
    return Container(
      child: Column(
        children: [
          _FormField(
            onChange: (String currentText) {
              widget.countryList.forEach(
                (item) {
                  if (item['full_name_english'].toLowerCase() ==
                      currentText.toLowerCase()) {
                    country = item;
                    widget.onSelect(country, region);
                    setState(() {});
                  }
                },
              );
            },
            controller: countryController,
            label: 'COUNTRY',
            width: size.width,
            list: widget.countryList,
            suggestionsCallback: (pattern) async {
              var suggestionList = widget.countryList.map((listItem) {
                if ((listItem['full_name_english'] as String)
                    .toLowerCase()
                    .contains(pattern.toLowerCase())) {
                  return listItem;
                }
              }).toList();
              return suggestionList;
            },
            itemBuilderCallback: (context, suggestion) {
              if (suggestion == null) {
                return Container();
              }
              return GestureDetector(
                onTap: () {
                  countryController.text =
                      (suggestion as Map)['full_name_english'];
                  country = suggestion;
                  widget.onSelect(country, region);
                  setState(() {});
                },
                child: ListTile(
                  title: Container(
                    child: Text(
                      '${(suggestion as Map)['full_name_english']}',
                      style: Theme.of(context).textTheme.headline2!.copyWith(
                            color: Colors.black,
                            fontSize: size.height * 0.024,
                          ),
                    ),
                  ),
                ),
              );
            },
          ),
          showRegion ? SizedBox(height: 24) : Container(),
          showRegion
              ? _FormField(
                  onChange: (String currentText) {
                    country['available_regions'].forEach(
                      (item) {
                        if (item['name'].toLowerCase() ==
                            currentText.toLowerCase()) {
                          region = item;
                          widget.onSelect(country, region);
                          setState(() {});
                        }
                      },
                    );
                  },
                  controller: regionController,
                  label: 'REGION',
                  width: size.width,
                  list: country['available_regions'],
                  suggestionsCallback: (pattern) async {
                    var suggestionList =
                        country['available_regions'].map((listItem) {
                      if ((listItem['name'] as String)
                          .toLowerCase()
                          .contains(pattern.toLowerCase())) {
                        return listItem;
                      }
                    }).toList();
                    return suggestionList;
                  },
                  itemBuilderCallback: (context, suggestion) {
                    if (suggestion == null) {
                      return Container();
                    }
                    return GestureDetector(
                      onTap: () {
                        regionController.text = (suggestion as Map)['name'];
                        region = suggestion;
                        widget.onSelect(country, region);

                        setState(() {});
                      },
                      child: ListTile(
                        title: Container(
                          child: Text(
                            '${(suggestion as Map)['name']}',
                            style:
                                Theme.of(context).textTheme.headline2!.copyWith(
                                      color: Colors.black,
                                      fontSize: size.height * 0.024,
                                    ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double height;
  final double width;
  final Color backgroundColor;
  final bool active;
  final Function? onTap;
  final Future<Iterable<Object?>> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, Object?) itemBuilderCallback;
  final void Function(String) onChange;
  final List list;
  const _FormField({
    Key? key,
    required this.label,
    required this.controller,
    this.height = 50,
    this.width = 200,
    this.backgroundColor = Colors.white,
    this.active = true,
    this.onTap,
    required this.list,
    required this.suggestionsCallback,
    required this.itemBuilderCallback,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.black,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
          ),
          SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: Container(
              padding: EdgeInsets.all(10),
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: backgroundColor,
              ),
              child: GestureDetector(
                  child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  onChanged: onChange,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                  ),
                  enabled: active,
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.black,
                        fontSize: size.height * 0.025,
                        letterSpacing: 0.5,
                      ),
                  controller: controller,
                ),
                suggestionsCallback: suggestionsCallback,
                itemBuilder: itemBuilderCallback,
                onSuggestionSelected: (suggestion) {},
              )),
            ),
          ),
        ],
      ),
    );
  }
}

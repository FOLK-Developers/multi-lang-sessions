import 'package:flutter/material.dart';
import 'package:multi_language_sessions/helpers/countries.dart';

class CountryCodeProvider with ChangeNotifier {
  List<Country> get countryCodeList => Countries().countriesList.map((country) {
        return Country.fromJson(country);
      }).toList();

  List<Country> _filter = List.from(
    Countries().countriesList.map<Country>(
      (country) {
        return Country.fromJson(country);
      },
    ),
  );
  List<Country> get filteredCountryList => _filter;

  Country _country = Country.fromJson(<String, String>{
    'name': 'India',
    'dial_code': '+91',
    'code': 'IN',
  });
  Country get currentCountry => _country;

  void filterCountryList(String countryName) {
    _filter = countryCodeList
        .where(
          (country) => country.name!.toLowerCase().contains(
                countryName.toLowerCase(),
              ),
        )
        .toList();
    notifyListeners();
  }

  void setCurrentCountry(Country country) {
    _country = country;
    notifyListeners();
  }
}

class Country {
  final String? name;
  final String? countryCode;
  final String? phoneCode;

  Country({
    this.name,
    this.countryCode,
    this.phoneCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] as String?,
      countryCode: json['code'] as String?,
      phoneCode: json['dial_code'] as String?,
    );
  }
}

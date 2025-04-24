import 'package:easy_localization/easy_localization.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectCountryWidget extends ConsumerWidget {
  const SelectCountryWidget({
    super.key,
    required this.countryController,
    required this.onCountrySelected,
  });

  final TextEditingController countryController;
  final Function(String) onCountrySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: countryController,
      readOnly: true,
      onTap: () => _showCountryPicker(context),
      decoration: InputDecoration(
        labelText: tr('ProfileInfoWidget.country'),
        suffixIcon: Icon(Icons.flag),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (country) {
        onCountrySelected(country.countryCode.toLowerCase());
        countryController.text = country.name;
      },
      countryListTheme: CountryListThemeData(
        flagSize: 24,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16),
        bottomSheetHeight: 520,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }
}

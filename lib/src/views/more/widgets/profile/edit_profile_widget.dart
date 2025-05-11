import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/admob_widget.dart';
import '../../../../viewmodels/user_setting/user_setting_view_model.dart';
import 'profile_info_widget.dart';
import 'save_button_widget.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({
    super.key,
    this.nickName,
    this.birthDate,
    this.mbti,
    this.country,
    required this.userSettingViewModel,
  });

  final String? nickName;
  final String? birthDate;
  final String? mbti;
  final String? country;
  final UserSettingViewModel userSettingViewModel;

  @override
  State<EditProfileWidget> createState() => _ProfileAndBtnWidgetState();
}

class _ProfileAndBtnWidgetState extends State<EditProfileWidget> {
  late final TextEditingController _nickNameController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _mbtiController;
  late final TextEditingController _countryController;
  late final UserSettingViewModel userSettingViewModel;

  final _nickNameFocusNode = FocusNode();
  final _mbtiFocusNode = FocusNode();
  DateTime? birthDate;
  String? selectedCountryCode;

  @override
  void initState() {
    super.initState();

    _nickNameController = TextEditingController(text: widget.nickName);
    _birthDateController = TextEditingController(text: widget.birthDate);
    _mbtiController = TextEditingController(text: widget.mbti ?? '');
    _countryController = TextEditingController();
    selectedCountryCode = widget.country;

    // 국가 코드가 있으면 적절한 국가 이름으로 설정
    if (selectedCountryCode != null) {
      _setCountryName(selectedCountryCode!);
    }

    userSettingViewModel = widget.userSettingViewModel;
  }

  void _setCountryName(String countryCode) {
    // 국가 코드를 국가 이름으로 변환
    Map<String, String> countryNames = {
      'us': 'United States',
      'kr': 'South Korea',
      'jp': 'Japan',
      'cn': 'China',
      'gb': 'United Kingdom',
      'de': 'Germany',
      'fr': 'France',
      'it': 'Italy',
      'ca': 'Canada',
      'au': 'Australia',
      'br': 'Brazil',
      'ru': 'Russia',
      'in': 'India',
    };

    _countryController.text = countryNames[countryCode] ?? countryCode;
  }

  void selectDate(DateTime selectedDate) {
    setState(() {
      birthDate = selectedDate;
      _birthDateController.text = formatBirthDate(selectedDate);
    });
  }

  void onCountrySelected(String countryCode) {
    setState(() {
      selectedCountryCode = countryCode;
    });
  }

  void validateNickName() {
    setState(() {});
  }

  @override
  void dispose() {
    _nickNameController.dispose();
    _birthDateController.dispose();
    _mbtiController.dispose();
    _countryController.dispose();
    _nickNameFocusNode.dispose();
    _mbtiFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ProfileInfoWidget(
            nickNameController: _nickNameController,
            birthDateController: _birthDateController,
            mbtiController: _mbtiController,
            countryController: _countryController,
            nickNameFocusNode: _nickNameFocusNode,
            mbtiFocusNode: _mbtiFocusNode,
            selectDate: selectDate,
            validateNickName: validateNickName,
            onCountrySelected: onCountrySelected,
            mbti: '',
          ),
          const SizedBox(height: 2), // 간격을 8로 줄임
          AdMobWidget.showBannerAd(50, true),
          SaveButtonWidget(
            title: tr('ProfileInfoWidget.save'),
            isValid: isValid,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroudColor: Theme.of(context).colorScheme.onPrimary,
            safeProfile: () async {
              await userSettingViewModel.updateUserSetting(
                updatedNickName: _nickNameController.text,
                updatedAge: _birthDateController.text,
                updatedMbti: _mbtiController.text,
                updatedCountry: selectedCountryCode,
              );
              if (context.mounted) {
                context.pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget get divider => Divider(height: 1, color: Colors.grey);

  String formatBirthDate(DateTime? date) {
    return date == null
        ? '생년월일을 선택해 보세요'
        : DateFormat('yyyy-MM-dd').format(date);
  }

  bool get isValid => _nickNameController.text.isNotEmpty;
}

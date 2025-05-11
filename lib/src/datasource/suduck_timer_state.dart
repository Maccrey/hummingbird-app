import 'package:hive_flutter/hive_flutter.dart';

class SuduckTimerState {
  final Box<List> _box;

  SuduckTimerState(this._box);

  Future<void> addSuDuckTimerState(List timerState) async {
    _box.isEmpty ? _box.add(timerState) : null;
  }

  Future<List?> getSuDuckTimerStates() async {
    try {
      return _box.isNotEmpty ? _box.getAt(0) : null;
    } catch (e) {
      // Hive 포맷 변경 등으로 읽기 실패 시 박스 초기화
      await _box.clear();
      return null;
    }
  }

  Future<void> deleteSuDuckTimerState() async {
    await _box.clear();
  }

  Future<void> updateSuDuckTimerState(int breakTime) async {
    try {
      final temp = _box.isNotEmpty ? _box.getAt(0) : null;
      if (temp != null) {
        _box.putAt(0, [temp[0], breakTime]);
      }
    } catch (e) {
      // 읽기/쓰기 실패 시 박스 초기화
      await _box.clear();
    }
  }
}

extension ListX on List {
  void removeNulls() {
    if (isEmpty) {
      return;
    }

    removeWhere((element) => element == null);
  }

  static List<T> compact<T>(List<T?> list, {bool removeEmpties = false}) {
    final compactedList = (List<T?>.of(list)..removeNulls());

    if (removeEmpties) {
      compactedList.removeWhere((item) => item is String && item.isEmpty);
    }

    return compactedList.map((element) => element!).toList();
  }

  List<T> compacted<T>({bool removeEmpties = false}) {
    if (contains(null) || this is List<T?> || (removeEmpties && contains(''))) {
      return ListX.compact<T>(this as List<T?>, removeEmpties: removeEmpties);
    }

    return this as List<T>;
  }
}

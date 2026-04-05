extension TCExt on String {
  int get tcNumber => int.tryParse(replaceAll('TC', '')) ?? -1;
}

//use:
// final result = apiList.where((api) {
//   return localList.map((e) => e.tcNumber).contains(api.tcNumber);
// }).toList();

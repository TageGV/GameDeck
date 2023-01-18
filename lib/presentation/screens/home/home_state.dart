import 'package:equatable/equatable.dart';
import 'package:mx_exchange/models/category.dart';

class HomeState {

  List<CategoryItem> items;

  List<CategoryItem> get selectedItems => items.where((element) => element.isSelected).toList();

  HomeState({required this.items});

  HomeState copyWith( List<CategoryItem> items) {
    return HomeState(items: items);
  }

  bool availableSelectItem(CategoryItem item) {
    if(selectedItems.isEmpty || item.isSelected) {
      return true;
    } else {
      return selectedItems.map((e) => e.isPremiumCategory).contains(item.isPremiumCategory);
    }
  }


}
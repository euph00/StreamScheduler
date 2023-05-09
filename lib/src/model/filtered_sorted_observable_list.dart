import 'package:mobx/mobx.dart';

class FilteredSortedObservableList<T> extends ObservableList<T> {
  FilteredSortedObservableList();

  factory FilteredSortedObservableList.withComparator(Comparator comp) {
    FilteredSortedObservableList<T> lst = FilteredSortedObservableList<T>();
    lst.setComparator(comp);
    return lst;
  }

  Comparator<T> comparator =
      (a, b) => 0; // default comparator: unsorted, all elements equal
  bool Function(T) filter =
      (element) => true; // default filter: lets everything through

  void setComparator(Comparator<T> comparator) {
    this.comparator = comparator;
    super.sort(comparator);
  }

  void setFilter(bool Function(T) filter) {
    this.filter = filter;
    Iterable<T> filtered = super.where(filter);
    super.clear();
    this.addAll(filtered);
  }

  @override
  void add(T element) {
    if (!filter(element)) {
      return;
    }
    super.add(element);
    super.sort(comparator);
  }

  @override
  void addAll(Iterable<T> iterable) {
    iterable = iterable.where(filter);
    super.addAll(iterable);
    super.sort(comparator);
  }
}

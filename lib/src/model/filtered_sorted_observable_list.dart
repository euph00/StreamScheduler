import 'package:mobx/mobx.dart';

class FilteredSortedObservableList<T> extends ObservableList<T> {
  FilteredSortedObservableList();
  static final Comparator defaultComparator =
      (a, b) => 0; // default comparator: unsorted, all elements equal
  static bool defaultFilter(element) {
    return true;
  } // default filter: lets everything through

  factory FilteredSortedObservableList.withComparator(Comparator comp) {
    FilteredSortedObservableList<T> lst = FilteredSortedObservableList<T>();
    lst.setComparator(comp);
    return lst;
  }

  Comparator<T> comparator = defaultComparator;
  bool Function(T) filter = defaultFilter;

  void reset() {
    super.clear();
    this.comparator = defaultComparator;
    this.filter = defaultFilter;
  }

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

import 'package:mobx/mobx.dart';

class SortedObservableList<T> extends ObservableList<T> {

  Comparator<T> comparator = (a, b) => 0; // default comparator: unsorted, all elements equal
  
  void setComparator(Comparator<T> comparator) {
    this.comparator = comparator;
    super.sort(comparator);
  }

  @override
  void add(T element) {
    super.add(element);
    super.sort(comparator);
  }

  @override
  void addAll(Iterable<T> iterable) {
    super.addAll(iterable);
    super.sort(comparator);
  }
}
import 'dart:async';
import 'dart:ui';

/* Example:
final _searchDebouncer = Debouncer(milliseconds: 300);

_searchDebouncer.run(
  () {
    ///Your search logic
  },
);
*/
class Debouncer {
  Debouncer({
    this.milliseconds = 300,
  });

  final int milliseconds;
  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

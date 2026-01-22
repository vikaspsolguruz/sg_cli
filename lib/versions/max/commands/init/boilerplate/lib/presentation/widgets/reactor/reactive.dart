part of 'reactor.dart';

final _models = <String, Map<Reactive, int>>{};
final _listeners = <String, Set<VoidCallback>>{};

mixin Reactive {
  String? get id;

  void reactiveCopy(covariant Reactive source);

  void _register() {
    if (id == null) return;
    final key = '$runtimeType:$id';
    _models[key] ??= {};
    _models[key]![this] = (_models[key]![this] ?? 0) + 1;
  }

  void _unregister() {
    if (id == null) return;
    final key = '$runtimeType:$id';
    final map = _models[key];
    if (map == null) return;
    final count = (map[this] ?? 1) - 1;
    if (count <= 0) {
      map.remove(this);
      if (map.isEmpty) _models.remove(key);
    } else {
      map[this] = count;
    }
  }

  void notifyEveryWhere() {
    if (id == null) return;
    final key = '$runtimeType:$id';

    final map = _models[key];
    if (map != null) {
      for (final m in map.keys) {
        if (m != this) m.reactiveCopy(this);
      }
    }

    final listeners = _listeners[key];
    if (listeners != null) {
      for (final l in [...listeners]) {
        l();
      }
    }

    if (map != null && !kReleaseMode) {
      xPrint("Reacted $runtimeType to ${map.keys.length} instances and ${_listeners.length} widgets. id: $id", title: "Reactor");
    }
  }

  void _listen(VoidCallback callback) {
    if (id == null) return;
    final key = '$runtimeType:$id';
    _listeners[key] ??= {};
    _listeners[key]!.add(callback);
  }

  void _unlisten(VoidCallback cb) {
    if (id == null) return;
    _listeners['$runtimeType:$id']?.remove(cb);
  }
}

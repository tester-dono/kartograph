
/// Basic map event.
abstract class BaseMapEvent{
  /// Constructor.
  const BaseMapEvent();
}

/// map get current location event.
class MapGetLocationEvent extends BaseMapEvent {}

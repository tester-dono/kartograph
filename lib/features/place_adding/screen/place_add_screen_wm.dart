import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:kartograph/api/data/place.dart';
import 'package:kartograph/assets/enums/categories.dart';
import 'package:kartograph/features/map_adding/map_adding_route.dart';
import 'package:kartograph/features/map_adding/screen/map_adding_screen.dart';
import 'package:kartograph/features/navigation/domain/entity/app_route_paths.dart';
import 'package:kartograph/features/place_adding/screen/place_add_screen.dart';
import 'package:kartograph/features/place_adding/screen/place_screen_model.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

/// factory for [PlaceAddingScreen]
PlaceAddingWidgetModel placeAddingWidgetModelFactory(BuildContext context) {
  return PlaceAddingWidgetModel(PlaceAddingModel());
}

/// WidgetModel for [PlaceAddingScreen]
class PlaceAddingWidgetModel
    extends WidgetModel<PlaceAddingScreen, PlaceAddingModel>
    with SingleTickerProviderWidgetModelMixin
    implements IPlaceAddingWidgetModel {
  final StateNotifier<bool> _nameState = StateNotifier<bool>();

  final StateNotifier<bool> _describeState = StateNotifier<bool>();

  final StateNotifier<bool> _lonState = StateNotifier<bool>();

  final StateNotifier<bool> _latState = StateNotifier<bool>();

  final StateNotifier<bool> _readyState = StateNotifier<bool>();

  final StateNotifier<Categories> _currentValue = StateNotifier<Categories>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _describeController = TextEditingController();

  final TextEditingController _lonController = TextEditingController();

  final TextEditingController _latController = TextEditingController();

  late final Place _place;

  late final bool _isChange;

  final List<DropdownMenuItem<Categories>> _choises =
      Categories.values.map<DropdownMenuItem<Categories>>((value) {
    return DropdownMenuItem<Categories>(
      value: value,
      child: Text(value.categoryName),
    );
  }).toList();

  @override
  TextEditingController get nameController => _nameController;

  @override
  TextEditingController get describeController => _describeController;

  @override
  TextEditingController get latController => _latController;

  @override
  TextEditingController get lonController => _lonController;

  @override
  StateNotifier<bool> get describeState => _describeState;

  @override
  StateNotifier<bool> get latState => _latState;

  @override
  StateNotifier<bool> get lonState => _lonState;

  @override
  StateNotifier<bool> get readyState => _readyState;

  @override
  StateNotifier<bool> get nameState => _nameState;

  @override
  List<DropdownMenuItem<Categories>> get choises => _choises;

  @override
  StateNotifier<Categories> get currentState => _currentValue;

  @override
  bool get isChange => _isChange;

  /// standard consctructor for elem
  PlaceAddingWidgetModel(PlaceAddingModel model) : super(model);

  @override
  void initWidgetModel() {
    _place = context.read<Place>();
    _setStartingStates();
    _setControllers();
    if (_place.id != null) {
      _isChange = true;
    } else {
      _isChange = false;
    }
    _currentValue.accept(_place.placeType);
    if (_place.name != null && _place.name != '') {
      _nameController.text = _place.name!;
    }
    if (_place.description != null && _place.description != '') {
      _describeController.text = _place.description!;
    }
    if (_place.lat != 0) {
      _latController.text = _place.lat.toString();
    }
    if (_place.lng != 0) {
      _lonController.text = _place.lng.toString();
    }

    super.initWidgetModel();
  }

  @override
  void dispose() {
    _nameState.dispose();
    _describeState.dispose();
    _readyState.dispose();
    _latState.dispose();
    _lonState.accept(false);
    _currentValue.dispose();
    _nameController.dispose();
    _describeController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  @override
  void activate() {
    super.activate();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void moveToMap() async {
    // Routemaster.of(context).push(AppRoutePaths.mapAdding, queryParameters: {
    //   'category': _place.placeType.name,
    //   'name': _place.name ?? '',
    //   'description': _place.description ?? '',
    // });
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  MapAddingScreen(test: 3,)),
    );
    // ignore: avoid_print
    print(result);
  }

  @override
  void pop() {
    if (_place.id != null) {
      Routemaster.of(context).pop();
    } else {
      Routemaster.of(context)
          .push('${AppRoutePaths.tabs}${AppRoutePaths.placesScreen}');
    }
  }

  @override
  void createPlace() {
    if (_place.id != null) {
      model.putPlace(
        Place(
          placeType: _currentValue.value!,
          id: _place.id,
          name: _nameController.text,
          description: _describeController.text,
          lat: double.parse(_latController.text),
          lng: double.parse(_lonController.text),
        ),
      );
      Routemaster.of(context).pop();
    } else {
      model.postPlace(
        Place(
          placeType: _currentValue.value!,
          name: _nameController.text,
          description: _describeController.text,
          lat: double.parse(_latController.text),
          lng: double.parse(_lonController.text),
        ),
      );
      Routemaster.of(context).pop();
      Routemaster.of(context)
          .push('${AppRoutePaths.tabs}${AppRoutePaths.mapScreen}');
    }
  }

  @override
  void changeType(Categories? newType) {
    _currentValue.accept(newType);
  }

  /// функция для листенера контроллера поля имени
  void _nameHandle() {
    if (_nameController.text.isNotEmpty) {
      _nameState.accept(true);
      _checkPreparation();
    } else {
      _nameState.accept(false);
    }
  }

  /// функция для листенера контроллера поля описания
  void _describeHandle() {
    if (_describeController.text.isNotEmpty) {
      _describeState.accept(true);
      _checkPreparation();
    } else {
      _describeState.accept(false);
    }
  }

  /// функция для листенера контроллера поля широты
  void _latHandle() {
    if (_latController.text.isNotEmpty &&
        double.tryParse(_latController.text) != null) {
      _latState.accept(true);
      _checkPreparation();
    } else {
      _latState.accept(false);
    }
  }

  /// функция для листенера контроллера поля долготы
  void _lonHandle() {
    if (double.tryParse(_lonController.text) != null) {
      _lonState.accept(true);
      _checkPreparation();
    } else {
      _lonState.accept(false);
    }
  }

  void _checkPreparation() {
    if (_nameState.value! &&
        _describeState.value! &&
        _latState.value! &&
        _lonState.value!) {
      _readyState.accept(true);
    } else {
      _readyState.accept(false);
    }
  }

  /// функция проверяющая все ли поля заполнены нормально
  void _setStartingStates() {
    _nameState.accept(false);
    _describeState.accept(false);
    _readyState.accept(false);
    _latState.accept(false);
    _lonState.accept(false);
    _currentValue.accept(Categories.other);
  }

  /// функция проверяющая все ли поля заполнены нормально
  void _setControllers() {
    _nameController.addListener(_nameHandle);
    _describeController.addListener(_describeHandle);
    _latController.addListener(_latHandle);
    _lonController.addListener(_lonHandle);
  }
}

/// Interface of [PlaceAddingWidgetModel].
abstract class IPlaceAddingWidgetModel extends IWidgetModel {
  /// состояния поля имени
  StateNotifier<bool> get nameState;

  /// состояния поля описания
  StateNotifier<bool> get describeState;

  /// состояния поля широты
  StateNotifier<bool> get latState;

  /// состояния поля долготы
  StateNotifier<bool> get lonState;

  /// состояния кнопки
  StateNotifier<bool> get readyState;

  /// выбронный тип места
  StateNotifier<Categories> get currentState;

  ///  контроллер поля имени
  TextEditingController get nameController;

  /// контроллер поля описания
  TextEditingController get describeController;

  /// контроллер поля широты
  TextEditingController get latController;

  /// контроллер поля долготы
  TextEditingController get lonController;

  /// список типов мест
  List<DropdownMenuItem<Categories>> get choises;

  /// изменять или создавать новое место
  bool get isChange;

  /// метод изменения  типа
  void changeType(Categories? newType);

  /// метод перехода на карту
  void moveToMap();

  /// метод закрытия экрана
  void pop();

  /// метод создания нового места
  void createPlace();
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Controller on ControllerBase, Store {
  final _$apiServiceAtom = Atom(name: 'ControllerBase.apiService');

  @override
  ApiService get apiService {
    _$apiServiceAtom.context.enforceReadPolicy(_$apiServiceAtom);
    _$apiServiceAtom.reportObserved();
    return super.apiService;
  }

  @override
  set apiService(ApiService value) {
    _$apiServiceAtom.context.conditionallyRunInAction(() {
      super.apiService = value;
      _$apiServiceAtom.reportChanged();
    }, _$apiServiceAtom, name: '${_$apiServiceAtom.name}_set');
  }

  final _$ControllerBaseActionController =
      ActionController(name: 'ControllerBase');

  @override
  dynamic api() {
    final _$actionInfo = _$ControllerBaseActionController.startAction();
    try {
      return super.api();
    } finally {
      _$ControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    final string = 'apiService: ${apiService.toString()}';
    return '{$string}';
  }
}

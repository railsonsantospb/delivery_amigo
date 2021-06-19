// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobx_cart.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Controller on StoreValue, Store {
  final _$valueAtom = Atom(name: 'StoreValue.value');

  @override
  double get value {
    _$valueAtom.reportRead();
    return super.value;
  }

  @override
  set value(double value) {
    _$valueAtom.reportWrite(value, super.value, () {
      super.value = value;
    });
  }

  final _$valsAtom = Atom(name: 'StoreValue.vals');

  @override
  int get vals {
    _$valsAtom.reportRead();
    return super.vals;
  }

  @override
  set vals(int value) {
    _$valsAtom.reportWrite(value, super.vals, () {
      super.vals = value;
    });
  }

  final _$StoreValueActionController = ActionController(name: 'StoreValue');

  @override
  dynamic increment(double val) {
    final _$actionInfo =
        _$StoreValueActionController.startAction(name: 'StoreValue.increment');
    try {
      return super.increment(val);
    } finally {
      _$StoreValueActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic decrement(double val) {
    final _$actionInfo =
        _$StoreValueActionController.startAction(name: 'StoreValue.decrement');
    try {
      return super.decrement(val);
    } finally {
      _$StoreValueActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addVals(int n) {
    final _$actionInfo =
        _$StoreValueActionController.startAction(name: 'StoreValue.addVals');
    try {
      return super.addVals(n);
    } finally {
      _$StoreValueActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
value: ${value},
vals: ${vals}
    ''';
  }
}

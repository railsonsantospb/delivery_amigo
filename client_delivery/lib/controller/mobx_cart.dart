import 'package:mobx/mobx.dart';
part 'mobx_cart.g.dart';

class Controller = StoreValue with _$Controller;

abstract class StoreValue with Store {
  @observable
  double value = 0;

  @observable
  int vals = 0;

  @action
  increment(double val) {
    value += val;
  }

  @action
  decrement(double val) {
    value -= val;
  }

  @action
  addVals(int n) {
    vals += n;
  }
}

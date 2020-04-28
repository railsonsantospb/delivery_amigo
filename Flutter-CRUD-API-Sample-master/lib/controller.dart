import 'package:mobx/mobx.dart';
import 'src/api/api_service.dart';
part 'controller.g.dart';

class Controller = ControllerBase with _$Controller;

abstract class ControllerBase with Store {

  @observable
  ApiService apiService = ApiService();


  @action
  api(){
    return apiService.getCategory();
  }

}
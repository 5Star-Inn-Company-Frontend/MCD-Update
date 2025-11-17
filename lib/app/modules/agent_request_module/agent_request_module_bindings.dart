import 'package:get/get.dart';
import './agent_request_module_controller.dart';

class AgentRequestModuleBindings implements Bindings {
    @override
    void dependencies() {
        Get.put(AgentRequestModuleController());
    }
}
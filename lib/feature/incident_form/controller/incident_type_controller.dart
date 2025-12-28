import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:smart_incident/feature/common/constants/api_urls.dart';
import 'package:smart_incident/feature/common/enum/request_types.dart';
import 'package:smart_incident/feature/incident_form/model/incident_type_model.dart';
import 'package:smart_incident/utils/network_service/api_client.dart';
import 'package:smart_incident/utils/state_management/generic_state.dart';

final incidentTypeController =
    StateNotifierProvider<
      IncidentTypeController,
      GenericState<List<IncidentTypeModel>>
    >((ref) => IncidentTypeController(InitialState<List<IncidentTypeModel>>()));

class IncidentTypeController
    extends StateNotifier<GenericState<List<IncidentTypeModel>>> {
  IncidentTypeController(super.state);

  final ApiClient _apiClient = ApiClient.instance;

  Future<void> fetchIncidentTypes() async {
    try {
      await Future.delayed(Duration.zero);
      state = LoadingState<List<IncidentTypeModel>>();
      final Response response = await _apiClient.request(
        url: ApiUrls.incidentTypes,
        requestType: RequestType.get,
      );
      if ((response.statusCode ?? 404) >= 200 &&
          (response.statusCode ?? 404) <= 299) {
        final List<IncidentTypeModel> incidentTypeList =
            IncidentTypeModel.listFromJson(response.data);
        state = SuccessState(data: incidentTypeList);
      }
    } catch (e, s) {
      state = ErrorState<List<IncidentTypeModel>>(
        error: e.toString(),
        stackTrace: s,
      );
    }
  }
}

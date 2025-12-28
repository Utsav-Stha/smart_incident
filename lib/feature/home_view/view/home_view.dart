import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_incident/feature/common/constants/app_colors.dart';
import 'package:smart_incident/feature/common/widgets/generic_elevated_button.dart';
import 'package:smart_incident/feature/home_view/controller/home_controller.dart';
import 'package:smart_incident/feature/home_view/view/widgets/incident_card.dart';
import 'package:smart_incident/feature/incident_form/model/incident_model.dart';
import 'package:smart_incident/utils/app_routing/app_routes.dart';
import 'package:smart_incident/utils/state_management/generic_state_handler.dart';

class HomeView extends ConsumerStatefulWidget {
  static const String homeViewRoute = "/homeViewRoute";

  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    ref.read(homeController.notifier).fetchIncidentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyShade100,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: AppColors.blue,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 20.r),
              decoration: BoxDecoration(color: AppColors.blue),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 30.r,
                    child: Icon(Icons.person, color: AppColors.grey),
                  ),
                ],
              ),
            ),
            GenericStateHandler<List<IncidentModel>>(
              state: ref.watch(homeController),
              onLoaded: (dataList) {
                return Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(10.r, 20.r, 10.r, 80.r),
                    itemBuilder: (context, index) {
                      final IncidentModel data = dataList[index];
                      return IncidentCard(data: data);
                    },
                    separatorBuilder: (context, index) => 10.verticalSpace,
                    itemCount: dataList.length,
                  ),
                );
              },
              onEmpty: (_) => Text("No data"),
              onError: () => Text("Error"),
              onLoading: () =>
                  Expanded(child: Center(child: CircularProgressIndicator())),
            ),
          ],
        ),
      ),
      floatingActionButton: GenericElevatedButton(
        width: 150.r,
        borderRadius: 10.r,
        height: 50.r,
        text: "Add Incident",
        onPressed: () =>
            // ref.read(homeController.notifier).fetchIncidentList()
            Beamer.of(context).beamToNamed(AppRoutes.incidentFormRoute),
      ),
    );
  }
}

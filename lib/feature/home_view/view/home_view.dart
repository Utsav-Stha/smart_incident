import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_incident/feature/common/constants/app_colors.dart';
import 'package:smart_incident/feature/common/widgets/animated_empty_state.dart';
import 'package:smart_incident/feature/common/widgets/generic_elevated_button.dart';
import 'package:smart_incident/feature/home_view/controller/home_controller.dart';
import 'package:smart_incident/feature/home_view/view/widgets/incident_card.dart';
import 'package:smart_incident/feature/home_view/view/edit_incident_screen.dart';
import 'package:smart_incident/feature/incident_form/model/incident_model.dart';
import 'package:smart_incident/utils/app_routing/app_routes.dart';
import 'package:smart_incident/utils/state_management/generic_state_handler.dart';

import 'package:smart_incident/feature/profile/controller/profile_controller.dart';
import 'package:smart_incident/feature/profile/model/user_model.dart';
import 'package:smart_incident/utils/state_management/generic_state.dart';
import 'package:smart_incident/feature/common/constants/style_constants.dart';

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
    ref.read(profileController.notifier).fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileController);
    String userName = "User";
    String userEmail = "";

    if (profileState is SuccessState<UserModel>) {
      userName = profileState.data.name ?? "User";
      userEmail = profileState.data.email ?? "";
    }

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
              child: InkWell(
                onTap: () {
                  Beamer.of(context).beamToNamed(AppRoutes.profileViewRoute);
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.white,
                      radius: 30.r,
                      child: Icon(Icons.person, color: AppColors.grey),
                    ),
                    10.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName, style: StyleConstant.white600SemiBold16),
                        Text(userEmail, style: StyleConstant.white500Regular14),
                      ],
                    ),
                  ],
                ),
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
                      return InkWell(
                        onTap: () {
                          Beamer.of(context).beamToNamed(
                            AppRoutes.editIncidentScreenRoute,
                            data: data,
                          );
                        },
                        child: IncidentCard(data: data),
                      );
                    },
                    separatorBuilder: (context, index) => 10.verticalSpace,
                    itemCount: dataList.length,
                  ),
                );
              },
              onEmpty: (_) => Expanded(
                child: AnimatedEmptyState(
                  titleMessage: "There are no incident reports at the moment",
                  subTitleMessage: "\nAdd a new incident",
                ),
              ),
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
            Beamer.of(context).beamToNamed(AppRoutes.incidentFormRoute),
      ),
    );
  }
}

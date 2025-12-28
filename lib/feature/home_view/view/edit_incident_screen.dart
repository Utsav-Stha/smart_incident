import 'package:beamer/beamer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_incident/feature/common/constants/app_colors.dart';
import 'package:smart_incident/feature/common/constants/style_constants.dart';
import 'package:smart_incident/feature/common/enum/priority_status.dart';
import 'package:smart_incident/feature/common/widgets/custom_multi_line_text_form_field.dart';
import 'package:smart_incident/feature/common/widgets/custom_text_field.dart';
import 'package:smart_incident/feature/common/widgets/generic_elevated_button.dart';
import 'package:smart_incident/feature/home_view/controller/delete_incident_controller.dart';
import 'package:smart_incident/feature/home_view/controller/edit_incident_controller.dart';
import 'package:smart_incident/feature/home_view/controller/home_controller.dart';
import 'package:smart_incident/feature/incident_form/controller/incident_type_controller.dart';
import 'package:smart_incident/feature/incident_form/model/incident_model.dart';
import 'package:smart_incident/feature/incident_form/model/incident_type_model.dart';
import 'package:smart_incident/feature/incident_form/view/widgets/priority_status_tab.dart';
import 'package:smart_incident/utils/state_management/generic_state.dart';
import 'package:smart_incident/utils/state_management/generic_state_handler.dart';

class EditIncidentScreen extends ConsumerStatefulWidget {
  static const String editIncidentScreenRoute = "/editIncidentScreenRoute";
  final IncidentModel incident;

  const EditIncidentScreen({super.key, required this.incident});

  @override
  ConsumerState<EditIncidentScreen> createState() => _EditIncidentScreenState();
}

class _EditIncidentScreenState extends ConsumerState<EditIncidentScreen> {
  IncidentTypeModel? incidentTypeModel;

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late ValueNotifier<PriorityStatus> statusNotifier;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.incident.title);
    _descriptionController = TextEditingController(
      text: widget.incident.description,
    );
    statusNotifier = ValueNotifier(widget.incident.priority);
    ref.read(incidentTypeController.notifier).fetchIncidentTypes();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(editIncidentController, (previous, next) {
      if (next case SuccessState()) {
        ref.read(homeController.notifier).fetchIncidentList();
        Beamer.of(context).beamBack();
      }
    });

    ref.listen(deleteIncidentController, (previous, next) {
      if (next case SuccessState()) {
        ref.read(homeController.notifier).fetchIncidentList();
        while (Beamer.of(context).canBeamBack) {
          Beamer.of(context).beamBack();
        }
      }
    });

    final incidentTypeProvider = ref.watch(incidentTypeController);

    return Scaffold(
      backgroundColor: AppColors.greyShade100,
      appBar: AppBar(
        backgroundColor: AppColors.lightBlue,
        leading: InkWell(
          onTap: () => Beamer.of(context).beamBack(),
          splashFactory: NoSplash.splashFactory,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.grey,
            size: 30.r,
          ),
        ),
        centerTitle: true,
        title: Text("Edit Incident", style: StyleConstant.black500Regular18),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete Incident"),
                  content: Text(
                    "Are you sure you want to delete this incident?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("No"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref
                            .read(deleteIncidentController.notifier)
                            .deleteIncident(
                              createdDate: widget.incident.createdDate,
                            );
                      },
                      child: Text("Yes"),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.delete, color: AppColors.red),
          ),
        ],
      ),
      body: Form(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 20.r),
          children: [
            CustomTextField(
              title: "Title",
              hintText: "Enter title",
              controller: _titleController,
            ),
            10.verticalSpace,
            Row(
              children: [
                Text("Incident Type", style: StyleConstant.black500Regular16),
                5.horizontalSpace,
                Text("*", style: StyleConstant.red600Regular15),
              ],
            ),
            5.verticalSpace,
            GenericStateHandler<List<IncidentTypeModel>>(
              state: incidentTypeProvider,
              onLoading: () => Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.white,
                  border: Border.all(color: AppColors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Fetching incident types...",
                      style: StyleConstant.grey500Regular16,
                    ),
                    SizedBox(
                      height: 25.r,
                      width: 25.r,
                      child: CircularProgressIndicator(strokeWidth: 3.r),
                    ),
                  ],
                ),
              ),
              onLoaded: (dataList) {
                try {
                  incidentTypeModel = dataList.firstWhere(
                    (element) => element.name == widget.incident.incidentTypes,
                  );
                } catch (e) {
                  incidentTypeModel = dataList.firstOrNull;
                }

                return DropdownSearch<IncidentTypeModel>(
                  selectedItem: incidentTypeModel,
                  items: (filter, infiniteScrollProps) => dataList,
                  compareFn: (item1, item2) {
                    return item1.id == item2.id;
                  },
                  itemAsString: (item) {
                    return item.name;
                  },
                  validator: (value) {
                    return null;
                  },
                  onChanged: (value) {
                    incidentTypeModel = value;
                  },
                  decoratorProps: DropDownDecoratorProps(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      fillColor: AppColors.white,
                      focusColor: AppColors.red,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10.r,
                        vertical: 10.r,
                      ),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    fit: FlexFit.loose,
                    constraints: BoxConstraints(maxHeight: 300.h),
                    menuProps: MenuProps(
                      backgroundColor: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                );
              },
              onEmpty: (_) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Fetching incident types",
                      style: StyleConstant.black500Regular18,
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
              onError: () => InkWell(
                onTap: () => ref
                    .read(incidentTypeController.notifier)
                    .fetchIncidentTypes(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: AppColors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Please try again"),
                      Icon(Icons.refresh_rounded),
                    ],
                  ),
                ),
              ),
            ),
            10.verticalSpace,
            CustomMultiLineTextFormField(
              height: 200.h,
              editable: true,
              title: "Description",
              hintText: "Enter description of incident",
              controller: _descriptionController,
            ),
            10.verticalSpace,
            ValueListenableBuilder(
              valueListenable: statusNotifier,
              builder: (context, value, child) => PriorityStatusTab(
                status: value,
                onTap: (value) {
                  statusNotifier.value = value;
                },
              ),
            ),
            10.verticalSpace,
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.r, 0, 10.r, 20.r),
          child: GenericElevatedButton(
            text: "Update",
            isLoading: ref.watch(editIncidentController) is LoadingState,
            onPressed: () {
              ref
                  .read(editIncidentController.notifier)
                  .editIncident(
                    title: _titleController.text,
                    incidentType: incidentTypeModel?.name ?? '',
                    description: _descriptionController.text,
                    priority: statusNotifier.value,
                    createdDate: widget.incident.createdDate,
                  );
            },
          ),
        ),
      ),
    );
  }
}

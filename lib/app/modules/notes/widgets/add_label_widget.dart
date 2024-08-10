import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/modules/notes/controllers/labels_controller.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/extensions.dart';
import 'package:notes_final_version/app/utils/widgets/gradient_Button.dart';

class AddLabelBottomSheet extends StatelessWidget {
  AddLabelBottomSheet({
    super.key,
  });
  NotesController notesController = Get.find();
  LabelsController labelsController = Get.find();

  // FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset: const Offset(0.0, -2.0),
              blurRadius: 4.0,
            ),
          ],
          // borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: 16.0,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Label',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: ColorHelper.blackColor),
                    ),
                  )
                ],
              ),
              Divider(
                thickness: 2,
                color: ColorHelper.primaryColor,
              ),
              20.spaceY,
              SizedBox(
                width: Get.width,
                height: 40,
                child: StatefulBuilder(builder: (context, setstate) {
                  return Obx(() {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: labelsController.labelsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          padding: const EdgeInsets.only(
                            right: 12,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: notesController.labels.contains(
                                      labelsController.labelsList[index]!.name)
                                  ? ColorHelper.primaryColor
                                  : ColorHelper.whiteColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black)),
                          child: InkWell(
                            onTap: notesController.labels.contains(
                                    labelsController.labelsList[index]!.name)
                                ? () {
                                    notesController.labels.remove(
                                        labelsController
                                            .labelsList[index]!.name);
                                    notesController.labels.refresh();
                                    setstate(() {});
                                  }
                                : () {
                                    notesController.labels.add(labelsController
                                        .labelsList[index]!.name);
                                    notesController.labels.refresh();
                                    setstate(() {});
                                  },
                            child: Row(
                              children: [
                                CircleAvatar(
                                    radius: 16,
                                    backgroundColor: ColorHelper.primaryColor,
                                    child: notesController.labels.contains(
                                            labelsController
                                                .labelsList[index]!.name)
                                        ? CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                ColorHelper.primaryColor,
                                            child: const Icon(Icons.done),
                                          )
                                        : Text(labelsController
                                            .labelsList[index]!.name[0]
                                            .toString())),
                                5.spaceX,
                                Text(labelsController.labelsList[index]!.name),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  });
                }),
              ),
              20.spaceY,
              GradientButton(
                  text: "Done",
                  icon: null,
                  onPress: () {
                    Get.back();
                  }),
              20.spaceY,
            ],
          ),
        ),
      ),
    );
  }
}

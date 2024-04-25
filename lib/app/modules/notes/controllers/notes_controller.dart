import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as editor;
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:notes_final_version/app/modules/auth/controllers/auth_controller.dart';
import 'package:notes_final_version/app/modules/auth/models/user_model.dart';
import 'package:notes_final_version/app/modules/notes/models/notes_model.dart';
import 'package:notes_final_version/app/routes/app_pages.dart';
import 'package:notes_final_version/app/utils/utils.dart';

import '../../auth/services/encryptor_controller/encryptor_controller.dart';
import '../models/note_plaintext_model.dart';

class NotesController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final EncryptionController _encryptorController =
      Get.find<EncryptionController>();

  RxList<NoteModel?> notesList = <NoteModel>[].obs;
  RxList<NoteModel?> searchedNotesList = <NoteModel>[].obs;
  RxList<NoteModel?> archivedNotesList = <NoteModel>[].obs;
  RxList<NoteModel?> pinnedNotesList = <NoteModel>[].obs;

  RxList<String> labels = <String>[].obs;
  final box = GetStorage();
  final editorFocusNode = FocusNode().obs;
  final editorScrollController = ScrollController().obs;

  final editor.QuillController quillController = editor.QuillController.basic();
  final TextEditingController titleController = TextEditingController();
  final masterPasswordController = TextEditingController();
  final masterPasswordRecoveryController = TextEditingController();

  Rx<TextEditingController> searchController = TextEditingController().obs;
  ValueNotifier<String> selectedFolder = ValueNotifier('Notes');
  RxString appLanguage = 'EN'.obs;

  RxBool showFolders = true.obs;
  RxBool useLocalAuth = true.obs;

  // It is used only for if user want to recover master password
  RxBool showMasterPasswordForRecovery = false.obs;

  RxBool alwaysRequireMasterPassword = true.obs;

  /// This flag is used to check if user provided master for first time or not.
  /// by default it will be false, and become true if [alwaysRequireMasterPassword]
  /// is false and user provided master password while decrypting first note
  RxBool masterPasswordAsked = false.obs;

  RxString selectedFilter = 'Title'.obs;

  final notesBox = Hive.box<NoteModel>('notes');

  final zoomDrawerController = ZoomDrawerController();

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
    update();
  }

  void addUpdateNote(NoteModel newNote,
      {String? folderName, String? labelName}) async {
    bool found = false;
    int index = 0;

    List<NoteModel?> notesData = notesBox.keys.map((key) {
      final value = notesBox.get(key);
      return value;
    }).toList();

    if (notesData.isNotEmpty) {
      for (int i = 0; i < notesData.length; i++) {
        if (notesData[i]!.uid.toString() == newNote.uid) {
          found = true;
          index = i;
        }
      }
    }
    if (found == false) {
      await addNote(newNote, folderName: folderName, labelName: labelName);
    } else {
      await updateNote(index, newNote,
          folderName: folderName, labelName: labelName);
    }
  }

  List<NoteModel?> getAllNotes({String? folderName, String? labelName}) {
    final notesList = notesBox.keys
        .map((key) {
          final value = notesBox.get(key);
          return value;
        })
        .where((element) => element!.isArchived == false)
        .toList();

    // Sort the list with pinned notes on top
    notesList.sort((a, b) {
      if (a!.isPinned && !b!.isPinned) {
        return -1; // 'a' comes before 'b'
      } else if (!a.isPinned && b!.isPinned) {
        return 1; // 'b' comes before 'a'
      } else {
        return 0; // No change in order
      }
    });
    if (folderName != null) {
      return notesList
          .where((element) =>
              element!.folder.toLowerCase() == folderName.toLowerCase())
          .toList();
    }
    if (labelName != null) {
      return notesList
          .where((element) => element!.labels.contains(labelName))
          .toList();
    }
    return notesList;
  }

  List<NoteModel?> getArchivedNotes() {
    final notesList = notesBox.keys
        .map((key) {
          final value = notesBox.get(key);
          return value;
        })
        .where((element) => element!.isArchived == true)
        .toList();

    return notesList;
  }

  List<NoteModel?> getPinnedNotes() {
    final notesList = notesBox.keys
        .map((key) {
          final value = notesBox.get(key);
          return value;
        })
        .where((element) => element!.isPinned == true)
        .toList();

    return notesList;
  }

  Future<void> addNote(NoteModel newItem,
      {String? folderName, String? labelName}) async {
    await notesBox.add(newItem);

    notesList.value = getAllNotes(folderName: folderName, labelName: labelName)
        .where((note) => note != null)
        .cast<NoteModel>()
        .toList();
    archivedNotesList.value = getArchivedNotes()
        .where((note) => note != null)
        .cast<NoteModel>()
        .toList();
  }

  Future<void> updateNote(int index, NoteModel updateItem,
      {String? folderName, String? labelName}) async {
    await notesBox.putAt(index, updateItem);

    notesList.value = getAllNotes(folderName: folderName, labelName: labelName)
        .where((note) => note != null)
        .cast<NoteModel>()
        .toList();
    archivedNotesList.value = getArchivedNotes()
        .where((note) => note != null)
        .cast<NoteModel>()
        .toList();
  }

  void searchNotes(String value) {
    if (selectedFilter.value == "Title") {
      searchedNotesList.value = notesList.value
          .where(
              (note) => note!.title.toLowerCase().contains(value.toLowerCase()))
          .cast<NoteModel>()
          .toList();
    } else if (selectedFilter.value == "Folder") {
      searchedNotesList.value = notesList.value
          .where((note) =>
              note!.folder.toLowerCase().contains(value.toLowerCase()))
          .cast<NoteModel>()
          .toList();
    } else if (selectedFilter.value == "Label") {
      searchedNotesList.value = notesList.value
          .where((note) => note!.labels.contains(value.toLowerCase()))
          .cast<NoteModel>()
          .toList();
    } else {
      searchedNotesList.value = notesList.value
          .where((note) => note!.searchableDocument
              .toLowerCase()
              .contains(value.toLowerCase()))
          .cast<NoteModel>()
          .toList();
    }
  }

  // Delete a single item
  Future<void> deleteNote(String uid,
      {String? folderName, String? labelName}) async {
    List<NoteModel?> notesData = notesBox.keys.map((key) {
      final value = notesBox.get(key);
      return value;
    }).toList();

    if (notesData.isNotEmpty) {
      for (int i = 0; i < notesData.length; i++) {
        if (notesData[i]!.uid.toString() == uid) {
          await notesBox.deleteAt(i);
          notesList.value =
              getAllNotes(folderName: folderName, labelName: labelName)
                  .where((note) => note != null)
                  .cast<NoteModel>()
                  .toList();
          notesList.refresh();
          return;
        }
      }
    }
  }

  // Retrieve a single item from the database by using its key
  NoteModel? readItem(int key) {
    final item = notesBox.get(key);
    return item;
  }

  @override
  void onReady() {
    notesList.value =
        getAllNotes().where((note) => note != null).cast<NoteModel>().toList();
    archivedNotesList.value = getArchivedNotes()
        .where((note) => note != null)
        .cast<NoteModel>()
        .toList();
    pinnedNotesList.value = getPinnedNotes()
        .where((note) => note != null)
        .cast<NoteModel>()
        .toList();
    showFolders.value = box.read("showFolders") ?? true;
    box.listenKey('showFolders', (value) {
      if (value == false) {
        notesList.value = getAllNotes()
            .where((note) => note != null)
            .cast<NoteModel>()
            .toList();
      }
    });
    canUseLocalAuth();
    super.onReady();
  }

  // ************ Encryption related functions ************

  Future<UserModel?> verifyUserLoggedIn() async {
    try {
      MyDialogs.showLoadingDialog(message: "Authenticating ");

      //  Check user session
      UserModel? userModel = await _authController.checkUserExist();
      // logInfo("userModel: ${userModel?.encryptionKey}");
      await HelperFunction.giveDelay();
      MyDialogs.closeDialog();

      return userModel;
    } catch (e) {
      logError("verifyUserLoggedIn error: $e");

      await HelperFunction.giveDelay();
      MyDialogs.closeDialog();
      rethrow;
    }
  }

  Future<bool> verifyMasterPassword(UserModel userModel) async {
    masterPasswordController.clear();
    print("before: ${DateTime.now()}");
    _authController.canAuthenticateLocally();
    print("after: ${DateTime.now()}");

    bool? isCancelled =
        await HelperFunction.showMasterPasswordInputSheet(userModel);
    if (isCancelled != null && isCancelled) {
      logSuccess("Close button pressed");
      return true;
    } else {
      logSuccess("Close button not pressed");
    }

    return false;
  }

  Future<String?> performDecryption(
      {required NoteModel noteData,
      bool updateNoteInstance = false,
      String? folderName}) async {
    try {
      UserModel? userModel = await verifyUserLoggedIn();
      if (userModel != null) {
        if (alwaysRequireMasterPassword.value) {
          bool canDecrypt = await verifyMasterPassword(userModel);
          if (!canDecrypt) return null;
        } else if (masterPasswordAsked.value == false) {
          bool canDecrypt = await verifyMasterPassword(userModel);
          if (!canDecrypt) return null;
        }

        logSuccess("Start decryption");

        await HelperFunction.giveDelay();
        MyDialogs.showLoadingDialog(message: "Decrypting note ");
        String decryptedData =
            await decryptData(noteData.document, userModel.encryptionKey!);

        if (updateNoteInstance) {
          String decryptedPlainText = await decryptData(
              noteData.searchableDocument, userModel.encryptionKey!);
          noteData.encrypted = false;
          noteData.document = decryptedData;
          noteData.searchableDocument = decryptedPlainText;
          addUpdateNote(noteData, folderName: folderName);
        }

        await HelperFunction.giveDelay();
        MyDialogs.closeDialog();

        return decryptedData;

        // await HelperFunction.giveDelay();
        // MyDialogs.showMessageDialog(
        //     title: "Success", description: "Notes decrypted");
      } else {
        await authenticateUser();
      }
    } catch (e) {
      logError("Error in verifyAuthBeforeEncryption: $e");
      MyDialogs.closeDialog();

      await HelperFunction.giveDelay();
      MyDialogs.showMessageDialog(
          title: "Error",
          description: "There is some error, please try again later.");
    }
    return null;
  }

  performEncryption(NoteModel noteData, {String? folderName}) async {
    try {
      UserModel? userModel = await verifyUserLoggedIn();
      if (userModel != null) {
        await HelperFunction.giveDelay();
        MyDialogs.showLoadingDialog(message: "Encrypting note ");

        String encryptedData =
            await encryptData(noteData.document, userModel.encryptionKey!);
        String encryptedPlainText = await encryptData(
            noteData.searchableDocument, userModel.encryptionKey!);

        noteData.encrypted = true;
        noteData.document = encryptedData;
        noteData.searchableDocument = encryptedPlainText;
        addUpdateNote(noteData, folderName: folderName);

        await HelperFunction.giveDelay();
        MyDialogs.closeDialog();

        await HelperFunction.giveDelay();
        MyDialogs.showMessageDialog(
            title: "Success", description: "Notes encrypted");
      } else {
        await authenticateUser();
      }
    } catch (e) {
      logError("Error in verifyAuthBeforeEncryption: $e");
      MyDialogs.closeDialog();

      await HelperFunction.giveDelay();
      MyDialogs.showMessageDialog(
          title: "Error",
          description: "There is some error, please try again later.");
    }
  }

  Future<NotePlaintextModel?> encryptNoteBeforeSaving(
      String noteData, String plainText) async {
    try {
      await HelperFunction.giveDelay();
      MyDialogs.showLoadingDialog(message: "Saving ");

      UserModel? userModel = await _authController.checkUserExist();

      if (userModel != null) {
        String encryptedData =
            await encryptData(noteData, userModel.encryptionKey!);
        String encryptedPlaintext =
            await encryptData(plainText, userModel.encryptionKey!);
        NotePlaintextModel encText = NotePlaintextModel(
            note: encryptedData, plaintext: encryptedPlaintext);

        await HelperFunction.giveDelay();
        MyDialogs.closeDialog();

        return encText;
      } else {
        await HelperFunction.giveDelay();
        MyDialogs.closeDialog();
        await authenticateUser();
      }
    } catch (e) {
      await HelperFunction.giveDelay();
      MyDialogs.closeDialog();
      logError("Error in verifyAuthBeforeEncryption: $e");
      MyDialogs.closeDialog();

      await HelperFunction.giveDelay();
      MyDialogs.showMessageDialog(
          title: "Error",
          description: "There is some error, please try again later.");
    }
    return null;
  }

  authenticateUser() async {
    try {
      await HelperFunction.giveDelay();
      MyDialogs.showMessageDialog(
          title: "Authentication required",
          description: "You are not logged in, please login.",
          onConfirm: () {
            Get.back();
            Get.toNamed(Routes.AUTH);
          });
    } catch (e) {
      await HelperFunction.giveDelay();
      MyDialogs.closeDialog();
      rethrow;
    }
  }

  Future<String> encryptData(String noteData, String encryptionKey) async {
    try {
      // encryptorController.checkPathExist();
      _encryptorController.initializeEncryptorInstance(encryptionKey);
      await HelperFunction.giveDelay();

      String encryptedData = await _encryptorController.encryptSalsa(noteData);
      return encryptedData;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> decryptData(String noteData, String encryptionKey) async {
    try {
      // encryptorController.checkPathExist();
      _encryptorController.initializeEncryptorInstance(encryptionKey);
      await HelperFunction.giveDelay();

      String decryptedData = await _encryptorController.decryptSalsa(noteData);
      // noteData.encrypted = true;
      return decryptedData;
      // noteData.document = decryptedData;
      // addUpdateNote(noteData, folderName: folderName);
    } catch (e) {
      rethrow;
    }
  }

  // /6YsngWEINmimkXjhJUtHXJSCHFpaxCqLpJpon0PICcApkI=

  // ******************************************************

  bool canAuthenticate() {
    return _authController.canAuthenticate.value;
  }

  Future<bool> authWithBiometric() {
    try {
      return _authController.authWithBiometric();
    } catch (e) {
      rethrow;
    }
  }

  canUseLocalAuth() async {
    useLocalAuth.value = await _authController.canUseLocalAuth();
  }

  Future<void> setLocalAuth(bool value) async {
    await _authController.setLocalAuth(value);
  }

  @override
  void dispose() {
    quillController.dispose();
    titleController.dispose();
    searchController.value.dispose();
    super.dispose();
  }
}

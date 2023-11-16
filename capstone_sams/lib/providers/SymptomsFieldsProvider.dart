import 'package:flutter/material.dart';

class SymptomFieldsProvider extends ChangeNotifier {
  List<Widget> _autocompleteFields = [];
  List<TextEditingController> _textControllers = [];
  List<String> _symptoms = [];

  List<Widget> get autocompleteFields => _autocompleteFields;
  List<TextEditingController> get textControllers => _textControllers;
  List<String> get symptoms => _symptoms;

  void addSymptomField(Widget field) {
    var textController = TextEditingController();
    _textControllers.add(textController);
    _autocompleteFields.add(field);
    notifyListeners();
  }

  void removeSymptomField(int index) {
    _autocompleteFields.removeAt(index);
    _textControllers.removeAt(index);
    notifyListeners();
  }

  void addSymptom(String symptom, BuildContext context) {
    if (!_symptoms.contains(symptom)) {
      _symptoms.add(symptom);
      notifyListeners();
    } else {
      // Show an error message as a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Symptom "$symptom" is already added.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void removeSymptom(String symptom) {
    _symptoms.remove(symptom);
    notifyListeners();
  }

  void reset() {
    _autocompleteFields.clear();
    _textControllers.clear();
    _symptoms.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void resetState() {
    Future.delayed(Duration.zero, () {
      symptoms.clear();
      autocompleteFields.clear();
      notifyListeners();
    });
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:recetasapp/helpers/constants.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recetasapp/components/loader_component.dart';

import 'package:recetasapp/helpers/api_helper.dart';
import 'package:recetasapp/models/response.dart';
import 'package:recetasapp/screens/take_picture_screen.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  bool _showLoader = false;
  bool _photoChanged = false;
  late XFile _image;

  String _firstName = '';
  String _firstNameError = '';
  bool _firstNameShowError = false;
  TextEditingController _firstNameController = TextEditingController();

  String _lastName = '';
  String _lastNameError = '';
  bool _lastNameShowError = false;
  TextEditingController _lastNameController = TextEditingController();

  String _document = '';
  String _documentError = '';
  bool _documentShowError = false;
  TextEditingController _documentController = TextEditingController();

  String _address1 = '';
  String _address1Error = '';
  bool _address1ShowError = false;
  TextEditingController _address1Controller = TextEditingController();

  String _address2 = '';
  String _address2Error = '';
  bool _address2ShowError = false;
  TextEditingController _address2Controller = TextEditingController();

  String _address3 = '';
  String _address3Error = '';
  bool _address3ShowError = false;
  TextEditingController _address3Controller = TextEditingController();

  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;
  TextEditingController _emailController = TextEditingController();

  String _phoneNumber = '';
  String _phoneNumberError = '';
  bool _phoneNumberShowError = false;
  TextEditingController _phoneNumberController = TextEditingController();

  bool _passwordShow = false;

  String _password = '';
  String _passwordError = '';
  bool _passwordShowError = false;
  TextEditingController _passwordController = TextEditingController();

  String _confirm = '';
  String _confirmError = '';
  bool _confirmShowError = false;
  TextEditingController _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nuevo Usuario'),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _showPhoto(),
                  _showFirstName(),
                  _showLastName(),
                  _showDocument(),
                  _showEmail(),
                  _showPassword(),
                  _showConfirm(),
                  _showButtons(),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            _showLoader
                ? LoaderComponent(
                    text: 'Por favor espere...',
                  )
                : Container(),
          ],
        ));
  }

  Widget _showPhoto() {
    return InkWell(
      child: Stack(children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10),
          child: !_photoChanged
              ? Image(
                  image: AssetImage('assets/noimage.png'),
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: Image.file(
                    File(_image.path),
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  )),
        ),
        Positioned(
            bottom: 0,
            left: 100,
            child: InkWell(
              onTap: () => _takePicture(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: Colors.green[50],
                  height: 60,
                  width: 60,
                  child: Icon(
                    Icons.photo_camera,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
              ),
            )),
        Positioned(
            bottom: 0,
            left: 0,
            child: InkWell(
              onTap: () => _selectPicture(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: Colors.green[50],
                  height: 60,
                  width: 60,
                  child: Icon(
                    Icons.image,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
              ),
            )),
      ]),
    );
  }

  Widget _showFirstName() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _firstNameController,
        decoration: InputDecoration(
            hintText: 'Ingresa nombres...',
            labelText: 'Nombres',
            errorText: _firstNameShowError ? _firstNameError : null,
            suffixIcon: Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _firstName = value;
        },
      ),
    );
  }

  Widget _showLastName() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _lastNameController,
        decoration: InputDecoration(
            hintText: 'Ingresa nombres...',
            labelText: 'Apellido',
            errorText: _lastNameShowError ? _lastNameError : null,
            suffixIcon: Icon(Icons.person),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _lastName = value;
        },
      ),
    );
  }

  Widget _showDocument() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _documentController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Ingresa documento...',
            labelText: 'Documento',
            errorText: _documentShowError ? _documentError : null,
            suffixIcon: Icon(Icons.assignment_ind),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _document = value;
        },
      ),
    );
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Ingresa Email...',
            labelText: 'Email',
            errorText: _emailShowError ? _emailError : null,
            suffixIcon: Icon(Icons.email),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showPassword() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Ingresa una contrase??a...',
          labelText: 'Contrase??a',
          errorText: _passwordShowError ? _passwordError : null,
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: _passwordShow
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget _showConfirm() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        obscureText: !_passwordShow,
        decoration: InputDecoration(
          hintText: 'Ingresa la confirmaci??n de contrase??a...',
          labelText: 'Confirmaci??n de contrase??a',
          errorText: _confirmShowError ? _confirmError : null,
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: _passwordShow
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _passwordShow = !_passwordShow;
              });
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _confirm = value;
        },
      ),
    );
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showRegisterButton(),
        ],
      ),
    );
  }

  void _takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response1 = await showAlertDialog(
        context: context,
        title: 'Seleccionar c??mara',
        message: '??Qu?? c??mara desea utilizar?',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'Trasera'),
          AlertDialogAction(key: 'yes', label: 'Delantera'),
          AlertDialogAction(key: 'cancel', label: 'Cancelar'),
        ]);
    if (response1 == 'yes') {
      firstCamera = cameras.first;
    }
    if (response1 == 'no') {
      firstCamera = cameras.last;
    }

    if (response1 != 'cancel') {
      Response? response = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TakePictureScreen(
                    camera: firstCamera,
                  )));
      if (response != null) {
        setState(() {
          _photoChanged = true;
          _image = response.result;
        });
      }
    }
  }

  void _selectPicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photoChanged = true;
        _image = image;
      });
    }
  }

  Widget _showRegisterButton() {
    return Expanded(
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add),
            SizedBox(
              width: 15,
            ),
            Text('Registrar usuario'),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: Color(0xff01579b),
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () => _register(),
      ),
    );
  }

  void _register() async {
    if (!validateFields()) {
      return;
    }
    _addRecord();
  }

  bool validateFields() {
    bool isValid = true;

    if (_firstName.isEmpty) {
      isValid = false;
      _firstNameShowError = true;
      _firstNameError = 'Debes ingresar un nombre';
    } else {
      _firstNameShowError = false;
    }

    if (_lastName.isEmpty) {
      isValid = false;
      _lastNameShowError = true;
      _lastNameError = 'Debes ingresar un apellido';
    } else {
      _lastNameShowError = false;
    }

    if (_document.isEmpty) {
      isValid = false;
      _documentShowError = true;
      _documentError = 'Debes ingresar un documento';
    } else {
      _documentShowError = false;
    }

    if (_document.length < 6) {
      isValid = false;
      _documentShowError = true;
      _documentError = 'El documento debe tener al menos 6 d??gitos';
    }

    if (_document.length > 9) {
      isValid = false;
      _documentShowError = true;
      _documentError = 'El documento no puede tener m??s de 9 d??gitos';
    }

    if (_email.isEmpty) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar tu Email';
    } else if (!EmailValidator.validate(_email)) {
      isValid = false;
      _emailShowError = true;
      _emailError = 'Debes ingresar un Email v??lido';
    } else {
      _emailShowError = false;
    }

    if (_password.isEmpty) {
      isValid = false;
      _passwordShowError = true;
      _passwordError = 'Debes ingresar una contrase??a';
    } else {
      if (_password.length < 6) {
        isValid = false;
        _passwordShowError = true;
        _passwordError =
            'Debes ingresar una contrase??a de al menos 6 caracteres';
      } else {
        _passwordShowError = false;
      }
    }

    if (_confirm.isEmpty) {
      isValid = false;
      _confirmShowError = true;
      _confirmError = 'Debes ingresar una confirmaci??n de contrase??a';
    } else {
      if (_confirm.length < 6) {
        isValid = false;
        _confirmShowError = true;
        _confirmError =
            'Debes ingresar una Confirmaci??n de Contrase??a de al menos 6 caracteres';
      } else {
        _confirmShowError = false;
      }
    }

    if ((_password.length >= 6) &&
        (_confirm.length >= 6) &&
        (_confirm != _password)) {
      isValid = false;
      _passwordShowError = true;
      _confirmShowError = true;
      _passwordError = 'La contrase??a y la confirmaci??n no son iguales';
      _confirmError = 'La contrase??a y la confirmaci??n no son iguales';
    }

    setState(() {});

    return isValid;
  }

  void _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que est??s conectado a Internet',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    String base64image = '';
    if (_photoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64image = base64Encode(imageBytes);
    }

    Map<String, dynamic> request = {
      'firstName': PLMayusc(_firstName),
      'lastName': PLMayusc(_lastName),
      'document': _document,
      'email': _email,
      'userName': _email,
      'password': _password,
      'image': base64image,
    };

    Response response = await ApiHelper.postNoToken('/api/Account/', request);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    await showAlertDialog(
        context: context,
        title: 'Confirmaci??n',
        message:
            'Se ha enviado un correo con las instrucciones para activar el usuario. Por favor act??velo para poder ingresar a la Aplicaci??n. Luego ingrese a la Aplicaci??n e ingrese al menos una Direcci??n para completar el Proceso de Registro.',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: null, label: 'Aceptar'),
        ]);

    Navigator.pop(context, 'yes');
  }

  String PLMayusc(String string) {
    String name = '';
    bool isSpace = false;
    String letter = '';
    for (int i = 0; i < string.length; i++) {
      if (isSpace || i == 0) {
        letter = string[i].toUpperCase();
        isSpace = false;
      } else {
        letter = string[i].toLowerCase();
        isSpace = false;
      }

      if (string[i] == " ") {
        isSpace = true;
      } else {
        isSpace = false;
      }

      name = name + letter;
    }
    return name;
  }
}

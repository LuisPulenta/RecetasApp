import 'dart:convert';
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recetasapp/components/loader_component.dart';
import 'package:recetasapp/helpers/api_helper.dart';
import 'package:recetasapp/models/user.dart';
import 'package:recetasapp/models/response.dart';
import 'package:recetasapp/models/token.dart';
import 'package:recetasapp/screens/change_password_screen.dart';
import 'package:recetasapp/screens/take_picture_screen.dart';

class UserScreen extends StatefulWidget {
  final Token token;
  final User user;
  final bool myProfile;

  UserScreen(
      {required this.token, required this.user, required this.myProfile});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _showLoader = false;
  bool _photoChanged = false;
  bool _habilitaPosicion = false;
  int _option = 0;
  late XFile _image;
  late User _user;

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

  String _email = '';
  String _emailError = '';
  bool _emailShowError = false;
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _loadFieldValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFFFCC),
        appBar: AppBar(
          title: Text(_user.id.isEmpty ? 'Nuevo Usuario' : _user.fullName),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  _showPhoto(),
                  _showFirstName(),
                  _showLastName(),
                  _showDocument(),
                  _showEmail(),
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
    return Stack(children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 10),
        child: _user.id.isEmpty && !_photoChanged
            ? Image(
                image: AssetImage('assets/nouser.png'),
                width: 160,
                height: 160,
                fit: BoxFit.cover)
            : ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: _photoChanged
                    ? Image.file(File(_image.path),
                        width: 160, height: 160, fit: BoxFit.cover)
                    : CachedNetworkImage(
                        imageUrl: _user.imageFullPath,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 160,
                        width: 160,
                        placeholder: (context, url) => Image(
                          image: AssetImage('assets/logo.png'),
                          fit: BoxFit.cover,
                          height: 160,
                          width: 160,
                        ),
                      ),
              ),
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
                  color: Colors.black,
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
                  color: Colors.black,
                ),
              ),
            ),
          )),
    ]);
  }

  Widget _showFirstName() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _firstNameController,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
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
            fillColor: Colors.white,
            filled: true,
            hintText: 'Ingresa apellido...',
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
            fillColor: Colors.white,
            filled: true,
            enabled: false,
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
        enabled: _user.id.isEmpty,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            enabled: false,
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

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Guardar'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF120E43),
                minimumSize: Size(100, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () => _save(),
            ),
          ),
          _user.id.isEmpty
              ? Container()
              : SizedBox(
                  width: 20,
                ),
          _user.id.isEmpty
              ? Container()
              : widget.myProfile
                  ? Expanded(
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock),
                            SizedBox(
                              width: 15,
                            ),
                            Text('Contraseña'),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFB4161B),
                          minimumSize: Size(100, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () => _changePassword(),
                      ),
                    )
                  : Expanded(
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete),
                            SizedBox(
                              width: 15,
                            ),
                            Text('Borrar'),
                          ],
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            return Color(0xFFB4161B);
                          }),
                        ),
                        onPressed: () => _confirmDelete(),
                      ),
                    ),
        ],
      ),
    );
  }

  void _save() {
    if (!validateFields()) {
      return;
    }
    _user.id.isEmpty ? _addRecord() : _saveRecord();
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

    setState(() {});

    return isValid;
  }

  _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    String base64image = '';
    if (_photoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64image = base64Encode(imageBytes);
    }

    Map<String, dynamic> request = {
      'firstName': _firstName,
      'lastName': _lastName,
      'document': _document,
      'email': _email,
      'userName': _email,
      'image': base64image,
    };

    Response response =
        await ApiHelper.post('/api/Users/', request, widget.token);

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
    Navigator.pop(context, 'yes');
  }

  _saveRecord() async {
    setState(() {
      _showLoader = true;
    });

    String base64image = '';
    if (_photoChanged) {
      List<int> imageBytes = await _image.readAsBytes();
      base64image = base64Encode(imageBytes);
    }

    Map<String, dynamic> request = {
      'id': widget.user.id,
      'modulo': _user.modulo,
      'firstName': _firstName,
      'lastName': _lastName,
      'document': _document,
      'email': _email,
      'userName': _email,
      'image': base64image,
    };

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response =
        await ApiHelper.put('/api/Users/', _user.id, request, widget.token);

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
    Navigator.pop(context, 'yes');
  }

  void _confirmDelete() async {
    var response = await showAlertDialog(
        context: context,
        title: 'Confirmación',
        message: '¿Estás seguro de querer borrar el registro?',
        actions: <AlertDialogAction>[
          AlertDialogAction(key: 'no', label: 'No'),
          AlertDialogAction(key: 'yes', label: 'Sí'),
        ]);
    if (response == 'yes') {
      _deleteRecord();
    }
  }

  void _deleteRecord() async {
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
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response =
        await ApiHelper.delete('/api/Users/', _user.id, widget.token);

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
    Navigator.pop(context, '');
    Navigator.pop(context, 'yes');
  }

  void _takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    var firstCamera = cameras.first;
    var response1 = await showAlertDialog(
        context: context,
        title: 'Seleccionar cámara',
        message: '¿Qué cámara desea utilizar?',
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

  void _loadFieldValues() {
    _firstName = _user.firstName;
    _firstNameController.text = _firstName;

    _lastName = _user.lastName;
    _lastNameController.text = _lastName;

    _document = _user.document;
    _documentController.text = _document;

    _email = _user.email;
    _emailController.text = _email;
  }

  void _changePassword() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(
                  token: widget.token,
                )));
  }

  Future<Null> _getUser() async {
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
          message: 'Verifica que estés conectado a Internet',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = await ApiHelper.getUser(widget.token, _user.id);

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
    setState(() {
      _user = response.result;
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    var authMode = AuthMode.Login;
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AuthMode.Login == authMode ? 'Login' : 'Signup'),
      ),
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 80),
          height: deviceSize.height,
          width: deviceSize.width,
          child: AuthCard(),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'name': '',
    'email': '',
    'mobileno': '',
    'password': ''
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    // _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    print(_authData);
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password'], context);
        _errorMsg = Provider.of<Auth>(context, listen: false).errorMsg;
        if (_errorMsg != null) {
          setState(() {});
          return;
        }
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['name'],
            _authData['email'],
            _authData['mobileno'],
            _authData['password'],
            context);
        _errorMsg = Provider.of<Auth>(context, listen: false).errorMsg;
        if (_errorMsg != null) {
          setState(() {});
          return;
        }
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      print(error);
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: _authMode == AuthMode.Signup ? 320 : 260,
      // height: _heightAnimation.value.height,
      constraints:
          BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
      width: deviceSize.width * 0.75,
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _authMode == AuthMode.Signup
                ? TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter name";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['name'] = value;
                    },
                  )
                : Container(),
            TextFormField(
              decoration: InputDecoration(labelText: 'E-Mail'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value.isEmpty || !value.contains('@')) {
                  return 'Invalid email!';
                }
                return null;
              },
              onSaved: (value) {
                _authData['email'] = value;
              },
            ),
            _authMode == AuthMode.Signup
                ? TextFormField(
                    decoration: InputDecoration(labelText: 'Mobile'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty || value.length != 10) {
                        return 'Enter correct 10 digit mobile number!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['mobileno'] = value;
                    },
                  )
                : Container(),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value.isEmpty || value.length < 5) {
                  return 'Password is too short!';
                }
                return null;
              },
              onSaved: (value) {
                _authData['password'] = value;
              },
            ),
            AnimatedContainer(
              constraints: BoxConstraints(
                minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
              ),
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (_isLoading)
              CircularProgressIndicator()
            else
              RaisedButton(
                child: Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                onPressed: _submit,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).primaryTextTheme.button.color,
              ),
            FlatButton(
              child: Text(
                  '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
              onPressed: _switchAuthMode,
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textColor: Theme.of(context).accentColor,
            ),
            _errorMsg.isEmpty ? Container() : Text(_errorMsg)
          ],
        ),
      ),
    );
  }
}

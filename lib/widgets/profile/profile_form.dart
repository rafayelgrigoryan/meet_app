import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

import '../../services/profile_service.dart';
import '../../screens/profile/profile.dart';
import '../pickers/user_image_picker.dart';

class ProfileForm extends StatefulWidget {
  final bool firstTime;
  ProfileForm(this.firstTime);
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  var _isLoading = false;
  final format = DateFormat("yyyy-MM-dd");
  var loadedProfile = false;

  Profile _profile;
  var _profileService = ProfileService();

  File _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateBirthController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _aboutMeController = TextEditingController();
  TextEditingController _favouriteController = TextEditingController();
  TextEditingController _hobbiesController = TextEditingController();
  TextEditingController _musicController = TextEditingController();
  String _relationType;
  String _gender;
  String _interestedIn;

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    // call _profileService update or add.
    if (widget.firstTime) {
      await _profileService.addUserInfo(
        _image,
        _nameController.text,
        Timestamp.fromDate(DateTime.parse(_dateBirthController.text)),
        _addressController.text,
        _hobbiesController.text,
        _favouriteController.text,
        _musicController.text,
        _gender,
        _relationType,
        _aboutMeController.text,
        _interestedIn,
      );
    } else {
      print(_relationType);
      await _profileService.updateUserInfo(
        _nameController.text,
        Timestamp.fromDate(DateTime.parse(_dateBirthController.text)),
        _addressController.text,
        _hobbiesController.text,
        _favouriteController.text,
        _musicController.text,
        _gender,
        _relationType,
        _aboutMeController.text,
        _interestedIn,
      );
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void _pickImage(File img) {
    _image = img;
  }

  void setInitValues(Profile profile) {
    print(profile);
    if (!loadedProfile&& profile!=null) {
      _nameController.text = profile.name;
      _dateBirthController.text = profile.dateOfBirth.toDate().toString();
      _addressController.text = profile.address;
      _hobbiesController.text = profile.hobbie;
      _favouriteController.text = profile.favorites;
      _musicController.text = profile.music;
      _gender = profile.gender;
      _relationType = profile.relationType;
      _aboutMeController.text = profile.aboutMe;
      _interestedIn = profile.interested;
    }
    loadedProfile = true;
  }

  @override
  Widget build(BuildContext context) {
    // if (!widget.firstTime) {
    //   _profileService.getUserInfo().then((value) {
    //     _profile = value;
    //     print(_profile);
    //   });
    // }
    return FutureBuilder(
        future: _profileService.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.hasData && snapshot.data != null) {
            _profile = snapshot.data;
            setInitValues(_profile);
          }
          return Center(
            child: Card(
              margin: EdgeInsets.all(15),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: widget.firstTime
                            ? Text("Create Profile")
                            : Text("Update profile"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(),
                      if (!widget.firstTime)
                        CircleAvatar(
                          backgroundImage: NetworkImage(_profile.image),
                          radius: 60,
                        )
                      else
                        Center(
                          child: UserImagePicker(_pickImage),
                        ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please enter name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: DateTimeField(
                              format: format,
                              controller: _dateBirthController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Date Of Birth',
                              ),
                              validator: (DateTime value) {
                                if (value == null) {
                                  return 'Please enter Date Of Birth';
                                }
                                return null;
                              },
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _gender,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Choose some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Gender',
                              ),
                              items: [
                                'Male',
                                'Femal',
                              ]
                                  .map((label) => DropdownMenuItem(
                                        child: Text(label.toString()),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _gender = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              controller: _addressController,
                              keyboardType: TextInputType.name,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Where do you live',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _favouriteController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Favourite place in the city',
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              controller: _musicController,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'What kind of Music do you like?',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _hobbiesController,
                              keyboardType: TextInputType.name,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'What are your hobbies',
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _relationType,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Choose some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'What are you looking for',
                              ),
                              items: [
                                'Casual',
                                'New Friends',
                                'Short-term dating',
                                ' Long-term dating '
                              ]
                                  .map((label) => DropdownMenuItem(
                                        child: Text(label.toString()),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _relationType = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _aboutMeController,
                              autocorrect: true,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'About Me',
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _interestedIn,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Choose some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'I am interested in',
                              ),
                              items: ['Man', 'Woman']
                                  .map((label) => DropdownMenuItem(
                                        child: Text(label.toString()),
                                        value: label,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _interestedIn = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      if (!_isLoading)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              child: Text('Save'),
                              onPressed: _submitForm,
                            ),
                          ],
                        )
                      else
                        CircularProgressIndicator()
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class PostFormPage extends StatelessWidget {
  const PostFormPage({super.key, this.postId});

  final String? postId;

  @override
  Widget build(BuildContext context) {
    return Center();
  }
}

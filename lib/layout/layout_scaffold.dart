// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import 'package:test_sample/layout/widgets/app_bar.dart';

import '../themes/color_variables.dart';

export './widgets/app_bar.dart';

class LayoutScaffold extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final AppBarSettings? appBar;
  final PreferredSizeWidget? customAppBar;
  final int? currentChildPageIndex;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Function? refreshScaffold;
  final bool topSafeArea;
  final bool extendBodyBehindAppBar;

  LayoutScaffold({
    Key? key,
    required this.child,
    this.backgroundColor = ReplyColors.white,
    this.appBar,
    this.currentChildPageIndex,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.customAppBar,
    this.topSafeArea = true,
    this.refreshScaffold,
    this.extendBodyBehindAppBar = false,
  });

  @override
  State<LayoutScaffold> createState() => _LayoutScaffoldState();
}

class _LayoutScaffoldState extends State<LayoutScaffold> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    print(widget.refreshScaffold);
    print('s');
    return Scaffold(
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      bottomNavigationBar: widget.bottomNavigationBar,
      extendBody: true,
      key: widget.key,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation ??
          FloatingActionButtonLocation.endFloat,
      backgroundColor: widget.backgroundColor,
      appBar: widget.appBar != null
          ? MainAppBar(
              appBarSettings: widget.appBar!,
              pagePostiion: widget.currentChildPageIndex,
              refreshScaffold: widget.refreshScaffold,
            )
          : widget.customAppBar,
      body: SafeArea(
        top: widget.topSafeArea,
        child: widget.child,
      ),
    );
  }
}

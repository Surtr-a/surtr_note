import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surtr_note/modules/home/components/body.dart';
import 'package:surtr_note/routes/app_routes.dart';
import 'package:surtr_note/utils/utils.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final HomeController controller;
  late final AnimationController _animationController;
  late final Animation<Offset> _firstSlideAnimation;
  late final Animation<Offset> _secondSlideAnimation;
  late final Animation<double> _mainRotationAnimation;
  late final Animation<double> _firstRotationAnimation;
  late final Animation<double> _secondRotationAnimation;
  double _opacity = 0.0;
  bool _showMask = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _firstSlideAnimation = Tween(begin: Offset.zero, end: Offset(-.7, 0))
        .animate(_animationController);
    _secondSlideAnimation = Tween(begin: Offset.zero, end: Offset(-1.4, 0))
        .animate(_animationController);
    _mainRotationAnimation =
        Tween(begin: 0.0, end: -.125).animate(_animationController);
    _firstRotationAnimation =
        Tween(begin: 0.0, end: -1.0).animate(_animationController);
    _secondRotationAnimation =
        Tween(begin: 0.0, end: -2.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('SurtrNote'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                    onTap: () async {
                      await Get.toNamed(Routes.HISTORY);
                      controller.getList();
                    },
                    child: Icon(Icons.history)),
              )
            ],
          ),
          body: Body(),
        ),
        _mask,
        _floatingActionButtons
      ],
    );
  }

  void _show() {
    setState(() {
      _opacity = 1;
      _showMask = true;
    });
    _animationController.forward();
  }

  void _close() {
    _animationController.reverse();
    setState(() {
      _opacity = 0;
    });
  }

  Widget get _mask => _showMask
      ? AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(milliseconds: 200),
          child: GestureDetector(
            onTap: () {
              _close();
            },
            child: Container(
              color: Colors.black26,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          onEnd: () {
            if (_animationController.isCompleted) {
              _showMask = true;
            } else {
              _showMask = false;
            }
            setState(() {});
          },
        )
      : SizedBox.shrink();

  Widget get _floatingActionButtons => Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: SlideTransition(
              position: _secondSlideAnimation,
              child: RotationTransition(
                turns: _secondRotationAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: FloatingActionButton(
                    onPressed: () async {
                      _close();
                      var updated = await Get.toNamed(Routes.RECORD);
                      if (updated != null && updated == true) {
                        controller.getList();
                      }
                    },
                    heroTag: 'record',
                    elevation: _opacity == 0 ? 0 : null,
                    child: Icon(
                      Icons.mic,
                      color: Colors.white,
                    ),
                    backgroundColor: CustomColor.MBlue,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: SlideTransition(
              position: _firstSlideAnimation,
              child: RotationTransition(
                turns: _firstRotationAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: FloatingActionButton(
                    onPressed: () async {
                      _close();
                      var result = await Get.toNamed(Routes.INPUT);
                      if (result != null && result == true) {
                        controller.getList();
                      }
                    },
                    heroTag: 'input',
                    elevation: _opacity == 0 ? 0 : null,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    backgroundColor: CustomColor.MGreen,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: RotationTransition(
              turns: _mainRotationAnimation,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: FloatingActionButton(
                  onPressed: () {
                    if (_animationController.isCompleted) {
                      _close();
                    } else {
                      _show();
                    }
                  },
                  heroTag: 'main',
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: CustomColor.MPink,
                ),
              ),
            ),
          ),
        ],
      );
}

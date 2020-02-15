import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:nima/nima_actor.dart';
import 'package:flare_flutter/flare_actor.dart';

class RepairWallGame extends StatefulWidget {
  @override
  _RepairWallGameState createState() => _RepairWallGameState();
}

class _RepairWallGameState extends State<RepairWallGame>
    with TickerProviderStateMixin {
  int _wallHealth = 50;
  int _imageIndex = 0;

  bool _showLostScreen = false;

  Stopwatch _stopwatch;

  AnimationController _controllerPerson;
  AnimationController _controllerHealthBar;
  AnimationController _controllerHulk;
  AnimationController _controllerBusiness;

  Animation _personWalkToWallAnimation;
  Animation _businessmanWalktoWallAnimation;
  Animation _hulkWalkToWallAnimation;

  final Image imageBackground = Image.asset("assets/BG.png");
  final Image imageBushTriple = Image.asset("assets/Bush_triple.png");
  final Image imageCactusSplit = Image.asset("assets/Cactus_split.png");
  final Image imageCactusTall = Image.asset("assets/Cactus_tall.png");
  final Image imageSignArrow = Image.asset("assets/SignArrow.png");
  final Image imageSign = Image.asset("assets/Sign.png");
  final Image imageGrassBrown = Image.asset("assets/Grass_brown.png");
  final Image imageGrassGreen = Image.asset("assets/Grass_green.png");
  final Image imageSkeleton = Image.asset("assets/Skeleton.png");
  final Image imageStone = Image.asset("assets/Stone.png");
  final Image imageStoneBlock = Image.asset("assets/StoneBlock.png");
  final Image imageStoneWallBlock = Image.asset(
    "assets/StoneBlock.png",
    color: Colors.brown,
    colorBlendMode: BlendMode.softLight,
  );
  final Image imageWallStoneBlock = Image.asset(
    "assets/StoneBlock.png",
    color: Colors.green,
    colorBlendMode: BlendMode.softLight,
  );
  final Image imageWallStone = Image.asset(
    "assets/Stone.png",
    color: Colors.green,
    colorBlendMode: BlendMode.softLight,
  );
  final Image imageWallSign = Image.asset(
    "assets/Sign.png",
    color: Colors.green,
    colorBlendMode: BlendMode.softLight,
  );
  @override
  void initState() {
    _controllerPerson = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();
    _controllerBusiness = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..forward();
    _controllerHulk = AnimationController(
      vsync: this,
      duration: Duration(seconds: 7),
    )..forward();

    _controllerHealthBar = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));

    _controllerPerson.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _imageIndex = 0;
        });
        _controllerPerson.reset();
        _controllerPerson.forward();
        // Degrease wall health
        _removeHealth(1);
        // Blink the health bar
        _blinkHealthBar();
      }
    });

    _controllerBusiness.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _imageIndex = 1;
        });

        _controllerBusiness.reset();
        _controllerBusiness.forward();
        // Degrease wall health
        _removeHealth(3);
        // Blink the health bar
        _blinkHealthBar();
      }
    });

    _controllerHulk.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _imageIndex = 2;
        });
        _controllerHulk.reset();
        _controllerHulk.forward();
        // Degrease wall health
        _removeHealth(5);
        // Blink the health bar
        _blinkHealthBar();
      }
    });

    _stopwatch = Stopwatch()..start();

    super.initState();
  }

  // Remove health when player runs into wall, or in reality when the animation is at end
  void _removeHealth(int value) {
    if (_wallHealth >= 0) {
      setState(() {
        _wallHealth -= value;
      });
    } else {
      setState(() {
        _showLostScreen = true;
        _stopwatch.stop();
      });
    }
  }

  // Blinks health bar by running [FadeTransition]
  void _blinkHealthBar() {
    _controllerHealthBar.reset();
    _controllerHealthBar.forward();
  }

  @override
  void dispose() {
    _controllerPerson.dispose();
    _controllerHealthBar.dispose();
    _controllerBusiness.dispose();
    _controllerHulk.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    var size = MediaQuery.of(context).size;

    // Init images
    precacheImage(imageBackground.image, context);
    precacheImage(imageBushTriple.image, context);
    precacheImage(imageCactusSplit.image, context);
    precacheImage(imageCactusTall.image, context);
    precacheImage(imageSignArrow.image, context);
    precacheImage(imageSign.image, context);
    precacheImage(imageGrassBrown.image, context);
    precacheImage(imageGrassGreen.image, context);
    precacheImage(imageSkeleton.image, context);
    precacheImage(imageStone.image, context);
    precacheImage(imageStoneBlock.image, context);

    // Init person's animation
    _personWalkToWallAnimation =
        Tween(begin: 0.0, end: size.width / 2).animate(_controllerPerson);
    _hulkWalkToWallAnimation =
        Tween(begin: size.width, end: size.width / 12).animate(_controllerHulk);
    _businessmanWalktoWallAnimation =
        Tween(begin: 0.0, end: size.width / 2).animate(_controllerBusiness);

    // Check when close to wall to play explosion
    _controllerPerson.addListener(() {
      if (_personWalkToWallAnimation.value > (size.width / 4)) {
        _flareControllerPersonExplosion.play("estrellas");
      }
    });
    _controllerHulk.addListener(() {
      if (_hulkWalkToWallAnimation.value < (size.width / 8)) {
        _flareControllerHulkExplosion.play("estrellas");
      }
    });
    _controllerBusiness.addListener(() {
      if (_businessmanWalktoWallAnimation.value > (size.width / 4)) {
        _flareControllerBusinessExplosion.play("estrellas");
      }
    });

    super.didChangeDependencies();
  }

  final FlareControls _flareControllerPersonExplosion = FlareControls();
  final FlareControls _flareControllerHulkExplosion = FlareControls();
  final FlareControls _flareControllerBusinessExplosion = FlareControls();
  @override
  Widget build(BuildContext context) {
    String _time;

    setState(() {
      _time = _stopwatch.elapsed.inSeconds.toString();
    });

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.help_outline),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                      "License information: Animations (sun, green man, business man and person) from www.rive.app service. Licensed under CC BY 4.0 https://creativecommons.org/licenses/by/4.0/.\nOther images used from: https://opengameart.org/content/free-desert-platformer-tileset"),
                ),
              ],
            ),
          ],
        ),
      ),
      // appBar: AppBar(
      //   title: Text("Repair wall"),
      //   backgroundColor: Colors.orange,
      //   actions: <Widget>[
      //     Center(
      //       child: Text(
      //         "Score: $_time",
      //         style: TextStyle(fontSize: 30),
      //       ),
      //     )
      //   ],
      // ),
      body: AnimatedBuilder(
        animation: _controllerPerson,
        builder: (context, widget) {
          return Container(
            width: _width,
            height: _height,
            child: Stack(children: [
              //?---------------Background-------------------------------------------------------------------------------------------------
              ..._buildBackground(),

              //?--------------Health bar---------------------------------------------------------------------------------------------------------------------
              Positioned(
                bottom: 235,
                left: _width / 4,
                width: _width / 2,
                height: 50,
                child: Container(
                  child: FadeTransition(
                    opacity: _controllerHealthBar,
                    child: FAProgressBar(
                      maxValue: 50,
                      currentValue: _wallHealth,
                      displayText: "/50",
                      backgroundColor: Colors.redAccent,
                      progressColor: Colors.greenAccent,
                    ),
                  ),
                ),
              ),
              //?--------------Characters---------------------------------------------------------------------------------------------------------------------

              const Positioned(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: const FlareActor("assets/Sun_is_Born.flr",
                      alignment: Alignment.bottomRight,
                      fit: BoxFit.cover,
                      animation: "Sun_in"),
                ),
              ),
              Positioned(
                bottom: 10,
                left: -75,
                child: Transform(
                  transform: Matrix4.translationValues(
                      _personWalkToWallAnimation.value, 0.0, 0.0),
                  child: Container(
                    width: 150,
                    height: 150,
                    child: const FlareActor("assets/walking.flr",
                        alignment: Alignment.bottomLeft,
                        fit: BoxFit.contain,
                        animation: "walking"),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 75,
                child: Transform(
                  transform: Matrix4.translationValues(
                      _hulkWalkToWallAnimation.value, 0.0, 0.0),
                  child: Container(
                    color: Colors.green,
                    width: 200,
                    height: 200,
                    child: const NimaActor("assets/Hulk.nima",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "Walk"),
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: -75,
                child: Transform(
                  transform: Matrix4.translationValues(
                      _businessmanWalktoWallAnimation.value, 0.0, 0.0),
                  child: Container(
                    width: 150,
                    height: 150,
                    child: const FlareActor("assets/walking_business.flr",
                        alignment: Alignment.bottomRight,
                        fit: BoxFit.contain,
                        animation: "human_5"),
                  ),
                ),
              ),
              //? ------------------Items to drag-----------------------------------------------------------------------------------
              Positioned(
                width: _width / 2,
                height: 50,
                right: 0,
                top: 0,
                child: Container(
                  color: Colors.grey,
                  child: Row(
                    children: <Widget>[
                      Draggable<String>(
                        data: "block",
                        child: imageStoneBlock,
                        feedback: imageStoneBlock,
                        childWhenDragging: Image.asset(
                          "assets/StoneBlock.png",
                          colorBlendMode: BlendMode.hardLight,
                          color: Colors.grey[700],
                        ),
                      ),
                      Draggable<String>(
                        data: "stone",
                        child: imageStone,
                        feedback: imageStone,
                        childWhenDragging: Image.asset(
                          "assets/Stone.png",
                          colorBlendMode: BlendMode.hardLight,
                          color: Colors.grey[700],
                        ),
                      ),
                      Draggable<String>(
                        data: "wood",
                        child: imageSign,
                        feedback: imageSign,
                        childWhenDragging: Image.asset(
                          "assets/Sign.png",
                          colorBlendMode: BlendMode.hardLight,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //?--------------Start of wall---------------------------------------------------------------------------------------------------------------------

              ..._buildWall(_width),

              //?  Shows image on the middle of the wall------------------------------------
              Positioned(
                bottom: 90,
                width: 60,
                height: 50,
                left: 175,
                child: Container(
                  width: 40,
                  height: 20,
                  color: Colors.grey,
                  child: Builder(builder: (context) {
                    if (_imageIndex == 0) {
                      return imageWallStoneBlock;
                    } else if (_imageIndex == 1) {
                      return imageWallStone;
                    } else {
                      return imageWallSign;
                    }
                  }),
                ),
              ),
              Positioned(
                bottom: 10,
                width: 120,
                height: 220,
                left: 140,
                child: Container(
                  // color: Colors.green,
                  child: DragTarget<String>(
                    builder: (context, _, __) {
                      return Container();
                    },
                    onWillAccept: (String data) {
                      if (_imageIndex == 0 && data == "block") {
                        setState(() {
                          _wallHealth += 2;
                        });

                        return true;
                      } else if (_imageIndex == 1 && data == "stone") {
                        setState(() {
                          _wallHealth += 3;
                        });
                        return true;
                      } else if (_imageIndex == 2 && data == "wood") {
                        setState(() {
                          _wallHealth += 5;
                        });
                        return true;
                      }

                      return false;
                    },
                  ),
                ),
              ),

              //?--------------End of wall---------------------------------------------------------------------------------------------------------------------

              //?--------------Start of Explosions---------------------------------------------------------------------------------------------------------------------

              Positioned(
                bottom: 10,
                width: 200,
                height: 70,
                left: 80,
                child: Container(
                  width: 150,
                  height: 150,
                  child: FlareActor(
                    "assets/Explosion.flr",
                    alignment: Alignment.bottomLeft,
                    fit: BoxFit.contain,
                    animation: "estrellas",
                    controller: _flareControllerPersonExplosion,
                  ),
                ),
              ),
              Positioned(
                bottom: 150,
                width: 200,
                height: 70,
                left: 155,
                child: Container(
                  width: 150,
                  height: 150,
                  child: FlareActor(
                    "assets/Explosion.flr",
                    alignment: Alignment.bottomLeft,
                    fit: BoxFit.contain,
                    animation: "estrellas",
                    controller: _flareControllerHulkExplosion,
                  ),
                ),
              ),
              Positioned(
                bottom: 90,
                width: 200,
                height: 70,
                left: 80,
                child: Container(
                  width: 150,
                  height: 150,
                  child: FlareActor(
                    "assets/Explosion.flr",
                    alignment: Alignment.bottomLeft,
                    fit: BoxFit.contain,
                    animation: "estrellas",
                    controller: _flareControllerBusinessExplosion,
                  ),
                ),
              ),

              //?--------------Front of ground---------------------------------------------------------------------------------------------------------------------
              ..._buildForeGround(_width),
              _showLostScreen
                  ? Positioned.fill(
                      child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Score:${_stopwatch.elapsed.inSeconds} \n",
                            style: TextStyle(
                                fontSize: 30, fontStyle: FontStyle.italic),
                          ),
                          FlatButton(
                            color: Colors.green,
                            child: Text(
                              "Start!",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              setState(() {
                                _wallHealth = 50;
                                _stopwatch.reset();
                                _stopwatch.start();
                                _showLostScreen = false;
                              });
                            },
                          ),
                        ],
                      ),
                      color: Colors.white70,
                    ))
                  : Container(),
            ]),
          );
        },
      ),
    );
  }

  List<Widget> _buildBackground() {
    return [
      Positioned(
        bottom: 0,
        child: imageBackground,
      ),
      Positioned(
        bottom: 200,
        width: 50,
        height: 50,
        child: imageBushTriple,
      ),
      Positioned(
        bottom: 200,
        left: 300,
        width: 80,
        height: 80,
        child: imageCactusSplit,
      ),
      Positioned(
        bottom: 123,
        left: 40,
        width: 50,
        height: 50,
        child: imageCactusTall,
      ),
      Positioned(
        bottom: 40,
        left: 20,
        child: imageSignArrow,
      ),
      Positioned(
        bottom: 50,
        right: 30,
        width: 50,
        height: 50,
        child: imageGrassGreen,
      ),
      Positioned(
        bottom: 153,
        right: 42,
        width: 50,
        height: 50,
        child: imageGrassBrown,
      ),
      Positioned(
        bottom: 120,
        right: 100,
        width: 50,
        height: 50,
        child: imageStone,
      ),
    ];
  }

  List<Widget> _buildForeGround(double width) {
    return [
      Positioned(
        bottom: 0,
        width: 50,
        height: 50,
        child: imageGrassBrown,
      ),
      Positioned(
        bottom: -5,
        left: (width / 2) - 50,
        width: 50,
        height: 50,
        child: imageGrassBrown,
      ),
      Positioned(
        bottom: 0,
        right: 42,
        width: 50,
        height: 50,
        child: imageSkeleton,
      )
    ];
  }

  List<Widget> _buildWall(double width) {
    return [
      Positioned(
        bottom: 10,
        width: width,
        height: 70,
        child: imageStoneWallBlock,
      ),
      Positioned(
        bottom: 80,
        width: width,
        height: 70,
        child: imageStoneWallBlock,
      ),
      Positioned(
        bottom: 150,
        width: width,
        height: 70,
        child: imageStoneWallBlock,
      ),
    ];
  }
}

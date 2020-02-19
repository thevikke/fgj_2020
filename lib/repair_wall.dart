import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:fgj_2020/basic_button.dart';
import 'package:fgj_2020/pause_screen.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:intl/intl.dart';
import 'package:nima/nima_actor.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'reveal_animation.dart';

class RepairWallGame extends StatefulWidget {
  @override
  _RepairWallGameState createState() => _RepairWallGameState();
}

class _RepairWallGameState extends State<RepairWallGame>
    with TickerProviderStateMixin {
  int _wallHealth = 50;
  int _imageIndex = 0;
  Color _dragColor = Colors.transparent;

  bool _muted = true;

  bool _showLostScreen = false;

  Stopwatch _stopwatch;

  SharedPreferences _prefs;

  AnimationController _controllerHealthBar;
  AnimationController _controllerPerson;
  AnimationController _controllerHulk;
  AnimationController _controllerBusiness;

  Animation _personWalkToWallAnimation;
  Animation _businessmanWalktoWallAnimation;
  Animation _hulkWalkToWallAnimation;
  final _assetsAudioPlayer = AssetsAudioPlayer();

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
    colorBlendMode: BlendMode.softLight,
  );
  final Image imageWallStone = Image.asset(
    "assets/Stone.png",
    colorBlendMode: BlendMode.softLight,
  );
  final Image imageWallSign = Image.asset(
    "assets/Sign.png",
    colorBlendMode: BlendMode.softLight,
  );
  @override
  void initState() {
    _controllerPerson = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _controllerBusiness = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _controllerHulk = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    );

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

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _prefs = sp;
      setState(() {
        // If null then set as true so that music doesn't start
        _muted = _prefs.getBool("muted") ?? true;
      });
      if (!_muted) {
        _initMusic();
      }
    });

    _stopwatch = Stopwatch();

    _startGame();

    super.initState();
  }

  // Remove health when player runs into wall, or in reality when the animation is at end
  Future<void> _removeHealth(int value) async {
    if (_wallHealth >= 0) {
      setState(() {
        _wallHealth -= value;
      });
    } else {
      // Check if empty
      var records = _prefs.getStringList("records") ?? [];

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('MM-dd-yyyy').format(now);

      records.add(
          "Date: $formattedDate Score: ${_stopwatch.elapsed.inSeconds.toString()}");
      _prefs.setStringList("records", records);
      setState(() {
        // If lost the game show lost screen and pause game
        _showLostScreen = true;
      });
      _pauseGame();
    }
  }

  @override
  void dispose() {
    _controllerPerson.dispose();
    _controllerHealthBar.dispose();
    _controllerBusiness.dispose();
    _controllerHulk.dispose();
    _assetsAudioPlayer.stop();
    _assetsAudioPlayer.dispose();
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

    // Calculate when close to wall to play explosion
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

  // Blinks health bar by running [FadeTransition]
  void _blinkHealthBar() {
    _controllerHealthBar.reset();
    _controllerHealthBar.forward();
  }

  // Pause character animations and stopwatch
  void _pauseGame() {
    _stopwatch.stop();
    _controllerPerson.stop();
    _controllerHulk.stop();
    _controllerBusiness.stop();
    if (!_muted) {
      _assetsAudioPlayer.pause();
    }
  }

  // Start character animations and stopwatch
  void _startGame() {
    _stopwatch.start();
    _controllerPerson.forward();
    _controllerHulk.forward();
    _controllerBusiness.forward();
    if (!_muted) {
      _assetsAudioPlayer.play();
    }
  }

  void _restartGame() {
    setState(() {
      _wallHealth = 50;
      _showLostScreen = false;
    });
    _stopwatch.reset();
    _stopwatch.start();
    _controllerPerson.reset();
    _controllerHulk.reset();
    _controllerBusiness.reset();
    _controllerPerson.forward();
    _controllerHulk.forward();
    _controllerBusiness.forward();
    _restartMusic();
  }

  void _restartMusic() {
    _assetsAudioPlayer.seek(const Duration(seconds: 1));
    _assetsAudioPlayer.loop = true;
    _assetsAudioPlayer.play();
  }

  void _initMusic() {
    _assetsAudioPlayer.open(
      "assets/audios/music.mp3",
    );
  }

  final FlareControls _flareControllerPersonExplosion = FlareControls();
  final FlareControls _flareControllerHulkExplosion = FlareControls();
  final FlareControls _flareControllerBusinessExplosion = FlareControls();
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controllerPerson,
        builder: (context, widget) {
          return Container(
            width: _width,
            height: _height,
            child: Stack(children: [
              //?---------------Background-------------------------------------------------------------------------------------------------
              ..._buildBackground(),

              Positioned(
                top: 50,
                left: _width / 2.6,
                child: Text(
                  "${_stopwatch.elapsed.inSeconds.toString()}",
                  style: TextStyle(fontFamily: "Frijole", fontSize: 70),
                ),
              ),

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

              //?--------------Characters---------------------------------------------------------------------------------------------------------------------

              const Positioned(
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: const FlareActor("assets/Sun_is_Born.flr",
                      alignment: Alignment.bottomRight,
                      fit: BoxFit.cover,
                      animation: "Sun_idle"),
                ),
              ),
              // If not true show nothing, this is for smooth start
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
                    width: 200,
                    height: 200,
                    child: NimaActor(
                      "assets/Hulk.nima",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "Stomp",
                      clip: false,
                    ),
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
                width: 70,
                height: 210,
                right: 0,
                top: _height / 3,
                child: Container(
                  color: Colors.grey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              //?---------------Pause/Leave button----------------------------------------------------------------------------------------
              Positioned(
                top: 0,
                right: 0,
                width: 100,
                height: 100,
                child: Container(
                  color: Colors.white70,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        splashColor: Colors.orangeAccent,
                        onTap: () async {
                          // Pause the game
                          _pauseGame();
                          // Show [PauseScreen], pass the [_startGame] function as a parameter so we can start the game from [PauseScreen] view
                          Navigator.of(context).push(
                            RevealRoute(
                                builder: (context) => PauseScreen(_startGame),
                                transitionColor: Colors.blue),
                          );
                        },
                        child: Center(
                          child: Text(
                            "II",
                            style: TextStyle(
                              fontFamily: "Frijole",
                              fontSize: 60,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        )),
                  ),
                ),
              ),

              //? -----------------Mute music button---------------------------------------
              Positioned(
                top: 100,
                right: 0,
                width: 100,
                height: 100,
                child: Container(
                  child: IconButton(
                    icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                    iconSize: 50,
                    color: Colors.orangeAccent,
                    onPressed: () {
                      if (!_muted) {
                        setState(() {
                          _muted = true;
                        });

                        _assetsAudioPlayer.stop();
                      } else {
                        setState(() {
                          _muted = false;
                        });
                        _initMusic();
                        _restartMusic();
                      }
                      _prefs.setBool("muted", _muted);
                    },
                  ),
                ),
              ),
              //?--------------Start of wall---------------------------------------------------------------------------------------------------------------------

              ..._buildWall(_width),

              //?  Shows image on the middle of the wall------------------------------------
              Positioned(
                bottom: 85,
                width: 80,
                height: 60,
                left: _width / 2.47,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: 20,
                  height: 20,
                  color: _dragColor,
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
                width: 120,
                height: 220,
                bottom: 10,
                left: _width / 2.7,
                child: Container(
                  child: DragTarget<String>(
                    builder: (context, _, __) {
                      return Container();
                    },
                    onWillAccept: (String data) {
                      if (_imageIndex == 0 && data == "block") {
                        setState(() {
                          _dragColor = Colors.green;
                        });
                        return true;
                      } else if (_imageIndex == 1 && data == "stone") {
                        setState(() {
                          _dragColor = Colors.green;
                        });
                        return true;
                      } else if (_imageIndex == 2 && data == "wood") {
                        setState(() {
                          _dragColor = Colors.green;
                        });
                        return true;
                      } else {
                        setState(() {
                          _dragColor = Colors.red;
                        });
                        return true;
                      }
                    },
                    onAccept: (String data) {
                      if (_imageIndex == 0 && data == "block") {
                        setState(() {
                          _wallHealth += 1;
                          _dragColor = Colors.transparent;
                        });
                      } else if (_imageIndex == 1 && data == "stone") {
                        setState(() {
                          _wallHealth += 2;
                          _dragColor = Colors.transparent;
                        });
                      } else if (_imageIndex == 2 && data == "wood") {
                        setState(() {
                          _wallHealth += 3;
                          _dragColor = Colors.transparent;
                        });
                      } else {
                        setState(() {
                          _dragColor = Colors.transparent;
                        });
                      }
                    },
                  ),
                ),
              ),

              //?--------------End of wall---------------------------------------------------------------------------------------------------------------------

              // //?--------------Front of ground---------------------------------------------------------------------------------------------------------------------
              ..._buildForeGround(_width),
              //? Lost screen----------------------------------------------------------------------
              _showLostScreen
                  ? Positioned.fill(
                      child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "YOU LOST!",
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: "Frijole",
                                color: Colors.white70),
                          ),
                          Text(
                            "SCORE:${_stopwatch.elapsed.inSeconds.toString()} \n",
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: "Frijole",
                                color: Colors.white70),
                          ),
                          Container(
                            width: 200,
                            height: 200,
                            child: NimaActor(
                              "assets/Hulk.nima",
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              animation: "Jump",
                              clip: false,
                            ),
                          ),
                          SizedBox(
                            height: _height / 26,
                          ),
                          SizedBox(
                            width: _width / 2,
                            height: 50,
                            child: BasicButton(
                              () {
                                Navigator.of(context)
                                    .popUntil(ModalRoute.withName("/"));
                              },
                              text: "QUIT",
                              color: Colors.white,
                              textColor: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            width: _width / 2,
                            height: 50,
                            child: BasicButton(
                              () {
                                _restartGame();
                              },
                              text: "RESTART",
                            ),
                          ),
                        ],
                      ),
                      color: Colors.orangeAccent,
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

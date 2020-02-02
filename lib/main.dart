import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:nima/nima_actor.dart';
import 'package:flare_flutter/flare_actor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      title: 'Repair the wall!',
      home: MyHomePage(title: 'Repair wall'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
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

  Image imageBackground;
  Image imageBushTriple;
  Image imageCactusSplit;
  Image imageCactusTall;
  Image imageSignArrow;
  Image imageGrassBrown;
  Image imageGrassGreen;
  Image imageSkeleton;
  Image imageStone;
  Image imageStoneBlock;
  @override
  void initState() {
    imageBackground = Image.asset("assets/BG.png");
    imageBushTriple = Image.asset("assets/Bush_triple.png");
    imageCactusSplit = Image.asset("assets/Cactus_split.png");
    imageCactusTall = Image.asset("assets/Cactus_tall.png");
    imageSignArrow = Image.asset("assets/SignArrow.png");
    imageGrassBrown = Image.asset("assets/Grass_brown.png");
    imageGrassGreen = Image.asset("assets/Grass_green.png");
    imageCactusTall = Image.asset("assets/Cactus_tall.png");
    imageSkeleton = Image.asset("assets/Skeleton.png");
    imageStone = Image.asset("assets/Stone.png");
    imageStoneBlock = Image.asset("assets/StoneBlock.png");

    _controllerPerson = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..forward();
    _controllerBusiness = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    )..forward();
    _controllerHulk = AnimationController(
      vsync: this,
      duration: Duration(seconds: 25),
    )..forward();

    _controllerHealthBar = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));

    // Check when close to wall to play explosion
    _controllerPerson.addListener(() {
      if (_personWalkToWallAnimation.value > 155) {
        _flareControllerPersonExplosion.play("estrellas");
      }
    });
    _controllerHulk.addListener(() {
      if (_hulkWalkToWallAnimation.value < 120) {
        _flareControllerHulkExplosion.play("estrellas");
      }
    });
    _controllerBusiness.addListener(() {
      if (_businessmanWalktoWallAnimation.value > 130) {
        _flareControllerBusinessExplosion.play("estrellas");
      }
    });
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
    // Init images
    precacheImage(imageBackground.image, context);
    precacheImage(imageBushTriple.image, context);
    precacheImage(imageCactusSplit.image, context);
    precacheImage(imageCactusTall.image, context);
    precacheImage(imageSignArrow.image, context);
    precacheImage(imageGrassBrown.image, context);
    precacheImage(imageGrassGreen.image, context);
    precacheImage(imageSkeleton.image, context);
    precacheImage(imageStone.image, context);
    precacheImage(imageStoneBlock.image, context);

    // Init person's animation
    _personWalkToWallAnimation =
        Tween(begin: 0.0, end: 183.0).animate(_controllerPerson);
    _hulkWalkToWallAnimation =
        Tween(begin: MediaQuery.of(context).size.width, end: 110)
            .animate(_controllerHulk);
    _businessmanWalktoWallAnimation =
        Tween(begin: 0.0, end: 160.0).animate(_controllerBusiness);

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
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          Center(
            child: Text(
              "Score: $_time",
              style: TextStyle(fontSize: 30),
            ),
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: _controllerPerson,
        builder: (context, widget) {
          return Container(
            width: _width,
            height: _height,
            child: Stack(children: [
//?---------------Background-------------------------------------------------------------------------------------------------
              Positioned(
                bottom: 0,
                child: Image.asset("assets/BG.png"),
              ),

              Positioned(
                bottom: 200,
                width: 50,
                height: 50,
                child: Image.asset("assets/Bush_triple.png"),
              ),

              Positioned(
                bottom: 200,
                left: 300,
                width: 80,
                height: 80,
                child: Image.asset("assets/Cactus_split.png"),
              ),

              Positioned(
                bottom: 123,
                left: 40,
                width: 50,
                height: 50,
                child: Image.asset("assets/Cactus_tall.png"),
              ),

              Positioned(
                bottom: 40,
                left: 20,
                child: Image.asset("assets/SignArrow.png"),
              ),
              Positioned(
                bottom: 50,
                right: 30,
                width: 50,
                height: 50,
                child: Image.asset("assets/Grass_green.png"),
              ),
              Positioned(
                bottom: 153,
                right: 42,
                width: 50,
                height: 50,
                child: Image.asset("assets/Grass_brown.png"),
              ),

              Positioned(
                bottom: 120,
                right: 100,
                width: 50,
                height: 50,
                child: Image.asset("assets/Stone.png"),
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
                    width: 300,
                    height: 300,
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
                        child: Image.asset("assets/StoneBlock.png"),
                        feedback: Image.asset("assets/StoneBlock.png"),
                        childWhenDragging: Image.asset(
                          "assets/StoneBlock.png",
                          colorBlendMode: BlendMode.hardLight,
                          color: Colors.grey[700],
                        ),
                      ),
                      Draggable<String>(
                        data: "stone",
                        child: Image.asset("assets/Stone.png"),
                        feedback: Image.asset("assets/Stone.png"),
                        childWhenDragging: Image.asset(
                          "assets/Stone.png",
                          colorBlendMode: BlendMode.hardLight,
                          color: Colors.grey[700],
                        ),
                      ),
                      Draggable<String>(
                        data: "wood",
                        child: Image.asset("assets/Sign.png"),
                        feedback: Image.asset("assets/Sign.png"),
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

              Positioned(
                bottom: 10,
                width: _width,
                height: 70,
                child: Image.asset(
                  "assets/StoneBlock.png",
                  color: Colors.brown,
                  colorBlendMode: BlendMode.softLight,
                ),
              ),

              Positioned(
                bottom: 80,
                width: _width,
                height: 70,
                child: Image.asset(
                  "assets/StoneBlock.png",
                  color: Colors.brown,
                  colorBlendMode: BlendMode.softLight,
                ),
              ),
              Positioned(
                bottom: 150,
                width: _width,
                height: 70,
                child: Image.asset(
                  "assets/StoneBlock.png",
                  color: Colors.brown,
                  colorBlendMode: BlendMode.softLight,
                ),
              ),
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
                      return Image.asset(
                        "assets/StoneBlock.png",
                        color: Colors.green,
                        colorBlendMode: BlendMode.softLight,
                      );
                    } else if (_imageIndex == 1) {
                      return Image.asset(
                        "assets/Stone.png",
                        color: Colors.green,
                        colorBlendMode: BlendMode.softLight,
                      );
                    } else {
                      return Image.asset(
                        "assets/Sign.png",
                        color: Colors.green,
                        colorBlendMode: BlendMode.softLight,
                      );
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
                        print("$data-----------$_imageIndex");
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
                      print("returns false");
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
              Positioned(
                bottom: 0,
                width: 50,
                height: 50,
                child: Image.asset("assets/Grass_brown.png"),
              ),
              Positioned(
                bottom: -5,
                left: (_width / 2) - 50,
                width: 50,
                height: 50,
                child: Image.asset("assets/Grass_brown.png"),
              ),
              Positioned(
                bottom: 0,
                right: 42,
                width: 50,
                height: 50,
                child: Image.asset("assets/Skeleton.png"),
              ),
              _showLostScreen
                  ? Positioned.fill(
                      child: Container(
                      child: Center(
                          child: FlatButton(
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
                            _showLostScreen = false;
                          });
                        },
                      )),
                      color: Colors.white70,
                    ))
                  : Container(),
            ]),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.star),
      // ),
    );
  }
}

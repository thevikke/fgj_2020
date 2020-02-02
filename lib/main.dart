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
      duration: Duration(seconds: 10),
    )..forward();
    _controllerBusiness = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..forward();
    _controllerHulk = AnimationController(
      vsync: this,
      duration: Duration(seconds: 15),
    )..forward();

    _controllerHealthBar = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));

    _controllerPerson.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("Person hit the wall");
        _controllerPerson.reset();
        _controllerPerson.forward();
        // Degrease wall health
        _removeHealth();
        // Blink the health bar
        _blinkHealthBar();
        print("Blink health bar");

        print("Restarted animation");
      }
    });

    _controllerBusiness.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("Person hit the wall");
        _controllerBusiness.reset();
        _controllerBusiness.forward();
        // Degrease wall health
        _removeHealth();
        // Blink the health bar
        _blinkHealthBar();
        print("Blink health bar");

        print("Restarted animation");
      }
    });

    _controllerHulk.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        print("Person hit the wall");
        _controllerHulk.reset();
        _controllerHulk.forward();
        // Degrease wall health
        _removeHealth();
        // Blink the health bar
        _blinkHealthBar();
        print("Blink health bar");

        print("Restarted animation");
      }
    });

    super.initState();
  }

  // Remove health when player runs into wall, or in reality when the animation is at end
  void _removeHealth() {
    setState(() {
      _wallHealth -= 1;
    });
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
    _businessmanWalktoWallAnimation =
        Tween(begin: 0.0, end: 170.0).animate(_controllerBusiness);
    _hulkWalkToWallAnimation =
        Tween(begin: MediaQuery.of(context).size.width, end: 110)
            .animate(_controllerHulk);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: AnimatedBuilder(
        animation: _controllerPerson,
        builder: (context, widget) {
          return Container(
            width: _width,
            height: _height,
            child: Stack(children: [
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

//?--------------Start of wall---------------------------------------------------------------------------------------------------------------------
              //! Explosion
              Positioned(
                bottom: 10,
                width: 200,
                height: 70,
                left: 65,
                child: Container(
                  width: 150,
                  height: 150,
                  child: const FlareActor("assets/Explosion.flr",
                      alignment: Alignment.bottomLeft,
                      fit: BoxFit.contain,
                      animation: "estrellas"),
                ),
              ),
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
//?--------------End of wall---------------------------------------------------------------------------------------------------------------------

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
                bottom: 0,
                right: 42,
                width: 50,
                height: 50,
                child: Image.asset("assets/Skeleton.png"),
              ),
              Positioned(
                bottom: 120,
                right: 100,
                width: 50,
                height: 50,
                child: Image.asset("assets/Stone.png"),
              ),
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

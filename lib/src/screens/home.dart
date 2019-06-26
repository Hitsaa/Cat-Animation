import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  
  Animation<double> catAnimation;
  AnimationController catController;    //purpose of animation controller is to start stop restart the animation.
  Animation<double> boxAnimation;
  AnimationController boxController;

  initState() {
    super.initState();
    boxController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    boxAnimation = Tween(begin: pi * 0.6 , end: pi * 0.66 ,).animate(
      CurvedAnimation(parent: boxController,
          curve: Curves.easeIn,
      ),
    );
    boxAnimation.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        boxController.reverse();
      }
      else if(status == AnimationStatus.dismissed) {
        boxController.forward();                         
      }
    }
    );
    boxController.forward();
    catController =
        AnimationController( 
          duration: Duration(milliseconds: 200)
          vsync: this,
        ); 
    catAnimation = Tween(begin: -35.0, end: -80.0).animate(  
    CurvedAnimation(    
          parent: catController,
          curve: Curves.easeIn,
      ),
  );
  }
  
  onTap(){

    //boxController.stop();
    if(catController.status == AnimationStatus.completed) {
      boxController.forward();
      catController.reverse();
    }
    else if(catController.status == AnimationStatus.dismissed) {
      boxController.stop();
      catController.forward();
    }

    //catController.forward();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation !'),
      ),
      body: GestureDetector(
        
        //child: buildCatAnimation(),
        //child: Stack(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
              children: <Widget>[
                //buildBox(),
                buildCatAnimation(),
                buildBox(),
                buildLeftFlap(),
                buildRightFlap(),
              ],
        ),

        ),
        onTap: onTap,
      ),
      //body: buildAnimation(),
    );
  }
  Widget buildCatAnimation() {
    return AnimatedBuilder(     
      animation: catAnimation,
      builder: (context, child) {
        //return Container(
        return Positioned(
          child: child,
          //margin: EdgeInsets.only(top: catAnimation.value),   
          //bottom: catAnimation.value,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
      
    );
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
          animation: boxAnimation,
          child: Container(
            height: 10.0,
            width: 125.0,
            color: Colors.brown,
          ),
          builder: (context, child) {
            return Transform.rotate(
              child: child,
              alignment: Alignment.topLeft,
              angle: boxAnimation.value,
            );
          }
      ),
    );
  }
    /*return Positioned(
      left: 3.0,
      child: Transform.rotate(
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.brown,
        ),
        angle: pi * 0.6 ,
        alignment: Alignment.topLeft,
      ),
    ); */


    /*
    return Transform.rotate(
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.red,
        ),
      angle: pi * 0.6 ,
      alignment: Alignment.topLeft,
    );

  }
  */

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
          animation: boxAnimation,
          child: Container(
            height: 10.0,
            width: 125.0,
            color: Colors.brown,
          ),
          builder: (context, child) {
            return Transform.rotate(
              child: child,
              alignment: Alignment.topRight,
              angle: -boxAnimation.value, // applying negative offset.
            );
          }
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

/*
Now the animation class right here is a generic class member each and every class has the ability for us to kind of specify the type that's going to be worked with inside this class on the fly.
 */
class HomeState extends State<Home> with TickerProviderStateMixin {
  /*
  So any time we create an animation controller we are provided to pass in an instance of something called a ticker provider on the vsync parameter.
  ticker provider class provide us a little bit of a notification anytime our animation needs to do an update.
  The ticket provider itself is actually a mixin.
   */

  /*
  Our animation class for animating the position of our cat on the screen. So it's kind of vertical position up and down. It's going to have the animation value that we're going to change over time.
  So it is a double.So it's going to be a essentially a number that we are going to change to control the vertical position of the cat.
  We're also going to create an instance variable that refers to the animation controller that would be responsible for moving the cat around.
   */
  Animation<double> catAnimation;
  AnimationController catController;    //purpose of animation controller is to start stop restart the animation.
  Animation<double> boxAnimation;
  AnimationController boxController;

  initState() {
    //The init state lifecycle method is only available for classes that extend the state base class.
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
        boxController.forward();                          // forward is used to start the animation.
      }
    }
    );
    boxController.forward();
    catController =
        AnimationController( //cat controller is going to be responsible for starting stopping restarting the animation and it also is going to record the duration
          duration: Duration(milliseconds: 200),
          //over which the animation is going to run. So sure over here you and I specified the duration but the duration doesn't just magically
          vsync: this, //make the animation kick in play.Something has to actually reach in to our homestate class and find this controller and tell it hey cat
        ); //controller you need to look over at that animation variable and remember the animation is storing the actual current value of our
    //animation And you need to update that animations value.So the ticker provider is kind of like a handle from the outside world
    // into our widget that gives the outside world a flutter the ability to reach in and tell her animation to kind of progress along and essentially render the next frame of our animation.
//Vsync is essentially saying we just mixed in our ticker provider to our current class or this instance of the class that we are currently working with. So passing in this on the Vsync
//argument right here says hey we have a ticket provider and it's actually mixed in to the current class and that's why we are providing it to the named perimeter of the vsync as 'this'.

// Tween helps in displacement. It changes the elevation of cat out of box from 0 px to 100 px.Animate function returns value of type animation which is what we have defined our cat animation to be.
  //catAnimation = Tween(begin: 0.0, end: 100.0).animate(
    catAnimation = Tween(begin: -35.0, end: -80.0).animate(  // setting the negative offset so that cats ears could come out of the box
    CurvedAnimation(    //animation curve describes the rate at which our animated value is going to change. The curved animation describes how quickly the animated value is going to change from 0 to 100.
          parent: catController,
          curve: Curves.easeIn, //curve value right here and we'll get a sense of how of the different curves that we can use kind of change how the animation really looks on the screen.
      ),
  );
  //catController.forward();  // used for starting the movement of our animated widget
  }
  /*
  we only declared instance variables for the animation and the controller. We did not declare a instance variable for the tween. The reason for that is that we are going to refer
  to the animation and the controller throughout other methods inside this file however we're never going to have to define or see reference of tween. tween is something that we
  create just one time and then we essentially throw it away and never use it again.So that's why we did not declare the tween and assign it to a instance variable.
  */

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
        /*
        whenever we create a gesture detector again we're passing a child in.And so any time a user taps on anything that is a child of this gesture animation or this gesture detector
        that tap you then is essentially going to bubble up until it gets to the gesture detector. So if a user taps on our box right here.The box is not the gesture detector but that
        tap event on the box is going to sort of bubble up the widget hierarchy until it gets to the widget.The gesture detector that we just added in and that will then trigger the
        on tap callback
         */
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
    return AnimatedBuilder(     //with the help of our builder function We don't recreating widgets again and again.
      animation: catAnimation,
      builder: (context, child) {
        //return Container(
        return Positioned(
          child: child,
          //margin: EdgeInsets.only(top: catAnimation.value),   // initially the image was just below the app bar. to place it downwards we have to increase margin of top.
          //bottom: catAnimation.value,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
      /*
      We don't want to keep trying to recreate a widget again and again. So to avoid a widget to be recreated again and again we can just pass a third named argument called Child.
      So essentially to a child argument we're going to declare a new instance of our cat. So now we only have to create cat one time and then that single instance of cat is going
       to be reused again and again insider of our animated builder.
       */
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
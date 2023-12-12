# Rive Inputs Generator

A small tool to generate Dart code from a [Rive](https://rive.app) file (.riv). 

## Link

[https://rive-inputs-generator.web.app](https://rive-inputs-generator.web.app)

## How to use it

The generated code will be composed of inputs for the animation's main artboard and state machine, as well as a function so set these inputs from the view. 
Considering you have a wrapper arround your animation:

```dart
class AppRiveAnimation extends StatelessWidget {
  const AppRiveAnimation(
    this.name, {
    super.key,
    this.onInit,
  });

  final String name;
  final void Function(Artboard)? onInit;

  @override
  Widget build(BuildContext context) {
    return RiveAnimation.asset(
      name,
      fit: BoxFit.cover,
      onInit: onInit,
    );
  }
}
```

It can be use like this: 

```dart
class HomeAnimation extends StatefulWidget {
  const HomeAnimation({
    super.key,
    required this.isNight,
  });

  final bool isNight;

  @override
  State<HomeAnimation> createState() => _HomeAnimationState();
}

class _HomeAnimationState extends State<HomeAnimation> {
  StateMachineController? _controller;

  @override
  void didUpdateWidget(covariant HomeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isNight != widget.isNight) {
      setHomeAnimationStateMachineInputs(
        _controller,
        isNight: widget.isNight,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppRiveAnimation(
      'assets/home_animation.riv',
      onInit: (controller) => _controller = controller,
    );
  }
}
```

## Contribution & contact

If you wish to add support for other langages or fix something, any contribution is welcome! 

Feel free to contact me on [Twitter](https://twitter.com/ldachet).

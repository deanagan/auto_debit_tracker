# Flutter Design Patterns and Best Practices (3rd Edition)

## 🍳 Recipe 1 — Create a Proper Flutter Foundation

### 🎯 Goal  
Understand Flutter’s declarative UI and widget tree.

### 🧂 Ingredients  
- `MaterialApp`
- `Scaffold`
- `StatelessWidget`

### 👨‍🍳 Steps

1️⃣ Create the base app:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Hello Flutter"),
      ),
    );
  }
}
```

🔎 What This Teaches

	•	Everything is a widget.
	•	Widgets are immutable.
	•	UI is declared, not manually updated.
	•	The widget tree defines your UI structure.

⸻

## 🍳 Recipe 2 — Add State the Flutter Way

🎯 Goal

Understand StatefulWidget and rebuilding.

🧂 Ingredients
	•	StatefulWidget
	•	setState()

👨‍🍳 Steps

Convert HomePage to a stateful widget:
```dart
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;

  void increment() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Counter: $counter"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

🔎 What This Teaches

	•	State lives in the State object.
	•	setState() triggers a rebuild.
	•	UI = f(state).
	•	Rebuilding is normal and cheap.

⸻

## 🍳 Recipe 3 — Respect the Widget Lifecycle

🎯 Goal

Understand when setup and cleanup happen.

🧂 Ingredients
	•	initState()
	•	dispose()

👨‍🍳 Steps

Add lifecycle logging:

@override
void initState() {
  super.initState();
  debugPrint("initState called");
}

@override
void dispose() {
  debugPrint("dispose called");
  super.dispose();
}

Example with a controller:

late final TextEditingController controller;

@override
void initState() {
  super.initState();
  controller = TextEditingController();
}

@override
void dispose() {
  controller.dispose();
  super.dispose();
}

🔎 What This Teaches
	•	initState() runs once.
	•	dispose() prevents memory leaks.
	•	Poor lifecycle handling causes bugs in large apps.

⸻

🍳 Recipe 4 — Remove Business Logic from UI

🎯 Goal

Separate concerns early (core Chapter 1 message).

❌ The Bad Version

void increment() async {
  await Future.delayed(const Duration(seconds: 1));
  setState(() {
    counter++;
  });
}

UI owns logic — hard to scale.

⸻

✅ The Better Version

Create a controller:

class CounterController {
  int _counter = 0;

  int get value => _counter;

  void increment() {
    _counter++;
  }
}

Use it inside the widget:

class _HomePageState extends State<HomePage> {
  final controller = CounterController();

  void increment() {
    setState(() {
      controller.increment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Counter: ${controller.value}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}

🔎 What This Teaches
	•	UI renders.
	•	Controller handles logic.
	•	Easier testing.
	•	Prepares for MVC, MVVM, BLoC.

⸻

🍳 Recipe 5 — Start Thinking in Architecture

🎯 Goal

Structure before scaling.

🧂 Ingredients
	•	Folder separation
	•	Clean layering mindset

Suggested Structure

lib/
 ├── presentation/
 │    └── home_page.dart
 ├── domain/
 │    └── counter_controller.dart

🔎 What This Teaches
	•	Small widgets.
	•	Clear responsibility boundaries.
	•	Scalable thinking from day one.

⸻

🧠 Chapter 1 Core Philosophy (The Secret Sauce)
	•	Widgets are disposable.
	•	State drives UI.
	•	Rebuilds are expected.
	•	Logic does not belong in UI.
	•	Architecture decisions early prevent chaos 
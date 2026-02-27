# Flutter fundamentals + architectural mindset

---

# 🚀 1. Why Flutter?

Flutter is a **declarative, cross-platform UI framework** that uses:

- A single codebase (mobile, web, desktop)
- Its own rendering engine (Skia)
- A composable widget system

### Declarative UI Example

Instead of telling the UI *how* to update:

```dart
// Imperative thinking (not Flutter style)
button.setText("Clicked!");

Flutter describes the UI as a function of state:

@override
Widget build(BuildContext context) {
  return Text(isClicked ? "Clicked!" : "Click me");
}

✅ UI = f(state)

⸻

🌳 2. Understanding the Widget Tree

Everything in Flutter is a widget.

Two core types:

class MyStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Hello");
  }
}

class MyStatefulWidget extends StatefulWidget {
  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Text("Counter: $counter");
  }
}

Key Concepts
	•	Widgets are immutable
	•	State lives in the State object
	•	Rebuilding widgets is cheap
	•	Flutter maintains:
	•	Widget Tree
	•	Element Tree
	•	Render Tree

⸻

🔄 3. Widget Lifecycle

Important lifecycle methods:

@override
void initState() {
  super.initState();
  // Called once when widget is inserted
}

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  // Called when inherited widgets change
}

@override
void dispose() {
  // Clean up controllers, streams
  super.dispose();
}

Example with Controller Cleanup

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

⚠️ Not disposing resources is a common architectural mistake.

⸻

🧠 4. Separating UI from Business Logic

Beginner mistake:

ElevatedButton(
  onPressed: () {
    // Business logic directly inside UI
    fetchUserData();
  },
  child: Text("Load"),
)

Better approach (separation of concerns):

class UserController {
  Future<void> loadUser() async {
    // API call here
  }
}

final controller = UserController();

ElevatedButton(
  onPressed: controller.loadUser,
  child: Text("Load"),
)

Chapter 1 introduces the idea that UI should not own business logic.

This prepares you for:
	•	MVC
	•	MVVM
	•	BLoC
	•	Clean Architecture

⸻

📦 5. Dependency Management

Flutter uses pubspec.yaml:

dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  provider: ^6.0.0

Install:

flutter pub get

As apps scale, dependency injection becomes important to avoid tight coupling.

⸻

🏗️ Architectural Mindset (Core Message of Chapter 1)

This chapter shifts you from:

❌ “Building screens”
➡️
✅ “Designing scalable applications”

Key principles introduced:
	•	Keep widgets small and reusable
	•	Separate concerns
	•	Understand rebuild mechanics
	•	Respect lifecycle
	•	Plan architecture early

⸻

🎯 What Intermediate Devs Should Focus On

If you’re beyond beginner level, pay special attention to:
	1.	Why widgets are immutable
	2.	Proper lifecycle usage
	3.	Avoiding business logic inside UI
	4.	Thinking in terms of state flow
	5.	Preparing for structured state management

⸻

🔑 Final Takeaway

Chapter 1 builds the mental model required for the rest of the book:

Flutter apps are built from composable, immutable widgets driven by state — and good architecture determines whether your app scales or collapses.

⸻


If you'd like, I can also generate:
- A **print-friendly condensed version**
- A **developer notes version** (with practical refactoring tips)
- Or a **Notion-optimized markdown format**
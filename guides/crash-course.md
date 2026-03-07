# Flutter for React / C# Developers – Fast Ramp-Up Guide


## 1. Dart Differences (from C# / TypeScript)

Dart will feel very familiar if you know C#.

Variables

var name = "Plant";
final age = 3;
const pi = 3.14;

Keyword	Meaning
var	inferred type
final	runtime constant (similar to readonly)
const	compile-time constant

Example:

final DateTime now = DateTime.now();
const gravity = 9.8;


⸻

Classes

Dart classes are very similar to C#.

class Plant {
  final String name;

  Plant(this.name);
}

Expanded version:

class Plant {
  final String name;

  Plant(String name) : name = name;
}


⸻

Named Parameters

Dart frequently uses named parameters.

void addPlant({required String name, int count = 1}) {
  print("$name x$count");
}

Usage:

addPlant(name: "Rose", count: 2);

This pattern is used everywhere in Flutter widgets.

⸻

Async / Await

Works almost exactly like C#.

Future<List<String>> loadPlants() async {
  await Future.delayed(Duration(seconds: 1));
  return ["Rose", "Basil"];
}


⸻

Lists and Maps

var plants = ["Rose", "Basil", "Mint"];

var watering = {
  "Rose": 3,
  "Mint": 2
};


⸻

2. Understanding the Flutter Widget Tree

Flutter UI is built from widgets.

Everything is a widget:
	•	text
	•	buttons
	•	layout containers
	•	entire screens

Widgets are simply nested objects.

⸻

Example Screen

return Scaffold(
  appBar: AppBar(title: Text("GreenThumb")),
  body: Column(
    children: [
      Text("My Plants"),
      ElevatedButton(
        onPressed: () {},
        child: Text("Add Plant"),
      )
    ],
  ),
);

Widget tree representation:

Scaffold
 ├ AppBar
 │   └ Text
 └ Column
     ├ Text
     └ ElevatedButton
         └ Text


⸻

React vs Flutter

React:

<div>
  <h1>Plants</h1>
  <button>Add</button>
</div>

Flutter:

Column(
  children: [
    Text("Plants"),
    ElevatedButton(...)
  ],
)

Conceptually:

React	Flutter
JSX	Dart widget constructors
Component	Widget
DOM	Widget tree
CSS	Layout widgets

Flutter renders directly using Skia, not the DOM.

⸻

Stateless vs Stateful Widgets

Stateless

UI never changes.

class TitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("My Plants");
  }
}


⸻

Stateful

UI changes over time.

class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Text("$count");
  }
}

Updating state:

setState(() {
  count++;
});


⸻

3. Flutter Layout (Most Important Concept)

Flutter layout is similar to Flexbox.

The most common layout widgets are:

Widget	Equivalent
Row	flex row
Column	flex column
Expanded	flex-grow
Padding	padding
Container	div


⸻

Column Example

Column(
  children: [
    Text("Rose"),
    Text("Basil"),
    Text("Mint"),
  ],
)

Vertical layout.

⸻

Row Example

Row(
  children: [
    Text("Rose"),
    Icon(Icons.local_florist),
  ],
)

Horizontal layout.

⸻

Expanded (Flex Grow)

Row(
  children: [
    Expanded(child: Text("Plant Name")),
    Icon(Icons.edit)
  ],
)

Expanded takes remaining space.

⸻

Padding

Padding(
  padding: EdgeInsets.all(16),
  child: Text("Plant Name"),
)


⸻

Container

A general-purpose wrapper.

Container(
  padding: EdgeInsets.all(10),
  color: Colors.green,
  child: Text("Plant"),
)


⸻

4. A Typical Flutter Screen

Example plant list page.

class PlantListPage extends StatelessWidget {
  final plants = ["Rose", "Mint", "Basil"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GreenThumb")),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(plants[index]),
          );
        },
      ),
    );
  }
}


⸻

5. The 10 Flutter Concepts to Learn Early
	1.	StatelessWidget
	2.	StatefulWidget
	3.	BuildContext
	4.	Scaffold
	5.	ListView.builder
	6.	Navigator
	7.	FutureBuilder
	8.	setState
	9.	Expanded
	10.	MediaQuery

Once you understand these, you can build most Flutter apps.

⸻

Mental Model

Think of Flutter as:

React components
+ Flexbox layout
+ Native rendering engine

or

React + SwiftUI + Canvas

Everything is just nested widgets describing the UI.

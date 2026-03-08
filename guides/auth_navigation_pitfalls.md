# Flutter Auth & Navigation Pitfalls

This guide documents the common pitfalls encountered while implementing the App PIN and OTP recovery flow in the Auto Debit Tracker app.

## 1. The `mounted == false` Error in Async Calls

### The Problem
When performing an `await` on a navigation call (like `AppGuard.unlock()`), the widget that started the call might be removed from the screen before the `await` finishes. This is especially common during complex flows like "Forgot PIN".

### Why it happened
In our case, we were using `Navigator.pushReplacementNamed`. This **replaces** the current route. When the flow finished and tried to return a result to the original screen, that screen had already been unmounted because its route was destroyed.

### The Solution
*   **Always check `mounted`** after any `await` that involves navigation or long-running tasks.
*   **Avoid `pushReplacement`** if you need to return a result (`bool`) back to the calling screen.
*   **Bubble up success**: Instead of replacing screens, push them normally and have each screen `pop(true)` if the screen it pushed also returned `true`.

```dart
final ok = await Navigator.pushNamed(context, '/next-screen');
if (ok == true && mounted) {
  Navigator.pop(context, true); // Bubble the success up
}
```

## 2. Multiple Widget Instances in `IndexedStack`

### The Problem
`IndexedStack` (common in Bottom Navigation) initializes **all** of its children immediately. 

### Why it happened
`MainScreen` had three instances of `HomeScreen()`. When the app started, `initState` was called for all three simultaneously. Each instance tried to trigger the `AppGuard`, causing three concurrent authentication attempts and conflicting navigation states.

### The Solution
*   **Unique Children**: Ensure children in an `IndexedStack` are unique.
*   **Concurrency Locks**: Use a static variable to prevent multiple concurrent authentication triggers.

```dart
static bool _isUnlocking = false;

Future<void> _authenticate() async {
  if (_isUnlocking) return;
  _isUnlocking = true;
  try {
    await guard.unlock(context);
  } finally {
    _isUnlocking = false;
  }
}
```

## 3. Navigation Stack Reset vs. Pop

### The Problem
Using `pushNamedAndRemoveUntil(context, '/', ...)` resets the entire app state. While this "works" to get to the home screen, it breaks any `await` that was waiting for a result from the login/PIN screens.

### The Solution
Standardized on `pop(context, true)` for successful authentication. This allows the `AppGuard` (which is usually what started the push) to receive the result and decide what to do next.

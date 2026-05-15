# LINQ for Dart: A Guide for C# Developers

If you are coming from a C# background, Dart’s `Iterable` API provides almost all the same functionality as **LINQ Fluent Syntax**.

## 1. Quick Mapping Table

| C# LINQ | Dart (Iterable) | Description |
| :--- | :--- | :--- |
| `.Where(x => ...)` | `.where((x) => ...)` | Filters elements based on a predicate. |
| `.Select(x => ...)` | `.map((x) => ...)` | Projects/transforms each element. |
| `.FirstOrDefault()` | `.firstWhere(..., orElse: () => null)` | Returns the first match or a default value. |
| `.Any(x => ...)` | `.any((x) => ...)` | Checks if any element matches. |
| `.All(x => ...)` | `.every((x) => ...)` | Checks if all elements match. |
| `.ToList()` | `.toList()` | Eagerly evaluates and creates a List. |
| `.SelectMany()` | `.expand()` | Flattens a nested collection. |

---

## 2. Code Comparison

### Filtering & Selecting
**C#:**
```csharp
var names = users.Where(u => u.Age > 18).Select(u => u.Name).ToList();

**Dart:**
```dart
var names = users.where((u) => u.age > 18).map((u) => u.name).toList();

```
## 3. Critical Differences
 * **Mutation:** C# LINQ never modifies the original. In Dart, where and map are safe, but sort() and shuffle() modify the list **in-place**.
 * **The Cascade (..):** Use this to chain methods on the same object. var sorted = myList..sort();
 * **Collection If/For:** Dart allows logic directly inside list literals:
   ```dart
   var list = [
     'Home',
     if (isAdmin) 'Admin',
     for (var i in ids) 'User $i',
   ];
   
   ```
```

author: Pratham Sarankar
summary: Learn about variables and data types in Java with simple examples
id: krce-java-selenium-data-types-and-variables
categories: Java,Core
environments: Web
status: Published
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Data Types and Variables in Java

## Overview

Every program needs to store and work with data — numbers, text, true/false values, and more.
In Java, we use **variables** to store data and **data types** to tell Java what kind of data a variable holds.

Think of a variable like a labeled box: the label is the variable name, and the box can only hold a certain kind of item (the data type).

In this codelab, you will learn how to:
- understand what variables are and why we need them
- declare and use variables in Java
- learn the 8 primitive data types
- understand the difference between primitive and non-primitive types
- use type casting to convert between types

---

## What is a Variable?

A variable is a named container that stores a value in your program.
Instead of writing the same value everywhere, you store it once and refer to it by name.

### Real-life analogy

Imagine you have a jar with a label that says "age".
You put the number 20 inside the jar.
Later, when someone asks your age, you just look at the jar.

In Java, that looks like this:

```java
int age = 20;
```

Here:
- `int` is the **data type** (it tells Java this variable holds a whole number)
- `age` is the **variable name** (the label on the jar)
- `20` is the **value** (what's inside the jar)

---

## Declaring and Using Variables

### Declaring a variable

To create a variable, you write the data type, then the name:

```java
int score;
```

This creates a variable called `score` that can hold whole numbers, but it has no value yet.

### Assigning a value

You give a variable a value using the `=` sign:

```java
score = 95;
```

### Declare and assign together

You can do both in one line:

```java
int score = 95;
```

### Using the variable

Once a variable has a value, you can use it anywhere:

```java
public class VariableDemo {
    public static void main(String[] args) {
        int score = 95;
        System.out.println("Your score is: " + score);
    }
}
```

Output:
```text
Your score is: 95
```

---

## Rules for Naming Variables

Java has rules for variable names. Follow these to avoid errors:

| Rule | Valid | Invalid |
|------|-------|---------|
| Must start with a letter, `_`, or `$` | `age`, `_count`, `$price` | `1name`, `@value` |
| Cannot use Java keywords | `myClass` | `class`, `int` |
| Cannot contain spaces | `firstName` | `first name` |
| Case-sensitive | `Score` and `score` are different | — |

### Naming conventions (best practices)

- Use **camelCase** for variable names: `studentName`, `totalMarks`
- Keep names meaningful: `age` is better than `a`
- Start with a lowercase letter

---

## What are Data Types?

A data type tells Java what kind of value a variable can hold.

Java has two categories of data types:

1. **Primitive types** — simple, built-in types (8 total)
2. **Non-primitive types** — complex types like `String`, arrays, and classes

Let's start with primitive types.

---

## Primitive Data Types

Java has exactly **8 primitive data types**. Each one stores a different kind of simple value.

### How bits determine range

Before looking at the types, let's understand how the size (in bits) decides the range of values a type can hold.

A computer stores everything in **bits** (0s and 1s). A group of 8 bits is called a **byte**.

- With **1 bit**, you can represent 2 values: `0` or `1`
- With **2 bits**, you can represent 2² = 4 values: `00`, `01`, `10`, `11`
- With **n bits**, you can represent 2ⁿ total values

For **signed** types (which store both positive and negative numbers), one bit is used for the sign (+ or −). So the formula is:

**Range = −2⁽ⁿ⁻¹⁾ to 2⁽ⁿ⁻¹⁾ − 1**

For example, a `byte` has 8 bits:
- Total values: 2⁸ = 256
- Range: −2⁷ to 2⁷ − 1 = **-128 to 127**

Let's see this for all integer types:

| Type | Bits | Total values | Min (−2⁽ⁿ⁻¹⁾) | Max (2⁽ⁿ⁻¹⁾ − 1) |
|------|------|-------------|---|---|
| `byte` | 8 | 2⁸ = 256 | -128 | 127 |
| `short` | 16 | 2¹⁶ = 65,536 | -32,768 | 32,767 |
| `int` | 32 | 2³² ≈ 4.2 billion | -2,147,483,648 | 2,147,483,647 |
| `long` | 64 | 2⁶⁴ ≈ 18.4 quintillion | -9,223,372,036,854,775,808 | 9,223,372,036,854,775,807 |

### Integer types (whole numbers)

These store numbers without decimal points:

| Type | Size | Bits | Range | Example |
|------|------|------|-------|---------|
| `byte` | 1 byte | 8 bits | -128 to 127 | `byte b = 100;` |
| `short` | 2 bytes | 16 bits | -32,768 to 32,767 | `short s = 5000;` |
| `int` | 4 bytes | 32 bits | -2,147,483,648 to 2,147,483,647 | `int i = 100000;` |
| `long` | 8 bytes | 64 bits | -9.2 quintillion to 9.2 quintillion | `long l = 99999999L;` |

> **Tip:** `int` is the most commonly used. Use `long` only when you need very large numbers. Notice the `L` at the end of a `long` value.

### Floating-point types (decimal numbers)

These store numbers with decimal points. Floating-point types use the IEEE 754 standard, so their bits are split between sign, exponent, and fraction — the range formula is different from integers.

| Type | Size | Bits | Precision | Example |
|------|------|------|-----------|---------|
| `float` | 4 bytes | 32 bits (1 sign + 8 exponent + 23 fraction) | ~7 decimal digits | `float f = 3.14f;` |
| `double` | 8 bytes | 64 bits (1 sign + 11 exponent + 52 fraction) | ~15 decimal digits | `double d = 3.14159;` |

> **Tip:** `double` is the default for decimal numbers. Use `float` only when you need to save memory. Notice the `f` at the end of a `float` value.

### Character type

`char` stores a single character, wrapped in **single quotes**:

```java
char grade = 'A';
char symbol = '@';
```

| Type | Size | What it stores | Example |
|------|------|----------------|---------|
| `char` | 2 bytes | one Unicode character (0 to 65,535) | `char c = 'Z';` |

> **Note:** `char` is **unsigned** (no negative values). With 16 bits: 2¹⁶ = 65,536 possible characters (0 to 65,535). This is why Java supports Unicode characters from many languages.

### Boolean type

`boolean` stores only two values: `true` or `false`.

```java
boolean isPassed = true;
boolean isRaining = false;
```

| Type | Size | What it stores | Example |
|------|------|----------------|---------|
| `boolean` | 1 bit (JVM uses 1 byte internally) | `true` or `false` | `boolean b = true;` |

> **Note:** A boolean only needs 1 bit (2¹ = 2 values: true/false), but the JVM typically uses 1 byte for easier memory access.

---

## Try It: All 8 Primitive Types

Create a file called `DataTypesDemo.java` and try this:

```java
public class DataTypesDemo {
    public static void main(String[] args) {
        // Integer types
        byte myByte = 127;
        short myShort = 32000;
        int myInt = 100000;
        long myLong = 999999999L;

        // Floating-point types
        float myFloat = 3.14f;
        double myDouble = 3.14159265;

        // Character type
        char myChar = 'J';

        // Boolean type
        boolean myBool = true;

        // Print all values
        System.out.println("byte: " + myByte);
        System.out.println("short: " + myShort);
        System.out.println("int: " + myInt);
        System.out.println("long: " + myLong);
        System.out.println("float: " + myFloat);
        System.out.println("double: " + myDouble);
        System.out.println("char: " + myChar);
        System.out.println("boolean: " + myBool);
    }
}
```

Compile and run:
```bash
javac DataTypesDemo.java
java DataTypesDemo
```

Output:
```text
byte: 127
short: 32000
int: 100000
long: 999999999
float: 3.14
double: 3.14159265
char: J
boolean: true
```

---

## Non-Primitive Data Types

Non-primitive types are more complex. They are created from classes and can hold multiple values or have methods.

The most common non-primitive type beginners use is **String**.

### String

A `String` stores a sequence of characters (text), wrapped in **double quotes**:

```java
String name = "Java";
String greeting = "Hello, World!";
```

> **Key difference:** `char` uses single quotes (`'A'`) and holds one character. `String` uses double quotes (`"Hello"`) and can hold many characters.

### Other non-primitive types

You will learn these later in the course:
- **Arrays** — store multiple values of the same type
- **Classes** — blueprints for creating objects
- **Interfaces** — contracts that classes can follow

---

## Primitive vs Non-Primitive Types

| Feature | Primitive | Non-Primitive |
|---------|-----------|---------------|
| Defined by | Java (built-in) | Programmer or Java libraries |
| Starts with | lowercase (`int`, `char`) | uppercase (`String`, `Scanner`) |
| Can be null? | No | Yes |
| Has methods? | No | Yes |
| Examples | `int`, `double`, `boolean` | `String`, `Array`, `Scanner` |

Example to see the difference:

```java
int number = 42;              // primitive — just a value
String text = "Hello";        // non-primitive — has methods

System.out.println(text.length());  // 5 — String has a length() method
// number.length();  // ERROR — int has no methods
```

---

## Type Casting

Sometimes you need to convert a value from one type to another. This is called **type casting**.

### Widening casting (automatic)

Java automatically converts a smaller type to a larger type. This is safe because no data is lost.

```
byte → short → int → long → float → double
```

```java
int myInt = 100;
double myDouble = myInt;  // automatic — int to double

System.out.println(myInt);     // 100
System.out.println(myDouble);  // 100.0
```

### Narrowing casting (manual)

Converting a larger type to a smaller type must be done manually. You might lose data.

```java
double myDouble = 9.78;
int myInt = (int) myDouble;  // manual — double to int

System.out.println(myDouble);  // 9.78
System.out.println(myInt);     // 9  (decimal part is lost!)
```

> **Warning:** Narrowing casting can lose information. The decimal `.78` was dropped in the example above. Use it only when you are sure it's safe.

---

## Common Mistakes to Avoid

### 1. Using the wrong quotes

```java
char letter = "A";    // WRONG — double quotes are for String
char letter = 'A';    // CORRECT — single quotes for char

String name = 'Java'; // WRONG — single quotes are for char
String name = "Java"; // CORRECT — double quotes for String
```

### 2. Forgetting the suffix for float and long

```java
float pi = 3.14;      // WRONG — Java sees this as double
float pi = 3.14f;     // CORRECT — f tells Java it's a float

long big = 999999999;  // May work, but better to add L
long big = 999999999L; // CORRECT — L tells Java it's a long
```

### 3. Using a variable before assigning a value

```java
int score;
System.out.println(score);  // ERROR — score has no value yet
```

Always assign a value before using a variable.

---

## Quick Summary

| Concept | What it means |
|---------|---------------|
| Variable | A named container that stores a value |
| Data type | Tells Java what kind of value a variable holds |
| Primitive types | 8 simple built-in types (`byte`, `short`, `int`, `long`, `float`, `double`, `char`, `boolean`) |
| Non-primitive types | Complex types like `String`, arrays, and classes |
| Widening casting | Smaller type → larger type (automatic) |
| Narrowing casting | Larger type → smaller type (manual, may lose data) |

---

## Next Steps

- Practice creating variables of different types
- Try printing and combining variables in `System.out.println()`
- Learn about operators to do math and comparisons with variables
- Explore `String` methods like `length()`, `toUpperCase()`, and `charAt()`

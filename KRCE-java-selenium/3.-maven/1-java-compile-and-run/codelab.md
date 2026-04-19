author: Pratham Sarankar
summary: Learn how to compile and run Java programs using javac and a custom output directory
id: krce-java-selenium-maven-java-compile-and-run
categories: Java,Build Tools
environments: Web
status: Published
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Compile and Run Java Without Maven

## Overview

Before learning Maven, let's see how Java programs are built and executed manually.

In this codelab, you will learn how to:
- Compile multiple Java files using `javac`
- Put compiled `.class` files into a custom directory
- Run your Java program with `java`
- Understand why Maven makes this easier

---

## Why this matters

Java can be run without Maven, but it requires manual steps:
- Compiling source files to `.class`
- Managing output locations
- Setting the classpath correctly

By doing this manually once, you'll better understand why Maven is useful.

---

## Step 1: Create two Java files

Imagine you have two files:

`src/com/example/Helper.java`
```java
package com.example;

public class Helper {
    public static String getMessage() {
        return "Hello from Helper!";
    }
}
```

`src/com/example/App.java`
```java
package com.example;

public class App {
    public static void main(String[] args) {
        System.out.println("App started");
        System.out.println(Helper.getMessage());
    }
}
```

These files are part of the same package, so they must be compiled together.

---

## Step 2: Compile both files with javac

Open your command prompt or terminal and run:

```bash
javac -d out src/com/example/*.java
```

### What this command does:
- `javac` compiles Java source files
- `-d out` tells Java to put compiled `.class` files into the `out` folder
- `src/com/example/Helper.java` and `src/com/example/App.java` are the source files

After this command, you should have:

```
out/
└── com/
    └── example/
        ├── App.class
        └── Helper.class
```

---

## Step 3: Run the program

Now run the compiled program with:

```bash
java -cp out com.example.App
```

### What this command does:
- `java` starts the Java runtime
- `-cp out` sets the classpath to the folder containing compiled classes
- `com.example.App` is the fully qualified class name to run

You should see:

```
App started
Hello from Helper!
```

---

## Step 4: Use a custom output folder

You can choose any folder for compiled classes. For example:

```bash
javac -d build/classes src/com/example/*.java
java -cp build/classes com.example.App
```

This keeps your source code separate from compiled files.

---

## What you learned

- `javac` compiles Java source into `.class` files
- `-d` controls where compiled files are placed
- `java -cp` runs the program using the compiled classes
- Manual Java build steps can become repetitive as projects grow

**Next:** learn how to package Java code into a JAR file without Maven. This is the next natural step before we introduce Maven.

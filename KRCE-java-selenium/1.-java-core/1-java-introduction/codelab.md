author: Pratham Sarankar
summary: Learn what Java is, its brief history, and the basic features students should know
id: krce-java-selenium-java-introduction
categories: Java,Introduction
environments: Web
status: Published
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# What is Java?

## Overview

Java is a programming language used to build many kinds of applications.
We can use Java to create web services, desktop tools, and Android apps.

This codelab gives a simple introduction to Java, a short history, and the basic features that beginners should know.

In this codelab, you will learn how to:
- understand what Java is
- read a short history of Java
- learn the basic features of Java
- write and run a small Java program

---

## What is Java?

Java is:
- a high-level, easy-to-read programming language
- used for many different platforms and devices
- designed to be portable, safe, and easy to maintain

Java programs are written in files with `.java` and then run with Java tools.
Java is often described as "Write once, run anywhere" because the same program can work on many systems.

---

## Brief history of Java

Java started in the early 1990s at Sun Microsystems.
The goal was to make a language that could run on many machines and be easier to use than older languages.

- 1991: Java begins as a project led by James Gosling
- 1995: Java 1.0 is released to the public
- 2006: Java becomes open source with OpenJDK
- 2014: OpenJDK becomes the main reference implementation
- Today: Java continues to grow with regular updates and many tools

Java's history shows why it focuses on portability, stability, and backwards compatibility.

---

## Basic Java features

### 1. Simple and readable

Java uses English-like words and clear rules.
This makes it easier for students to read and write code.

### 2. Object-oriented

Java uses classes and objects to organize code.
This helps keep programs clean and easier to manage.

### 3. Platform independence

Java programs can run on many systems without changing the code.
This is one of Java's biggest strengths.

### 4. Automatic memory management

Java automatically cleans up unused objects.
This helps reduce common programming errors.

### 5. Security and reliability

Java checks code before it runs and prevents unsafe actions.
This makes Java a safer choice for many applications.

### 6. Standard library

Java includes many built-in tools for common tasks like working with text, files, and data.
Students can do more with less code.

---

## Try Java: Hello World

Create a file named `HelloWorld.java` with this code:

```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, Java!");
    }
}
```

Then run these commands:

```bash
javac HelloWorld.java
java HelloWorld
```

You should see:

```text
Hello, Java!
```

This shows how Java code is written, compiled, and run.

---

## Why this matters

Java is one of the most widely used programming languages.
A clear introduction helps students build confidence before learning more advanced topics.

---

## Next steps

- Learn Java variables, conditions, and loops
- Try writing your own class and method
- Explore Java collections and simple input/output

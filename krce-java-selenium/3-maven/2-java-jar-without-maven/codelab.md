author: Pratham Sarankar
summary: Learn how to create and run Java JAR files manually and use JARs without Maven
id: java-jar-without-maven
categories: Java,Build Tools
environments: Web
status: Published
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Create and Use Java JAR Files Without Maven

## Overview

Now that you know how to compile and run Java files manually, let's package Java classes into a JAR file.

In this codelab, you will learn how to:
- Create a JAR file from compiled `.class` files
- Run a JAR file with `java`
- Add external JAR files to your classpath without Maven
- See why Maven is helpful for jar management

---

## Step 1: Compile your Java code first

Use the same source code from the previous lesson.

Compile the code into a custom folder:

```bash
javac -d out src/com/example/Helper.java src/com/example/App.java
```

Now the compiled files are in:

```
out/com/example/App.class
out/com/example/Helper.class
```

---

## Step 2: Create a JAR file

A JAR file is a Java archive that bundles class files together.

Create the JAR with this command:

```bash
jar --create --file app.jar -C out .
```

### What this command does:
- `jar` is the Java archive tool
- `--create` makes a new JAR file
- `--file app.jar` names the output file
- `-C out .` includes all files from the `out` folder

After running this, you have:

```
app.jar
```

---

## Step 3: Run the JAR file

Run your program using:

```bash
java -cp app.jar com.example.App
```

This works because the JAR contains the compiled classes needed to run the application.

If you want to run a JAR directly, add a manifest file.

Create `manifest.txt`:

```text
Main-Class: com.example.App
```

Then create a JAR with the manifest:

```bash
jar --create --file app-with-manifest.jar --manifest manifest.txt -C out .
```

Now run it with:

```bash
java -jar app-with-manifest.jar
```

---

## Step 4: Add an external JAR file manually

In real projects, you often need external libraries packaged as JARs.

Suppose you have a library at `lib/example-lib.jar`.

Compile with the library on the classpath:

```bash
javac -cp lib/example-lib.jar -d out src/com/example/Helper.java src/com/example/App.java
```

Run with the same library:

```bash
java -cp out:lib/example-lib.jar com.example.App
```

> On Windows, use `;` instead of `:`:
> `java -cp out;lib/example-lib.jar com.example.App`

---

## Why this is hard without Maven

Manual JAR handling works, but it requires:
- managing compiled output folders
- writing long classpath commands
- creating and maintaining manifest files
- downloading and linking external JARs by hand

Maven automates these tasks and keeps your project organized.

**Next:** learn the Maven introduction and see how Maven solves these problems for you.

author: Pratham Sarankar
summary: Learn how to run Java projects with Maven and execute your application easily
id: krce-java-selenium-maven-run-java-project-with-maven
categories: Java,Maven,Build Tools
environments: Web
status: Published
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Running Java Projects with Maven

## Overview

Great! You've created your first Maven project. Now let's learn how to run it! 🚀

In this codelab, you will learn:
- Where Maven stores compiled files
- How to compile your code
- How to run your Java application using Maven

---

## Prerequisites

Before starting, make sure you have:
- ✅ **Maven installed** on your computer
- ✅ **JDK installed** (Java Development Kit)
- ✅ **A Maven project created** (from the previous codelab)
- ✅ **Basic Java knowledge**

---

## Step 1: Understanding Maven's File Structure

When you create a Maven project, here's where your files are stored:

### Your Project Structure:

```
my-first-maven-app/
├── src/
│   └── main/
│       └── java/
│           └── com/
│               └── krce/
│                   └── App.java          ← Your source code
├── target/                               ← Maven creates this!
│   └── classes/
│       └── com/
│           └── krce/
│               └── App.class             ← Compiled files go here
├── pom.xml
```

### Key Points:

| Location | Purpose |
|----------|---------|
| `src/main/java/` | Your Java source files (`.java`) |
| `target/classes/` | Compiled class files (`.class`) |
| `pom.xml` | Maven configuration file |

---

## Step 2: Compile Your Code

Before running your program, you need to compile it:

```bash
mvn compile
```

**What this does:**
- Reads Java files from `src/main/java/`
- Compiles them into `.class` files
- Stores them in `target/classes/`
- Checks for errors

**You should see:** `BUILD SUCCESS` ✅

---

## Step 3: Setup Maven Exec Plugin

To run your Java project easily with Maven, add this to your `pom.xml` file inside the `<project>` section:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.codehaus.mojo</groupId>
            <artifactId>exec-maven-plugin</artifactId>
            <version>3.1.0</version>
            <configuration>
                <mainClass>com.krce.App</mainClass>
            </configuration>
        </plugin>
    </plugins>
</build>
```

### What does this do?

- **`<plugin>`** - Tells Maven to use the exec plugin
- **`<mainClass>`** - Specifies which class has the `main()` method to run
- **`com.krce.App`** - Your package and class name (change this if different!)

---

## Step 4: Run Your Project

Now you can run your project with a simple command:

```bash
mvn exec:java
```

**What happens:**
1. Maven compiles your code (if needed)
2. Runs the `main()` method from the class you specified
3. Shows output in terminal

**Expected output (if you have "Hello World" program):**
```
Hello World!
```

---

## Step 5: Complete Example

Let's see a complete example step by step.

### Step 1: Your App.java

```java
package com.krce;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello from Maven!");
    }
}
```

### Step 2: Your pom.xml

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.krce</groupId>
    <artifactId>my-app</artifactId>
    <version>1.0</version>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.codehaus.mojo</groupId>
                <artifactId>exec-maven-plugin</artifactId>
                <version>3.1.0</version>
                <configuration>
                    <mainClass>com.krce.App</mainClass>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

### Step 3: Run It!

```bash
mvn compile
mvn exec:java
```

### Step 4: Output

```
Hello from Maven!
```

---

## Step 6: Important Maven Commands

Here are the essential commands:

| Command | What it does |
|---------|-------------|
| `mvn compile` | Compile your code |
| `mvn exec:java` | Run your application |
| `mvn clean` | Delete compiled files |
| `mvn clean compile` | Clean and compile |

---

## Step 7: Troubleshooting

### Problem 1: "Class not found"

**Error:**
```
[ERROR] Could not find the main class: com.krce.App
```

**Solution:**
- Check the class name in `<mainClass>` matches your actual class
- Make sure it includes the package name (e.g., `com.krce.App`)
- Run `mvn compile` first

### Problem 2: "BUILD FAILURE"

**Error:**
```
[ERROR] BUILD FAILURE
```

**Solution:**
1. Check your Java code for syntax errors
2. Run `mvn clean compile` to rebuild
3. Check the error messages

### Problem 3: "Class not in src/main/java"

**Error:**
```
[ERROR] COMPILATION ERROR
```

**Solution:**
- Make sure your `.java` files are in `src/main/java/`
- Directory structure must match package name (e.g., `com.krce` → `com/krce/`)

---

## Summary

✅ Compile code with `mvn compile`  
✅ Run code with `mvn exec:java`  
✅ Add exec-maven-plugin to `pom.xml`  
✅ Set correct `<mainClass>` in configuration  
✅ Compiled files stored in `target/classes/`  

**You now know how to run Java projects with Maven!** 🎉

---

## Next Steps

Try:
1. Create more Java classes in your project
2. Add methods and call them from main
3. Add dependencies to your project (JUnit, libraries, etc.)
4. Run tests with `mvn test`

**Happy coding!** 💪

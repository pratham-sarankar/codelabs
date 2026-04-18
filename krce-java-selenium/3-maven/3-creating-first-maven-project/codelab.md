author: Pratham Sarankar
summary: Learn to create your first Maven project in VS Code, run Maven commands, and add dependencies
id: maven-first-project
categories: Java,Maven,Build Tools,VS Code
environments: Web
status: Published
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Creating Your First Maven Project in VS Code

## Overview

Great job installing Maven! 🎉 Now it's time to create your first Maven project and see Maven in action.

In this codelab, you'll learn how to:
- Create a new Maven project using VS Code
- Understand the Maven project structure
- Run Maven commands (compile, test, package)
- Find and add dependencies to your project
- Run your Java application

**We'll use VS Code because it's popular and has great Maven support!**

---

## Prerequisites

Before starting, make sure you have:
- ✅ **Maven installed** (from the previous codelab)
- ✅ **VS Code installed** with Java extensions
- ✅ **JDK installed** and configured

**If you haven't installed VS Code yet:**
- Download from: https://code.visualstudio.com/
- Install the **"Extension Pack for Java"** from Microsoft

---

## Step 1: Create a New Maven Project

Let's create your first Maven project using VS Code.

### Using VS Code Command Palette:

1. **Open VS Code**

2. **Open Command Palette:**
   - Press `Ctrl+Shift+P` (Windows/Linux)
   - Or `Cmd+Shift+P` (Mac)

3. **Type and select:** `Maven: New Project`

4. **Choose an archetype:**
   - Select `maven-archetype-quickstart`
   - This creates a simple Java project template

5. **Select version of maven-archetype-quickstart**
   - Select `1.4`

6. **Input Group Id of your project.**
   - It is a unique identifier for your project, usually in reverse domain name format. 
   - For example: `com.example`

7. **Input Artifact Id (also as project name) of your project.**
   - It is the name of your project. 
   - For example: `my-first-maven-app`

8. **Select a location to save your project.**
   - Choose a folder where you want to create your project.

9. **Default value for property 'version' 1.0-SNAPSHOT, press Enter to confirm.**
   - Version is used to manage different releases of your project. 
   - You can leave it as default for now. 

10. **It will ask to confirm the project details, press Enter to confirm**

11. **Open the created folder in VS Code**

---

## Step 2: Explore the Project Structure

Let's look at what Maven created for you.

### Your Project Structure Should Look Like:
```
my-first-maven-app/
├── src/
│   ├── main/
│   │   └── java/
│   │       └── com/
│   │           └── example/
│   │               └── App.java
│   └── test/
│       └── java/
│           └── com/
│           └── example/
│               └── AppTest.java
├── pom.xml
└── target/ (created after building)
```

### What Each Part Does:

**`src/main/java/`** - Your main Java code goes here  
**`src/test/java/`** - Your test code goes here  
**`pom.xml`** - Maven's instruction file  
**`target/`** - Where Maven puts compiled files (created later)

### The Default App.java File:

Maven created a simple "Hello World" program. Let's look at it:

```java
package com.example;

/**
 * Hello world!
 */
public class App {
    public static void main(String[] args) {
        System.out.println("Hello World!");
    }
}
```

**This is your starting point!** You can modify this code.

---

## Step 3: Run Your First Maven Commands

Now let's see Maven in action by running some commands.

### Open VS Code Terminal:
- Press `Ctrl+`` (backtick) to open integrated terminal
- Make sure you're in your project folder

### Command 1: Compile Your Code
```bash
mvn compile
```

**What it does:**
- Converts `.java` files to `.class` files
- Puts compiled files in `target/classes/`
- Checks for compilation errors

**Expected output:** `BUILD SUCCESS`

### Command 2: Run Tests
```bash
mvn test
```

**What it does:**
- Runs all test files in `src/test/java/`
- Uses JUnit (included by default)
- Shows test results

**Expected output:** Tests pass ✅

### Command 3: Package Your Application
```bash
mvn package
```

**What it does:**
- Compiles code
- Runs tests
- Creates a JAR file in `target/`
- JAR file: `my-first-maven-app-1.0-SNAPSHOT.jar`

**Expected output:** `BUILD SUCCESS`

### Command 4: Run Your Application
```bash
java -cp target/classes com.example.App
```

**What it does:**
- Runs your Java program
- Uses the compiled classes from `target/classes/`

**Expected output:** `Hello World!`

---

## Step 4: Understanding pom.xml

The `pom.xml` file is Maven's configuration file. Let's understand it.

### Your Current pom.xml:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>my-first-maven-app</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
    </properties>

    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
```

### Key Parts Explained:

**`<groupId>`** - Your organization/group name  
**`<artifactId>`** - Your project name  
**`<version>`** - Project version  
**`<properties>`** - Java version settings  
**`<dependencies>`** - External libraries you need  

---

## Step 5: Finding and Adding Dependencies

Dependencies are external libraries that add functionality to your project.

### Where to Find Dependencies:

**Maven Central Repository** - The main place to find Java libraries
- Website: https://central.sonatype.com/
- Search for libraries by name

### Popular Dependencies Examples:

| Library | Purpose | Maven Coordinates |
|---------|---------|-------------------|
| JUnit 5 | Testing | `org.junit.jupiter:junit-jupiter:5.9.2` |
| Jackson | JSON processing | `com.fasterxml.jackson.core:jackson-databind:2.15.2` |
| Apache Commons Lang | String utilities | `org.apache.commons:commons-lang3:3.12.0` |
| Log4j | Logging | `org.apache.logging.log4j:log4j-core:2.20.0` |

### How to Add a Dependency:

Let's add Apache Commons Lang for string utilities.

1. **Search for "commons-lang3" on Maven Central**

2. **Find the Maven coordinates:**
   ```xml
   <dependency>
       <groupId>org.apache.commons</groupId>
       <artifactId>commons-lang3</artifactId>
       <version>3.12.0</version>
   </dependency>
   ```

3. **Add to your pom.xml inside `<dependencies>`:**
   ```xml
   <dependencies>
       <dependency>
           <groupId>junit</groupId>
           <artifactId>junit</artifactId>
           <version>4.13.2</version>
           <scope>test</scope>
       </dependency>
       
       <!-- Add this new dependency -->
       <dependency>
           <groupId>org.apache.commons</groupId>
           <artifactId>commons-lang3</artifactId>
           <version>3.12.0</version>
       </dependency>
   </dependencies>
   ```

4. **Save pom.xml**

5. **Run `mvn compile`** to download the dependency

### Using the New Dependency:

Update your `App.java`:

```java
package com.example;

import org.apache.commons.lang3.StringUtils;

public class App {
    public static void main(String[] args) {
        String text = "hello world";
        String capitalized = StringUtils.capitalize(text);
        System.out.println("Original: " + text);
        System.out.println("Capitalized: " + capitalized);
    }
}
```

**Run with:** `mvn compile exec:java -Dexec.mainClass="com.example.App"`

---

## Step 6: VS Code Maven Integration

VS Code has built-in Maven support that makes development easier.

### Maven View in VS Code:

1. **Open Command Palette:** `Ctrl+Shift+P`

2. **Type:** `Maven: Show Maven Projects`

3. **You'll see:**
   - Your project listed
   - Available Maven commands
   - Dependencies view

### Quick Commands in VS Code:

- **Right-click on pom.xml** → "Run Maven Commands"
- **Use Maven Explorer** to run compile, test, package
- **Automatic dependency download** when you save pom.xml

### Debugging in VS Code:

1. **Set breakpoints** in your Java code
2. **Right-click** → "Debug Java"
3. **VS Code will run Maven and attach debugger**

---

## Step 7: Common Maven Commands

Here are the most useful Maven commands:

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `mvn compile` | Compile source code | After writing code |
| `mvn test` | Run unit tests | After writing tests |
| `mvn package` | Create JAR file | To distribute your app |
| `mvn clean` | Delete target folder | To start fresh |
| `mvn install` | Install to local repo | For multi-module projects |
| `mvn dependency:tree` | Show dependency tree | To see what libraries you have |

### Useful Command Combinations:

```bash
# Clean and compile
mvn clean compile

# Compile and test
mvn clean test

# Full build (clean, compile, test, package)
mvn clean package

# Skip tests (faster, but not recommended)
mvn package -DskipTests
```

---

## Troubleshooting Common Issues

### Issue 1: "Package does not exist"
**Solution:** Run `mvn compile` first, or check your imports

### Issue 2: "Dependency not found"
**Solution:** 
- Check spelling in pom.xml
- Run `mvn clean compile`
- Verify dependency coordinates on Maven Central

### Issue 3: "Java version mismatch"
**Solution:** Update `<maven.compiler.source>` and `<maven.compiler.target>` in pom.xml

### Issue 4: "Port already in use"
**Solution:** Kill process using the port, or change port in application

---

## What You Learned

In this codelab, you learned how to:

✅ **Create Maven projects** using VS Code  
✅ **Understand project structure** (src/main/java, pom.xml, etc.)  
✅ **Run Maven commands** (compile, test, package)  
✅ **Find dependencies** on Maven Central  
✅ **Add dependencies** to pom.xml  
✅ **Run Java applications** with Maven  
✅ **Use VS Code Maven integration**  

**You now have a working Maven project!** 🎉

---

## Next Steps

Now that you can create and run Maven projects, you can:

1. **Add more dependencies** for different functionality
2. **Write unit tests** with JUnit
3. **Create executable JARs** for distribution
4. **Learn about Maven profiles** for different environments
5. **Explore multi-module Maven projects**

**Ready to add some cool features to your project?** 🚀

---

## Quick Quiz

Test what you learned:

1. What VS Code command creates a Maven project? (Maven: Create Maven Project)
2. What folder contains your main Java code? (src/main/java)
3. What file configures Maven dependencies? (pom.xml)
4. Where do you find Java libraries to add? (Maven Central Repository)
5. What command compiles and packages your app? (mvn package)

**Fantastic work!** You've created and run your first Maven project. 💪</content>
<parameter name="filePath">/Users/prathamsarankar/Documents/Projects/codelabs/krce-java-selenium/3-maven/3-creating-first-maven-project/codelab.md
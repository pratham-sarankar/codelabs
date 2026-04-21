author: Pratham Sarankar
summary: Learn Selenium WebDriver basics and create your first automation script to open Google in Chrome
id: selenium-introduction
categories: Java,Selenium,Web Automation,Testing
environments: Web
status: Published
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Introduction to Selenium WebDriver

## Overview

Welcome to the world of web automation! 🚀 In this codelab, you will create your first Selenium script that controls a web browser.

By the end of this lesson, you will:
- Understand what Selenium is
- Create a Maven project with Selenium
- Add Selenium as a dependency
- Write a test that opens Google.com in Chrome
- Run your first web automation script

**Let's build something cool!** 💪

---

## Prerequisites

Before starting, make sure you have:
- ✅ **Maven installed** and working
- ✅ **JDK installed** (Java Development Kit)
- ✅ **Google Chrome browser** installed
- ✅ **Completed the Maven codelabs** (you know how to create and run Maven projects)

---

## What is Selenium?

**Selenium is a tool that lets your Java program control web browsers automatically.**

With Selenium, you can write code to:
- Open websites
- Click buttons
- Fill forms
- Read text from pages
- Take screenshots
- Test web applications

**Example:** Instead of manually opening Chrome and going to Google, you write Java code to do it automatically!

---

## Step 1: Create a New Maven Project

Just like in the previous Maven codelabs, create a new Maven project. Open your terminal and run:

```bash
mvn archetype:generate -DgroupId=com.krce -DartifactId=selenium-project -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false
```

Or use VS Code's Maven command palette option.

### Your Project Structure:

```
selenium-project/
├── src/
│   ├── main/
│   │   └── java/
│   │       └── com/krce/
│   │           └── App.java
│   └── test/
│       └── java/
│           └── com/krce/
│               └── AppTest.java
├── pom.xml
└── target/
```

---

## Step 2: Add Selenium Dependency

Selenium is an external library, so we need to add it as a dependency in `pom.xml`.

Open your `pom.xml` file and add Selenium in the `<dependencies>` section:

```xml
<dependencies>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.13.2</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Add Selenium dependency -->
    <dependency>
        <groupId>org.seleniumhq.selenium</groupId>
        <artifactId>selenium-java</artifactId>
        <version>4.15.0</version>
    </dependency>
</dependencies>
```

**This tells Maven to download and include Selenium in your project.**

---

## Step 3: Add Maven Exec Plugin

Add the exec plugin configuration (from the previous Maven codelab) to run your Selenium test:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.codehaus.mojo</groupId>
            <artifactId>exec-maven-plugin</artifactId>
            <version>3.1.0</version>
            <configuration>
                <mainClass>com.krce.GoogleTest</mainClass>
            </configuration>
        </plugin>
    </plugins>
</build>
```

**Note:** We'll create `GoogleTest` class in the next step.

---

## Step 4: Create Your First Selenium Test

Create a new Java file in `src/main/java/com/krce/GoogleTest.java`:

```java
package com.krce;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

public class GoogleTest {
    public static void main(String[] args) {
        // Create a Chrome WebDriver
        WebDriver driver = new ChromeDriver();
        
        // Open Google.com
        driver.get("https://www.google.com");
        
        // Print page title
        System.out.println("Page title: " + driver.getTitle());
        
        // Keep browser open for 3 seconds
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
        // Close the browser
        driver.quit();
        
        System.out.println("Test completed!");
    }
}
```

### What does this code do?

| Line | What it does |
|------|------------|
| `new ChromeDriver()` | Creates a Chrome browser instance |
| `driver.get("...")` | Navigates to Google.com |
| `driver.getTitle()` | Gets the page title |
| `Thread.sleep(3000)` | Keeps browser open for 3 seconds |
| `driver.quit()` | Closes the browser |

---

## Step 5: Compile Your Project

```bash
mvn compile
```

Maven will download Selenium and compile your code. You should see:

```
[INFO] BUILD SUCCESS
```

---

## Step 6: Download ChromeDriver

Selenium needs a special driver to control Chrome. Download ChromeDriver:

1. Go to: https://googlechromelabs.github.io/chrome-for-testing/
2. Download the ChromeDriver for your operating system
3. Extract the file
4. Note the path to the `chromedriver` file

### Set up ChromeDriver Path

Before running the test, tell Selenium where to find ChromeDriver.

**On Mac/Linux:**
```bash
export PATH="/path/to/chromedriver:$PATH"
```

**On Windows:**
Add the ChromeDriver folder to your system PATH environment variable.

Or you can set it in Java code:
```java
System.setProperty("webdriver.chrome.driver", "/path/to/chromedriver");
WebDriver driver = new ChromeDriver();
```

---

## Step 7: Run Your Selenium Test

```bash
mvn exec:java
```

**What will happen:**

1. ✅ Chrome browser will open automatically
2. ✅ It will navigate to Google.com
3. ✅ The browser will stay open for 3 seconds
4. ✅ Console will print the page title
5. ✅ Browser will close automatically
6. ✅ Test completes!

**Expected output:**
```
Page title: Google
Test completed!
```

---

## Step 8: Complete pom.xml Example

Here's what your complete `pom.xml` should look like:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.krce</groupId>
    <artifactId>selenium-project</artifactId>
    <version>1.0</version>

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
        
        <dependency>
            <groupId>org.seleniumhq.selenium</groupId>
            <artifactId>selenium-java</artifactId>
            <version>4.15.0</version>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.codehaus.mojo</groupId>
                <artifactId>exec-maven-plugin</artifactId>
                <version>3.1.0</version>
                <configuration>
                    <mainClass>com.krce.GoogleTest</mainClass>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

---

## Troubleshooting

### Issue 1: "chrome driver executable not found"

**Error:**
```
The path to the driver executable must be set by the webdriver.chrome.driver system property
```

**Solution:**
- Make sure ChromeDriver is downloaded and accessible
- Set the path using `System.setProperty()` in your code:
```java
System.setProperty("webdriver.chrome.driver", "/path/to/chromedriver");
```

### Issue 2: "Chrome version mismatch"

**Error:**
```
This version of ChromeDriver only supports Chrome version XX
```

**Solution:**
- Download ChromeDriver that matches your Chrome browser version
- Check your Chrome version: Menu → About Google Chrome

### Issue 3: "BUILD FAILURE during mvn compile"

**Error:**
```
[ERROR] BUILD FAILURE
```

**Solution:**
1. Check Maven is installed: `mvn --version`
2. Make sure pom.xml has correct Selenium dependency
3. Run `mvn clean compile` to start fresh

---

## Summary

✅ Created a Maven project  
✅ Added Selenium dependency in `pom.xml`  
✅ Created a Java class that opens Chrome and navigates to Google  
✅ Compiled and ran the Selenium test  
✅ Saw Chrome open and close automatically!

**You've written your first Selenium script!** 🎉

---

## What You Learned

- **Selenium** lets you control web browsers with Java code
- **WebDriver** is the main Selenium class for browser control
- **Maven** helps manage Selenium as a dependency
- **ChromeDriver** is needed to control Chrome browser
- You can automate browser actions with just a few lines of code

---

## Next Steps

Now that you can open websites, try:

1. Finding and clicking buttons
2. Typing text in search boxes
3. Reading text from web pages
4. Taking screenshots
5. Handling multiple browser windows

**Ready to build more advanced scripts?** 🚀
</content>
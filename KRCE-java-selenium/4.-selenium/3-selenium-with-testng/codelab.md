author: Pratham Sarankar
summary: Learn Selenium automation with TestNG by creating and running your first real test class
id: selenium-with-testng
categories: Java,Selenium,TestNG,Web Automation,Testing
environments: Web
status: Draft
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Selenium with TestNG

## Overview

In this codelab, you will learn how to write Selenium tests using **TestNG**.

Until now, you ran Selenium scripts from a `main()` method. In real projects, we usually use test frameworks like TestNG to organize test cases, execute them cleanly, and generate useful reports.

By the end of this lesson, you will:
- Understand why TestNG is used with Selenium
- Create a Selenium + TestNG Maven setup
- Use `@BeforeMethod`, `@AfterMethod`, and `@Test`
- Add assertions using `Assert`
- Run tests from Maven

---

## Prerequisites

Before starting, make sure you have:
- Maven installed and working
- JDK installed (Java Development Kit)
- Google Chrome browser installed
- Basic Selenium knowledge from `4.-selenium/1-introduction/codelab.md`

---

## Step 1: Create (or Reuse) a Maven Project

You can reuse your Selenium project, or create a new one:

```bash
mvn archetype:generate -DgroupId=com.krce -DartifactId=selenium-testng-project -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false
```

If you created a new project, move into it:

```bash
cd selenium-testng-project
```

---

## Step 2: Add Selenium + TestNG Dependencies

Open `pom.xml` and update your dependencies.

```xml
<dependencies>
    <dependency>
        <groupId>org.seleniumhq.selenium</groupId>
        <artifactId>selenium-java</artifactId>
        <version>4.15.0</version>
    </dependency>

    <dependency>
        <groupId>org.testng</groupId>
        <artifactId>testng</artifactId>
        <version>7.10.2</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

Also add Surefire plugin so Maven runs TestNG tests correctly:

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.2.5</version>
        </plugin>
    </plugins>
</build>
```

---

## Step 3: Understand Basic TestNG Annotations

These are the most-used annotations for beginner Selenium tests:

| Annotation | Purpose |
|------|------|
| `@BeforeMethod` | Runs before every test method |
| `@AfterMethod` | Runs after every test method |
| `@Test` | Marks a method as a test case |

Simple execution flow:

1. `@BeforeMethod` opens the browser
2. `@Test` executes your validation steps
3. `@AfterMethod` closes the browser

---

## Step 4: Create Your First Selenium TestNG Class

Create `src/test/java/com/krce/GoogleSearchTest.java`:

```java
package com.krce;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.Assert;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

public class GoogleSearchTest {

    private WebDriver driver;

    @BeforeMethod
    public void setup() {
        driver = new ChromeDriver();
        driver.manage().window().maximize();
    }

    @Test
    public void verifyGoogleTitle() {
        driver.get("https://www.google.com");
        String actualTitle = driver.getTitle();
        Assert.assertTrue(actualTitle.contains("Google"), "Title should contain Google");
    }

    @Test
    public void verifySearchBoxDisplayed() {
        driver.get("https://www.google.com");
        WebElement searchBox = driver.findElement(By.name("q"));
        Assert.assertTrue(searchBox.isDisplayed(), "Search box should be visible");
    }

    @AfterMethod
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}
```

What this class teaches:
- Browser setup and cleanup using TestNG lifecycle methods
- Two independent test cases
- Assertions to mark pass/fail

---

## Step 5: Run the Tests

Run all test classes:

```bash
mvn test
```

Expected behavior:
1. Chrome opens for each test method
2. Test methods run one by one
3. Browser closes after each test
4. Maven shows test pass/fail result

---

## Step 6: Add a Small Real-World Example (Login Page)

Now create a slightly more practical test class.

Create `src/test/java/com/krce/HerokuLoginTest.java`:

```java
package com.krce;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.Assert;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

public class HerokuLoginTest {

    private WebDriver driver;

    @BeforeMethod
    public void setup() {
        driver = new ChromeDriver();
    }

    @Test
    public void validLoginShouldShowSuccessMessage() {
        driver.get("https://the-internet.herokuapp.com/login");
        driver.findElement(By.id("username")).sendKeys("tomsmith");
        driver.findElement(By.id("password")).sendKeys("SuperSecretPassword!");
        driver.findElement(By.cssSelector("button[type='submit']")).click();

        String flashMessage = driver.findElement(By.id("flash")).getText();
        Assert.assertTrue(flashMessage.contains("You logged into a secure area!"),
                "Success message should be displayed after login");
    }

    @AfterMethod
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}
```

This is the same Selenium automation flow you already know, but now wrapped in a proper test framework.

---

## Step 7: TestNG Assertions Cheat Sheet

Most common assertions:

- `Assert.assertTrue(condition)`
- `Assert.assertFalse(condition)`
- `Assert.assertEquals(actual, expected)`
- `Assert.assertNotNull(value)`

Example:

```java
Assert.assertEquals(driver.getTitle(), "Google", "Title mismatch");
```

If assertion fails, TestNG marks the test as failed and shows the reason.

---

## Step 8: Optional - Run Selected Test Class

To run only one class:

```bash
mvn -Dtest=GoogleSearchTest test
```

To run only one method:

```bash
mvn -Dtest=GoogleSearchTest#verifyGoogleTitle test
```

---

## Troubleshooting

### Issue: Tests do not run

Cause:
- Test class not in `src/test/java`
- Missing TestNG dependency

Solution:
- Keep classes under `src/test/java`
- Recheck `pom.xml` dependency and plugin

### Issue: `NoSuchSessionException` or browser closes too early

Cause:
- Browser reused incorrectly or closed before test step

Solution:
- Create driver in `@BeforeMethod`
- Close with `driver.quit()` in `@AfterMethod`

### Issue: Element not found

Cause:
- Wrong locator or page not loaded fully

Solution:
- Recheck locator
- Add explicit wait in advanced tests

---

## Summary

In this codelab, you learned how to combine Selenium with TestNG:

- Created Selenium + TestNG project setup
- Used `@BeforeMethod`, `@Test`, and `@AfterMethod`
- Wrote assertions with `Assert`
- Ran tests using `mvn test`
- Built a practical login test scenario

You now have a clean testing foundation to move from scripts to real automation test cases.

---

## Next Steps

In the next codelab, you can learn:

1. Data-driven testing with `@DataProvider`
2. Better reporting with listeners
3. Reusable BaseTest architecture
4. Explicit waits and robust locator strategy


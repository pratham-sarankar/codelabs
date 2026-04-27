author: Pratham Sarankar
summary: Learn data-driven Selenium testing with TestNG DataProvider by running one test with multiple input sets
id: selenium-data-driven-testing-with-testng
categories: Java,Selenium,TestNG,Data-Driven Testing,Web Automation
environments: Web
status: Draft
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Data-Driven Testing with Selenium and TestNG

## Overview

In this codelab, you will learn how to run the same Selenium test with multiple data sets using TestNG `@DataProvider`.

In real projects, hardcoding one username/password in one test is not enough. We need to validate many input combinations without duplicating test methods.

By the end of this lesson, you will:
- Understand what data-driven testing means
- Use `@DataProvider` in TestNG
- Pass multiple inputs to one Selenium test
- Validate both success and failure login scenarios
- Run and analyze data-driven test output

---

## Prerequisites

Before starting, make sure you have:
- Maven installed and working
- JDK installed (Java Development Kit)
- Google Chrome browser installed
- Completed `Selenium with TestNG codelab`

---

## Step 1: Create (or Reuse) a Maven Project

You can reuse your existing Selenium + TestNG project, or create a new one:

```bash
mvn archetype:generate -DgroupId=com.krce -DartifactId=selenium-data-driven-project -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false
```

If you created a new project, move into it:

```bash
cd selenium-data-driven-project
```

---

## Step 2: Add Selenium + TestNG Setup

Open `pom.xml` and verify these dependencies:

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

Also keep Surefire plugin in `build` so TestNG tests run through Maven:

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

## Step 3: Understand `@DataProvider`

`@DataProvider` returns data for a test method.

- Each row in `Object[][]` is one test run.
- Columns in each row map to parameters in `@Test` method.
- TestNG runs the same test once per row.

Example shape:

```java
@DataProvider(name = "sampleData")
public Object[][] sampleData() {
    return new Object[][] {
        {"value1", "value2"},
        {"value3", "value4"}
    };
}
```

---

## Step 4: Create a Data-Driven Selenium Test Class

Create `src/test/java/com/krce/HerokuLoginDataDrivenTest.java`:

```java
package com.krce;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.Assert;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

public class HerokuLoginDataDrivenTest {

    private WebDriver driver;

    @BeforeMethod
    public void setup() {
        driver = new ChromeDriver();
        driver.manage().window().maximize();
    }

    @DataProvider(name = "loginData")
    public Object[][] loginData() {
        return new Object[][]{
                {"tomsmith", "SuperSecretPassword!", true, "You logged into a secure area!"},
                {"tomsmith", "WrongPassword", false, "Your password is invalid!"},
                {"wrongUser", "SuperSecretPassword!", false, "Your username is invalid!"}
        };
    }

    @Test(dataProvider = "loginData")
    public void verifyLoginBehavior(String username,
                                    String password,
                                    boolean shouldLoginSucceed,
                                    String expectedMessagePart) {

        driver.get("https://the-internet.herokuapp.com/login");

        driver.findElement(By.id("username")).clear();
        driver.findElement(By.id("username")).sendKeys(username);

        driver.findElement(By.id("password")).clear();
        driver.findElement(By.id("password")).sendKeys(password);

        driver.findElement(By.cssSelector("button[type='submit']")).click();

        String flashMessage = driver.findElement(By.id("flash")).getText();
        Assert.assertTrue(
                flashMessage.contains(expectedMessagePart),
                "Expected flash message part was not found"
        );

        if (shouldLoginSucceed) {
            Assert.assertTrue(driver.getCurrentUrl().contains("/secure"),
                    "Expected to be on secure page for valid credentials");
        } else {
            Assert.assertTrue(driver.getCurrentUrl().contains("/login"),
                    "Expected to stay on login page for invalid credentials");
        }
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
- One test method can validate multiple scenarios
- Inputs and expected results are centralized in `@DataProvider`
- Assertions can change behavior based on expected outcome

---

## Step 5: Run Data-Driven Tests

Run all tests:

```bash
mvn test
```

Run only this class:

```bash
mvn -Dtest=HerokuLoginDataDrivenTest test
```

What you should observe:
1. Same test method runs once per data row
2. Each run gets different input values
3. Maven/TestNG report shows each run result

---

## Step 6: Optional - Name Data Sets for Better Reports

You can add a readable test name in your dataset and print it:

```java
{"valid login", "tomsmith", "SuperSecretPassword!", true, "You logged into a secure area!"}
```

Then use that first parameter in the test method for easier debugging in reports.

---

## Step 7: Best Practices for Data-Driven Tests

- Keep test logic in `@Test`, data in `@DataProvider`
- Include both positive and negative scenarios
- Keep expected result fields in the dataset
- Start with small in-code datasets, then move to CSV/Excel later
- Avoid very large datasets in one test class

---

## Troubleshooting

### Issue: `Data provider mismatch` or parameter errors

Cause:
- Number/type of columns does not match test method parameters.

Solution:
- Recheck `Object[][]` column count and parameter order.

### Issue: Tests run only once

Cause:
- `@Test(dataProvider = "...")` missing or provider name mismatch.

Solution:
- Use exact same provider name in `@DataProvider(name = "...")` and `@Test`.

### Issue: Flaky failure on flash message

Cause:
- Message may include extra text or formatting.

Solution:
- Validate with `contains(...)` instead of strict full string match.

---

## Summary

In this codelab, you learned how to build data-driven Selenium tests using TestNG:

- Used `@DataProvider` to supply multiple input sets
- Ran one test method many times with different values
- Validated both valid and invalid login behavior
- Improved test scalability without duplicate code

You now have the core skill needed to write practical, maintainable UI tests.

---

## Next Steps

In the next codelab, you can learn:

1. Page Object Model (POM) for clean reusable classes
2. BaseTest design for common setup and teardown
3. TestNG groups and `testng.xml` suite execution
4. Screenshot capture and listeners on test failure


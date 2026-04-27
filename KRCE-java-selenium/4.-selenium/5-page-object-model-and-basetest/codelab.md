author: Pratham Sarankar
summary: Learn Page Object Model (POM) and BaseTest design to build maintainable, reusable Selenium automation frameworks
id: selenium-page-object-model-and-basetest
categories: Java,Selenium,TestNG,Page Object Model,Framework Design,Web Automation
environments: Web
status: Draft
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Page Object Model and BaseTest

## Overview

In this codelab, you will learn the **Page Object Model (POM)** design pattern — the industry standard for building scalable Selenium automation frameworks.

Until now, you hardcoded locators and browser setup in test methods. This works for small projects, but when you have 50+ tests, changes to the application break many tests.

POM separates test logic from page mechanics:
- **Page classes** hold HTML locators and page actions
- **Test classes** contain only business logic and assertions
- **BaseTest** handles common setup/teardown

By the end of this lesson, you will:
- Understand why Page Object Model matters
- Create reusable page classes
- Build a BaseTest for shared browser management
- Refactor data-driven tests using POM
- Maintain tests easily as the application changes

---

## Prerequisites

Before starting, make sure you have:
- Maven installed and working
- JDK installed (Java Development Kit)
- Google Chrome browser installed
- Completed `4.-selenium/4-data-driven-testing-with-testng/codelab.md`

---

## Step 1: Create (or Reuse) a Maven Project

You can reuse your existing Selenium + TestNG project, or create a new one:

```bash
mvn archetype:generate -DgroupId=com.krce -DartifactId=selenium-pom-framework -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false
```

If you created a new project, move into it:

```bash
cd selenium-pom-framework
```

---

## Step 2: Verify Dependencies

Open `pom.xml` and confirm you have:

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

## Step 3: Understand Page Object Model (POM)

**Before POM:**
```
Test class has test + locators + actions mixed together
```

**With POM:**
```
Page class → holds locators and page actions
Test class → uses page class methods, only has business logic
```

Example flow:
1. Test calls `loginPage.enterUsername("user")`
2. Page class finds the username locator and sends text
3. Test never directly touches `By.id("username")`
4. When app changes, you update only page class

---

## Step 4: Create Base Test Class

Create `src/test/java/com/krce/BaseTest.java`:

```java
package com.krce;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;

import java.time.Duration;

public class BaseTest {

    protected WebDriver driver;

    @BeforeMethod
    public void setup() {
        driver = new ChromeDriver();
        driver.manage().window().maximize();
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
    }

    @AfterMethod
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}
```

What this class provides:
- Shared browser initialization
- Implicit waits configured once
- Cleanup logic in one place
- All test classes can extend and reuse

---

## Step 5: Create a Login Page Object Class

Create `src/test/java/com/krce/pages/LoginPage.java`:

```java
package com.krce.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class LoginPage {

    private WebDriver driver;

    // Locators (grouped at the top)
    private By usernameField = By.id("username");
    private By passwordField = By.id("password");
    private By submitButton = By.cssSelector("button[type='submit']");
    private By flashMessage = By.id("flash");

    // Constructor
    public LoginPage(WebDriver driver) {
        this.driver = driver;
    }

    // Page actions (methods that do something)
    public void enterUsername(String username) {
        driver.findElement(usernameField).clear();
        driver.findElement(usernameField).sendKeys(username);
    }

    public void enterPassword(String password) {
        driver.findElement(passwordField).clear();
        driver.findElement(passwordField).sendKeys(password);
    }

    public void clickSubmit() {
        driver.findElement(submitButton).click();
    }

    public String getFlashMessage() {
        return driver.findElement(flashMessage).getText();
    }

    public String getCurrentUrl() {
        return driver.getCurrentUrl();
    }

    // Higher-level action
    public void login(String username, String password) {
        enterUsername(username);
        enterPassword(password);
        clickSubmit();
    }

    public void navigateTo() {
        driver.get("https://the-internet.herokuapp.com/login");
    }
}
```

What this class teaches:
- Locators at the top (easy to update)
- Low-level actions (`enterUsername`, `enterPassword`)
- High-level actions (`login`) that combine steps
- Page class is independent of test logic

---

## Step 6: Create a Test Class Using Page Object

Create `src/test/java/com/krce/LoginPOMTest.java`:

```java
package com.krce;

import com.krce.pages.LoginPage;
import org.testng.Assert;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;

public class LoginPOMTest extends BaseTest {

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
                                    boolean shouldSucceed,
                                    String expectedMessagePart) {

        LoginPage loginPage = new LoginPage(driver);
        loginPage.navigateTo();
        loginPage.login(username, password);

        String actualMessage = loginPage.getFlashMessage();
        Assert.assertTrue(
                actualMessage.contains(expectedMessagePart),
                "Expected message not found"
        );

        if (shouldSucceed) {
            Assert.assertTrue(loginPage.getCurrentUrl().contains("/secure"),
                    "Expected to be on secure page");
        } else {
            Assert.assertTrue(loginPage.getCurrentUrl().contains("/login"),
                    "Expected to stay on login page");
        }
    }
}
```

What this test shows:
- No locators in test class
- Business logic is clear and readable
- Easy to understand test intent
- Reuses BaseTest for setup/teardown

---

## Step 7: POM Benefits in Action

Compare before and after:

**Before POM (mix of everything):**
```java
driver.findElement(By.id("username")).sendKeys("tom");
driver.findElement(By.id("password")).sendKeys("pass");
driver.findElement(By.cssSelector("button")).click();
String msg = driver.findElement(By.id("flash")).getText();
```

**With POM (clean separation):**
```java
LoginPage page = new LoginPage(driver);
page.login("tom", "pass");
String msg = page.getFlashMessage();
```

When application locators change:
- **Before**: Update 20+ test methods
- **With POM**: Update one LoginPage class

---

## Step 8: Project Structure Best Practice

Your folder structure should look like:

```
src/test/java/com/krce/
├── BaseTest.java
├── LoginPOMTest.java
├── pages/
│   ├── LoginPage.java
│   ├── DashboardPage.java
│   └── SearchPage.java
└── ...more test classes...
```

Keep pages in a separate `pages` package for organization.

---

## Step 9: Run the Tests

Run all tests:

```bash
mvn test
```

Run only this class:

```bash
mvn -Dtest=LoginPOMTest test
```

---

## Troubleshooting

### Issue: `NoSuchElementException` in page class

Cause:
- Locator is wrong or stale.

Solution:
- Print the locator and verify in browser inspect
- Update the `By` in page class

### Issue: Test fails immediately after page action

Cause:
- Page not fully loaded yet

Solution:
- Add explicit wait in page class method:
  ```java
  WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
  wait.until(ExpectedConditions.visibilityOfElementLocated(flashMessage));
  ```

### Issue: `NullPointerException` on driver

Cause:
- Test class did not extend BaseTest, so driver is null

Solution:
- Make sure your test class extends `BaseTest`
- Verify `@BeforeMethod` is inherited

---

## Best Practices for POM

1. **One page class per page**: `LoginPage`, `DashboardPage`, not both mixed
2. **Locators at the top**: Easy to find and update
3. **Low-level + high-level methods**: `click()` and `fillForm()`
4. **No assertions in page class**: Only in test class
5. **Constructor takes WebDriver**: Inject driver for flexibility

---

## Summary

In this codelab, you learned the Page Object Model design:

- Created a `BaseTest` for shared browser management
- Built a reusable `LoginPage` class with locators and actions
- Refactored tests to use page objects
- Removed locator duplication
- Made tests more maintainable and readable

You now have a professional automation framework foundation.

---

## Next Steps

In the next codelab, you can learn:

1. TestNG suites and group execution
2. Cross-browser and environment configuration
3. Parallel execution with ThreadLocal WebDriver
4. Reporting and screenshots on failure


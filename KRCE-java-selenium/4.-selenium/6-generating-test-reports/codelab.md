author: Pratham Sarankar
summary: Learn how to generate professional HTML test reports for Selenium tests using TestNG built-in reports, Maven Surefire, and ExtentReports
id: selenium-generating-test-reports
categories: Java,Selenium,TestNG,Test Reports,ExtentReports,Web Automation
environments: Web
status: Draft
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Generating Test Reports for Selenium Tests

## Overview

In this codelab, you will learn how to generate professional **HTML test reports** for your Selenium automation tests.

Running tests is only half the work — sharing results with your team in a readable format is equally important. Reports help you:
- See which tests passed, failed, or were skipped
- Understand why a test failed (with logs and screenshots)
- Share results with non-technical stakeholders

By the end of this lesson, you will:
- Generate default TestNG reports
- Generate Maven Surefire HTML reports
- Integrate **ExtentReports** for rich, professional HTML reports
- Attach screenshots to reports on test failure

---

## Prerequisites

Before starting, make sure you have:
- Maven installed and working
- JDK installed (Java Development Kit)
- Google Chrome browser installed
- Completed `4.-selenium/5-page-object-model-and-basetest/codelab.md`

---

## Step 1: Create (or Reuse) a Maven Project

You can reuse your existing Selenium + TestNG + POM project, or create a new one:

```bash
mvn archetype:generate -DgroupId=com.krce -DartifactId=selenium-reports -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false
```

Move into the project folder:

```bash
cd selenium-reports
```

---

## Step 2: Understand the Types of Reports

There are three common ways to generate reports for Selenium + TestNG projects:

| Report Type | How | Output |
|---|---|---|
| TestNG Default Report | Built into TestNG, zero config | `test-output/index.html` |
| Maven Surefire Report | Maven plugin, run one command | `target/site/surefire-report.html` |
| ExtentReports | Add library + listener code | Custom HTML file you control |

You will learn all three in this codelab.

---

## Step 3: Set Up Dependencies

Open `pom.xml` and add the following:

```xml
<dependencies>

    <!-- Selenium -->
    <dependency>
        <groupId>org.seleniumhq.selenium</groupId>
        <artifactId>selenium-java</artifactId>
        <version>4.15.0</version>
    </dependency>

    <!-- TestNG -->
    <dependency>
        <groupId>org.testng</groupId>
        <artifactId>testng</artifactId>
        <version>7.10.2</version>
        <scope>test</scope>
    </dependency>

    <!-- ExtentReports -->
    <dependency>
        <groupId>com.aventstack</groupId>
        <artifactId>extentreports</artifactId>
        <version>5.1.1</version>
    </dependency>

</dependencies>

<build>
    <plugins>

        <!-- Surefire plugin to run TestNG tests -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.2.5</version>
        </plugin>

        <!-- Surefire Report plugin to generate HTML report -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-report-plugin</artifactId>
            <version>3.2.5</version>
        </plugin>

    </plugins>
</build>
```

Run `mvn install` to download the dependencies:

```bash
mvn install -DskipTests
```

---

## Step 4: Create a BaseTest Class

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

---

## Step 5: Create a Sample Test Class

Create `src/test/java/com/krce/GoogleTest.java`:

```java
package com.krce;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.testng.Assert;
import org.testng.annotations.Test;

public class GoogleTest extends BaseTest {

    @Test
    public void verifyTitle() {
        driver.get("https://www.google.com");
        Assert.assertTrue(driver.getTitle().contains("Google"), "Title should contain Google");
    }

    @Test
    public void verifySearchBox() {
        driver.get("https://www.google.com");
        WebElement searchBox = driver.findElement(By.name("q"));
        Assert.assertTrue(searchBox.isDisplayed(), "Search box should be visible");
    }

    @Test
    public void intentionalFailure() {
        // This test will fail on purpose to demonstrate report output
        driver.get("https://www.google.com");
        Assert.assertEquals(driver.getTitle(), "Bing", "This test is expected to fail");
    }
}
```

The third test is intentionally wrong — it will fail so you can see how failures appear in reports.

---

## Step 6: Generate TestNG's Default Report

Run your tests with Maven:

```bash
mvn test
```

After the tests finish, TestNG automatically creates a report at:

```
test-output/index.html
```

Open `test-output/index.html` in a browser. You will see:
- A summary showing total tests, passed, failed, and skipped
- Links to individual test suite results
- Method-level details per test

This report is generated automatically — no extra code is needed.

---

## Step 7: Generate a Maven Surefire HTML Report

The Surefire Report plugin gives a cleaner browser-friendly report. Run:

```bash
mvn surefire-report:report
```

The report is generated at:

```
target/site/surefire-report.html
```

Open this file in a browser. You will see:
- Test totals with a summary table
- Per-class breakdown
- Failure messages and stack traces for failed tests

> **Note:** If `target/site/surefire-report.html` is missing, run `mvn test` first and then re-run `mvn surefire-report:report`.

---

## Step 8: Understand ExtentReports

The default TestNG and Surefire reports are useful but plain. **ExtentReports** gives you:

- A visually rich HTML dashboard
- Pass/Fail/Skip charts
- Logs you write manually per test step
- Screenshot attachments on failure
- Custom metadata (author, category)

ExtentReports works by hooking into TestNG's listener system.

---

## Step 9: Create an ExtentReports Listener

Create `src/test/java/com/krce/ExtentReportListener.java`:

```java
package com.krce;

import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.reporter.ExtentSparkReporter;
import com.aventstack.extentreports.reporter.configuration.Theme;
import org.testng.ITestContext;
import org.testng.ITestListener;
import org.testng.ITestResult;

public class ExtentReportListener implements ITestListener {

    private static ExtentReports extent;
    private static ThreadLocal<ExtentTest> extentTest = new ThreadLocal<>();

    @Override
    public void onStart(ITestContext context) {
        ExtentSparkReporter sparkReporter = new ExtentSparkReporter("target/extent-report.html");
        sparkReporter.config().setTheme(Theme.STANDARD);
        sparkReporter.config().setDocumentTitle("Selenium Test Report");
        sparkReporter.config().setReportName("KRCE Automation Results");

        extent = new ExtentReports();
        extent.attachReporter(sparkReporter);
        extent.setSystemInfo("OS", System.getProperty("os.name"));
        extent.setSystemInfo("Java Version", System.getProperty("java.version"));
        extent.setSystemInfo("Tester", "KRCE Student");
    }

    @Override
    public void onTestStart(ITestResult result) {
        ExtentTest test = extent.createTest(result.getMethod().getMethodName());
        extentTest.set(test);
    }

    @Override
    public void onTestSuccess(ITestResult result) {
        extentTest.get().pass("Test Passed");
    }

    @Override
    public void onTestFailure(ITestResult result) {
        extentTest.get().fail(result.getThrowable());
    }

    @Override
    public void onTestSkipped(ITestResult result) {
        extentTest.get().skip("Test Skipped: " + result.getThrowable());
    }

    @Override
    public void onFinish(ITestContext context) {
        extent.flush();
    }
}
```

What this class does:
- `onStart` — creates the report file and configures appearance
- `onTestStart` — creates a new entry per test method
- `onTestSuccess/Failure/Skipped` — logs result for that test
- `onFinish` — writes the report to disk (`extent.flush()`)

---

## Step 10: Register the Listener in testng.xml

Create `src/test/resources/testng.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">
<suite name="KRCE Selenium Suite">

    <listeners>
        <listener class-name="com.krce.ExtentReportListener"/>
    </listeners>

    <test name="Google Tests">
        <classes>
            <class name="com.krce.GoogleTest"/>
        </classes>
    </test>

</suite>
```

Update `pom.xml` to point Surefire to this file:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-surefire-plugin</artifactId>
    <version>3.2.5</version>
    <configuration>
        <suiteXmlFiles>
            <suiteXmlFile>src/test/resources/testng.xml</suiteXmlFile>
        </suiteXmlFiles>
    </configuration>
</plugin>
```

---

## Step 11: Run Tests and Open the ExtentReport

Run your tests:

```bash
mvn test
```

The report is created at:

```
target/extent-report.html
```

Open `target/extent-report.html` in a browser. You will see:
- A dashboard with pass/fail/skip counts and a pie chart
- A list of every test method with its status
- Error messages and stack traces for failed tests
- System information (OS, Java version) you set in the listener

---

## Step 12: Add Step Logs to the Report

You can write custom log messages to the report for each test step. Update `GoogleTest.java`:

```java
package com.krce;

import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.MediaEntityBuilder;
import org.openqa.selenium.By;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebElement;
import org.testng.Assert;
import org.testng.annotations.Test;

public class GoogleTest extends BaseTest {

    @Test
    public void verifyTitle() {
        ExtentTest test = ExtentReportListener.getExtentTest();
        test.info("Navigating to Google");
        driver.get("https://www.google.com");

        test.info("Checking page title");
        Assert.assertTrue(driver.getTitle().contains("Google"), "Title should contain Google");
        test.pass("Title verified successfully");
    }

    @Test
    public void verifySearchBox() {
        ExtentTest test = ExtentReportListener.getExtentTest();
        test.info("Navigating to Google");
        driver.get("https://www.google.com");

        test.info("Locating the search box");
        WebElement searchBox = driver.findElement(By.name("q"));
        Assert.assertTrue(searchBox.isDisplayed(), "Search box should be visible");
        test.pass("Search box is visible");
    }

    @Test
    public void intentionalFailure() {
        ExtentTest test = ExtentReportListener.getExtentTest();
        test.info("Navigating to Google");
        driver.get("https://www.google.com");

        test.info("Checking title — expecting Bing (will fail)");
        Assert.assertEquals(driver.getTitle(), "Bing", "This test is expected to fail");
    }
}
```

To make `ExtentReportListener.getExtentTest()` work, add this static getter to `ExtentReportListener.java`:

```java
public static ExtentTest getExtentTest() {
    return extentTest.get();
}
```

Re-run `mvn test` and check `target/extent-report.html`. You will now see step-by-step logs inside each test entry.

---

## Step 13: Attach a Screenshot on Failure

Screenshots are the most valuable debugging tool in test reports. Update `ExtentReportListener.java` to capture and attach a screenshot on failure.

First, add a helper method to take a screenshot:

```java
private String captureScreenshot(ITestResult result) {
    try {
        WebDriver driver = ((BaseTest) result.getInstance()).driver;
        TakesScreenshot ts = (TakesScreenshot) driver;
        File src = ts.getScreenshotAs(OutputType.FILE);
        String screenshotPath = "target/screenshots/" + result.getMethod().getMethodName() + ".png";
        File dest = new File(screenshotPath);
        dest.getParentFile().mkdirs();
        FileUtils.copyFile(src, dest);
        return screenshotPath;
    } catch (Exception e) {
        return null;
    }
}
```

Add the required imports at the top of the file:

```java
import org.apache.commons.io.FileUtils;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import java.io.File;
```

Add the `commons-io` dependency in `pom.xml`:

```xml
<dependency>
    <groupId>commons-io</groupId>
    <artifactId>commons-io</artifactId>
    <version>2.15.1</version>
</dependency>
```

Update `onTestFailure` to attach the screenshot:

```java
@Override
public void onTestFailure(ITestResult result) {
    extentTest.get().fail(result.getThrowable());
    String screenshotPath = captureScreenshot(result);
    if (screenshotPath != null) {
        extentTest.get().addScreenCaptureFromPath(screenshotPath, "Failure Screenshot");
    }
}
```

Run tests again:

```bash
mvn test
```

Open `target/extent-report.html`. Failed tests now have a screenshot thumbnail you can click to enlarge.

---

## Step 14: Final Project Structure

Your project should look like this:

```
selenium-reports/
├── pom.xml
└── src/
    └── test/
        ├── java/
        │   └── com/krce/
        │       ├── BaseTest.java
        │       ├── ExtentReportListener.java
        │       └── GoogleTest.java
        └── resources/
            └── testng.xml
```

After `mvn test`, reports are generated at:

```
target/
├── extent-report.html          ← ExtentReports HTML dashboard
├── site/
│   └── surefire-report.html    ← Maven Surefire HTML report
├── screenshots/
│   └── intentionalFailure.png  ← Screenshot of failed test
└── surefire-reports/           ← TestNG XML results (raw)

test-output/
└── index.html                  ← TestNG default HTML report
```

---

## Summary

You have learned three ways to generate Selenium test reports:

| Method | Command | Output Location | Best For |
|---|---|---|---|
| TestNG Default | `mvn test` | `test-output/index.html` | Quick check, zero config |
| Maven Surefire | `mvn surefire-report:report` | `target/site/surefire-report.html` | CI/CD pipelines |
| ExtentReports | `mvn test` (with listener) | `target/extent-report.html` | Sharing with stakeholders |

Key takeaways:
- TestNG generates reports automatically — no extra setup needed
- Maven Surefire Report needs one plugin and one command
- ExtentReports requires a listener class but gives the richest output
- Always capture screenshots on failure — they are the fastest way to debug
- Use `ThreadLocal<ExtentTest>` to make the listener thread-safe for parallel tests

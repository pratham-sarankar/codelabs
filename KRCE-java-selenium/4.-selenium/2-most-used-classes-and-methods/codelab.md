author: Pratham Sarankar
summary: Learn the most-used Selenium classes and methods in Java by building one practical end-to-end script
id: selenium-most-used-classes-and-methods
categories: Java,Selenium,Web Automation,Testing
environments: Web
status: Draft
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Selenium Most-Used Classes and Methods

## Overview

In this codelab, you will learn the Selenium classes and methods used in most real automation projects.

Instead of learning API names in isolation, you will use them in one practical script.

By the end of this lesson, you will:
- Understand what each core Selenium class does
- Use the most common methods from each class
- Interact with forms, dropdowns, alerts, frames, and windows
- Add explicit waits to make scripts reliable
- Take a screenshot for debugging and reporting

---

## Prerequisites

Before starting, make sure you have:
- Maven installed and working
- JDK installed (Java Development Kit)
- Google Chrome browser installed
- Completed `4.-selenium/1-introduction/codelab.md`

---

## Step 1: Create (or Reuse) a Maven Project

You can reuse your previous Selenium project, or create a new one:

```bash
mvn archetype:generate -DgroupId=com.krce -DartifactId=selenium-essentials-project -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4 -DinteractiveMode=false
```

If you created a new project, move into it:

```bash
cd selenium-essentials-project
```

---

## Step 2: Add Dependencies and Exec Plugin

Open `pom.xml` and use the following setup.

```xml
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
                <mainClass>com.krce.SeleniumEssentialsDemo</mainClass>
            </configuration>
        </plugin>
    </plugins>
</build>
```

---

## Step 3: Core Classes You Must Know

These are the most-used classes in Selenium projects:

| Class | Purpose |
|------|------|
| `WebDriver` | Controls the browser |
| `ChromeDriver` | Chrome-specific driver implementation |
| `By` | Locator builder (`id`, `name`, `cssSelector`, etc.) |
| `WebElement` | Represents an element in the page |
| `WebDriverWait` | Explicit wait helper |
| `ExpectedConditions` | Common wait conditions |
| `Select` | Handles dropdowns (`<select>`) |
| `Actions` | Advanced mouse/keyboard interactions |
| `Alert` | Handles JS alerts/confirm/prompt popups |
| `TakesScreenshot` | Captures browser screenshot |

---

## Step 4: Most-Used Methods Cheat Sheet

### `WebDriver`
- `get(url)`
- `getTitle()`
- `getCurrentUrl()`
- `navigate().to(url)`
- `switchTo().frame(...)`
- `switchTo().window(...)`
- `quit()`

### `By`
- `By.id("...")`
- `By.name("...")`
- `By.className("...")`
- `By.tagName("...")`
- `By.cssSelector("...")`
- `By.xpath("...")`
- `By.linkText("...")`
- `By.partialLinkText("...")`

### `WebElement`
- `click()`
- `sendKeys()`
- `clear()`
- `getText()`
- `getAttribute("...")`
- `isDisplayed()`
- `isEnabled()`
- `isSelected()`

### `WebDriverWait + ExpectedConditions`
- `visibilityOfElementLocated(...)`
- `elementToBeClickable(...)`
- `titleContains("...")`
- `urlContains("...")`
- `alertIsPresent()`

### `Select`
- `selectByVisibleText("...")`
- `selectByValue("...")`
- `selectByIndex(...)`
- `getFirstSelectedOption()`

### `Actions`
- `moveToElement(element)`
- `doubleClick(element)`
- `contextClick(element)`
- `clickAndHold(element)`
- `release()`
- `perform()`

### `Alert`
- `getText()`
- `accept()`
- `dismiss()`
- `sendKeys("...")`

### `TakesScreenshot`
- `getScreenshotAs(OutputType.FILE)`

---

## Step 5: Create One Complete Practice Script

Create `src/main/java/com/krce/SeleniumEssentialsDemo.java`:

```java
package com.krce;

import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.time.Duration;
import java.util.Set;

public class SeleniumEssentialsDemo {
    public static void main(String[] args) {
        WebDriver driver = new ChromeDriver();
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

        try {
            String baseUrl = "https://the-internet.herokuapp.com";

            // 1) WebDriver + By + WebElement
            driver.get(baseUrl + "/login");
            driver.findElement(By.id("username")).sendKeys("tomsmith");
            driver.findElement(By.id("password")).sendKeys("SuperSecretPassword!");
            driver.findElement(By.cssSelector("button[type='submit']")).click();

            WebElement flash = wait.until(
                    ExpectedConditions.visibilityOfElementLocated(By.id("flash"))
            );
            System.out.println("Login message: " + flash.getText().trim());
            System.out.println("Current URL: " + driver.getCurrentUrl());

            // 2) Select dropdown
            driver.navigate().to(baseUrl + "/dropdown");
            Select dropdown = new Select(driver.findElement(By.id("dropdown")));
            dropdown.selectByVisibleText("Option 1");
            System.out.println("Selected option: " + dropdown.getFirstSelectedOption().getText());

            // 3) Actions class (mouse hover)
            driver.navigate().to(baseUrl + "/hovers");
            WebElement avatar = wait.until(
                    ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".figure"))
            );
            Actions actions = new Actions(driver);
            actions.moveToElement(avatar).perform();

            // 4) Alert handling
            driver.navigate().to(baseUrl + "/javascript_alerts");
            driver.findElement(By.xpath("//button[text()='Click for JS Confirm']")).click();
            Alert alert = wait.until(ExpectedConditions.alertIsPresent());
            System.out.println("Alert text: " + alert.getText());
            alert.accept();

            // 5) Frame handling
            driver.navigate().to(baseUrl + "/iframe");
            wait.until(ExpectedConditions.frameToBeAvailableAndSwitchToIt(By.id("mce_0_ifr")));
            WebElement editor = driver.findElement(By.id("tinymce"));
            editor.clear();
            editor.sendKeys("Learning core Selenium classes and methods.");
            driver.switchTo().defaultContent();

            // 6) Window handling
            driver.navigate().to(baseUrl + "/windows");
            String originalWindow = driver.getWindowHandle();
            driver.findElement(By.linkText("Click Here")).click();

            Set<String> allWindows = driver.getWindowHandles();
            for (String window : allWindows) {
                if (!window.equals(originalWindow)) {
                    driver.switchTo().window(window);
                    break;
                }
            }
            System.out.println("New window title: " + driver.getTitle());
            driver.close();
            driver.switchTo().window(originalWindow);

            // 7) Screenshot
            File screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
            Files.copy(
                    screenshot.toPath(),
                    new File("final-page.png").toPath(),
                    StandardCopyOption.REPLACE_EXISTING
            );
            System.out.println("Screenshot saved as final-page.png");

            System.out.println("Demo completed successfully.");
        } catch (IOException e) {
            throw new RuntimeException("Failed to save screenshot", e);
        } finally {
            driver.quit();
        }
    }
}
```

---

## Step 6: Compile and Run

Compile:

```bash
mvn compile
```

Run:

```bash
mvn exec:java
```

What this run demonstrates:
1. Login form automation
2. Dropdown selection
3. Mouse action using `Actions`
4. JS alert handling
5. Frame switch and typing
6. New window switch and close
7. Screenshot capture

---

## Step 7: Quick Reference Card

Use this as your revision checklist.

- Browser control: `WebDriver`, `get()`, `navigate()`, `quit()`
- Locating elements: `By.id`, `By.name`, `By.cssSelector`, `By.xpath`
- Element actions: `click`, `sendKeys`, `clear`, `getText`
- Reliability: `WebDriverWait` + `ExpectedConditions`
- Special interactions: `Select`, `Actions`, `Alert`
- Browser contexts: `switchTo().frame`, `switchTo().window`
- Debugging support: `TakesScreenshot`

If students remember and practice these APIs, they can build most beginner-to-intermediate Selenium projects.

---

## Troubleshooting

### Issue: `NoSuchElementException`

Cause:
- Wrong locator or element not yet available.

Solution:
- Recheck locator in browser inspect.
- Add explicit wait before interaction.

### Issue: `NoSuchWindowException` or frame errors

Cause:
- Switched too early or wrong handle/frame ID.

Solution:
- Wait for target condition and then switch.
- Keep original window handle before opening a new window.

### Issue: Screenshot not saved

Cause:
- File path permission or IO issue.

Solution:
- Run from project root and keep filename simple (example: `final-page.png`).

---

## Summary

In this codelab, you learned the mostly used Selenium classes and methods required in real projects:

- `WebDriver`, `By`, `WebElement`
- `WebDriverWait`, `ExpectedConditions`
- `Select`, `Actions`, `Alert`
- Frame and window switching
- Screenshot capture

You now have a practical Selenium API foundation for building full test automation projects.

---

## Next Steps

In the next codelab, you can convert this script into proper test cases using JUnit/TestNG assertions and pass/fail reporting.


author: Pratham Sarankar
summary: Set up REST Assured with Maven and TestNG, then write your first automated GET and POST API tests in Java
id: api-testing-rest-assured-setup-and-first-test
categories: Java,API Testing,REST Assured,TestNG,Maven
environments: Web
status: Draft
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# REST Assured Setup & First API Test

## Overview

In the last codelab, you tested APIs manually using a browser and Postman. Now you will automate exactly those same requests using **Java code**.

In this codelab, you will:
- Learn what REST Assured is
- Create a Maven project for API testing
- Add REST Assured and TestNG dependencies
- Understand the `given().when().then()` syntax
- Write your first GET test and assert the status code
- Write your first POST test and assert the response body
- Run all tests with Maven

**By the end, you will have a working automated API test suite.**

---

## Prerequisites

Before starting, make sure you have:
- ✅ **JDK** installed and working
- ✅ **Maven** installed and working
- ✅ **VS Code** with the Java Extension Pack
- ✅ Completed **codelab 1** — you understand HTTP methods, status codes, and JSON

---

## What is REST Assured?

**REST Assured** is the most popular Java library for testing REST APIs.

It lets you write API tests in a clean, readable style that mirrors how you think about an HTTP request:

```
given some request setup
when I call this endpoint
then I expect this response
```

This is called **BDD syntax** (Behaviour-Driven Development) and it makes tests easy to read even for non-programmers.

### REST Assured vs Postman

| | Postman | REST Assured |
|---|---|---|
| Who uses it | Manual testers | Automation engineers |
| Language | GUI / no code | Java |
| Runs in CI/CD | ❌ Needs extra setup | ✅ Yes, with Maven |
| Version controlled | Difficult | ✅ Yes, it's just code |

---

## Step 1: Create a New Maven Project

Create a dedicated Maven project for API testing.

### Using VS Code Command Palette:

1. Press `Cmd+Shift+P` (Mac) or `Ctrl+Shift+P` (Windows)
2. Type and select: **Maven: New Project**
3. Choose archetype: `maven-archetype-quickstart`
4. Choose version: `1.4`
5. Set Group Id: `com.krce`
6. Set Artifact Id: `api-testing-project`
7. Press Enter to confirm the version (`1.0-SNAPSHOT`)
8. Press Enter to confirm all details
9. Open the created folder in VS Code

### Your project structure will look like:

```
api-testing-project/
├── src/
│   ├── main/
│   │   └── java/
│   │       └── com/krce/
│   │           └── App.java
│   └── test/
│       └── java/
│           └── com/krce/
│               └── AppTest.java
└── pom.xml
```

> **Note:** All our test classes will go in `src/test/java/com/krce/`. The `src/main/` folder is for application code, not tests.

---

## Step 2: Add Dependencies to pom.xml

Open `pom.xml` and replace the entire `<dependencies>` section with:

```xml
<dependencies>

    <!-- REST Assured: for making API requests -->
    <dependency>
        <groupId>io.rest-assured</groupId>
        <artifactId>rest-assured</artifactId>
        <version>5.4.0</version>
        <scope>test</scope>
    </dependency>

    <!-- TestNG: for running and organizing tests -->
    <dependency>
        <groupId>org.testng</groupId>
        <artifactId>testng</artifactId>
        <version>7.10.2</version>
        <scope>test</scope>
    </dependency>

</dependencies>
```

Also add the Maven Surefire plugin so Maven can run TestNG tests. Add this inside `<build><plugins>`:

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

### Download the dependencies

Run this in the terminal to verify Maven can download everything:

```bash
mvn dependency:resolve
```

You should see `BUILD SUCCESS`. REST Assured and TestNG are now in your project.

---

## Step 3: Understand the given / when / then Syntax

Every REST Assured test follows this three-part structure:

```java
given()
    // Set up your request (headers, body, base URL, etc.)
.when()
    // Call the endpoint (GET, POST, PUT, DELETE)
.then()
    // Assert the response (status code, body values, etc.)
```

Here is the simplest possible test:

```java
given()
.when()
    .get("https://jsonplaceholder.typicode.com/posts/1")
.then()
    .statusCode(200);
```

Reading this out loud: *"Given nothing special, when I GET /posts/1, then I expect status code 200."*

### Key REST Assured methods

| Part | Method | What it does |
|---|---|---|
| `given()` | `.baseUri(url)` | Set the base URL |
| `given()` | `.header(key, value)` | Add a request header |
| `given()` | `.body(json)` | Set the request body |
| `given()` | `.contentType(type)` | Set Content-Type header |
| `when()` | `.get(path)` | Send a GET request |
| `when()` | `.post(path)` | Send a POST request |
| `when()` | `.put(path)` | Send a PUT request |
| `when()` | `.delete(path)` | Send a DELETE request |
| `then()` | `.statusCode(code)` | Assert the status code |
| `then()` | `.body(path, value)` | Assert a value in the JSON body |

---

## Step 4: Write Your First GET Test

Delete the contents of `AppTest.java` and replace with a new test class.

Create `src/test/java/com/krce/GetPostTest.java`:

```java
package com.krce;

import io.restassured.RestAssured;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.*;

public class GetPostTest {

    @BeforeClass
    public void setup() {
        RestAssured.baseURI = "https://jsonplaceholder.typicode.com";
    }

    @Test
    public void getPostById_shouldReturn200() {
        given()
        .when()
            .get("/posts/1")
        .then()
            .statusCode(200);
    }

    @Test
    public void getPostById_shouldReturnCorrectId() {
        given()
        .when()
            .get("/posts/1")
        .then()
            .statusCode(200)
            .body("id", equalTo(1));
    }

    @Test
    public void getPostById_shouldHaveTitleAndBody() {
        given()
        .when()
            .get("/posts/1")
        .then()
            .statusCode(200)
            .body("title", notNullValue())
            .body("body", notNullValue());
    }

    @Test
    public void getAllPosts_shouldReturn100Posts() {
        given()
        .when()
            .get("/posts")
        .then()
            .statusCode(200)
            .body("size()", equalTo(100));
    }
}
```

### Breaking down the test

```java
RestAssured.baseURI = "https://jsonplaceholder.typicode.com";
```
Sets the base URL once for all tests in this class. Each `get("/posts/1")` call is appended to this base URL.

```java
.body("id", equalTo(1))
```
This uses **JSONPath** (`"id"`) to navigate the response JSON and **Hamcrest matchers** (`equalTo(1)`) to assert the value. You will see more of this in the next codelab.

```java
.body("size()", equalTo(100))
```
When the response is a JSON array, `size()` returns the number of elements.

---

## Step 5: Write Your First POST Test

Create `src/test/java/com/krce/CreatePostTest.java`:

```java
package com.krce;

import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.*;

public class CreatePostTest {

    @BeforeClass
    public void setup() {
        RestAssured.baseURI = "https://jsonplaceholder.typicode.com";
    }

    @Test
    public void createPost_shouldReturn201() {
        String requestBody = """
                {
                    "title": "My First API Test",
                    "body": "Learning REST Assured at KRCE",
                    "userId": 1
                }
                """;

        given()
            .contentType(ContentType.JSON)
            .body(requestBody)
        .when()
            .post("/posts")
        .then()
            .statusCode(201);
    }

    @Test
    public void createPost_shouldReturnCreatedTitle() {
        String requestBody = """
                {
                    "title": "My First API Test",
                    "body": "Learning REST Assured at KRCE",
                    "userId": 1
                }
                """;

        given()
            .contentType(ContentType.JSON)
            .body(requestBody)
        .when()
            .post("/posts")
        .then()
            .statusCode(201)
            .body("title", equalTo("My First API Test"))
            .body("userId", equalTo(1))
            .body("id", notNullValue());
    }
}
```

### What's new here?

```java
.contentType(ContentType.JSON)
```
Adds the `Content-Type: application/json` header, telling the server you are sending JSON.

```java
.body(requestBody)
```
Attaches the JSON string as the request body.

```java
.body("id", notNullValue())
```
Asserts that the server assigned an `id` to the newly created post, without caring about the exact value.

---

## Step 6: Run the Tests

Run all tests from the terminal:

```bash
mvn test
```

Maven will compile, then run all test classes via TestNG. You should see output like:

```
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running com.krce.CreatePostTest
Tests run: 2, Failures: 0, Errors: 0, Skipped: 0
Running com.krce.GetPostTest
Tests run: 4, Failures: 0, Errors: 0, Skipped: 0

Results:
Tests run: 6, Failures: 0, Errors: 0, Skipped: 0

[INFO] BUILD SUCCESS
```

**6 passing tests** — you have your first automated API test suite!

---

## Understanding Test Results

When a test **fails**, REST Assured gives you a detailed error:

```
java.lang.AssertionError: 1 expectation failed.
JSON path id doesn't match.
Expected: <2>
  Actual: <1>
```

This tells you:
- Which assertion failed (`id`)
- What was expected (`2`)
- What the API actually returned (`1`)

This is far more useful than a browser error page or Postman colour change.

---

## Your Project Structure Now

```
api-testing-project/
├── src/
│   └── test/
│       └── java/
│           └── com/krce/
│               ├── GetPostTest.java       ← GET tests
│               └── CreatePostTest.java    ← POST tests
└── pom.xml
```

---

## Summary

| Concept | What you learned |
|---|---|
| **REST Assured** | Java library for automating API tests |
| **`given/when/then`** | BDD syntax that maps to request setup / send / assert |
| **`baseURI`** | Set once, shared by all tests in the class |
| **`statusCode()`** | Assert the HTTP status code |
| **`body("path", matcher)`** | Assert a value in the JSON response using JSONPath |
| **`contentType()`** | Set Content-Type header for POST/PUT requests |
| **`mvn test`** | Run all tests from the terminal |

---

## What's Next?

You can assert a status code and a few values — but real API testing involves much deeper response validation.

In the next codelab you will learn **Request Building** in detail: how to pass headers, query parameters, path parameters, and complex JSON request bodies.

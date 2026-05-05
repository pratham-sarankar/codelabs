author: Pratham Sarankar
summary: Master REST Assured request building — set headers, query parameters, path parameters, and complex JSON request bodies
id: api-testing-request-building
categories: Java,API Testing,REST Assured,TestNG,Maven
environments: Web
status: Draft
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# REST Assured: Request Building

## Overview

In the last codelab, you wrote your first GET and POST tests. But every request used only a URL and a simple JSON body.

Real APIs require much more: **custom headers**, **query parameters**, **path parameters**, and **complex nested request bodies**.

In this codelab, you will learn:
- How to add request headers (single and multiple)
- How to send query parameters (`?key=value`)
- How to use path parameters (`/users/{id}`)
- How to send complex nested JSON as a request body
- How to use `RequestSpecification` to reuse request setup across tests

**By the end, you will be able to build any HTTP request a real-world API requires.**

---

## Prerequisites

Before starting, make sure you have:
- ✅ Completed **codelab 1** — you understand HTTP methods, status codes, and JSON
- ✅ Completed **codelab 2** — you have a working Maven + REST Assured + TestNG project
- ✅ Your `api-testing-project` open in VS Code

---

## What is Request Building?

When you call an API, the **request** has up to four parts:

| Part | Example | When it's used |
|---|---|---|
| **URL** | `https://api.example.com/users` | Always |
| **Headers** | `Authorization: Bearer abc123` | Auth, content type, API keys |
| **Query Params** | `?page=2&limit=10` | Filtering, pagination, search |
| **Path Params** | `/users/42` | Identifying a specific resource |
| **Body** | `{ "name": "Alice" }` | POST, PUT, PATCH requests |

REST Assured lets you set all of these inside the `given()` block.

---

## Step 1: Adding Request Headers

A **header** is a key-value pair sent with the request that provides extra information — things like content type, accepted response format, or authentication tokens.

### Single header

```java
given()
    .header("Accept", "application/json")
.when()
    .get("/posts/1")
.then()
    .statusCode(200);
```

### Multiple headers — chaining

```java
given()
    .header("Accept", "application/json")
    .header("X-Custom-Header", "KRCE-Test")
    .header("Authorization", "Bearer my-token-123")
.when()
    .get("/posts/1")
.then()
    .statusCode(200);
```

### Multiple headers — using a Map

```java
Map<String, String> headers = new HashMap<>();
headers.put("Accept", "application/json");
headers.put("X-Custom-Header", "KRCE-Test");

given()
    .headers(headers)
.when()
    .get("/posts/1")
.then()
    .statusCode(200);
```

> **Note:** `.header()` adds a **single** header. `.headers()` adds **many** headers from a Map.

---

## Step 2: Adding Query Parameters

A **query parameter** is added to the end of a URL after a `?` symbol.

For example:
```
https://jsonplaceholder.typicode.com/posts?userId=1
```

Here `userId=1` is a query parameter that filters posts by the user with id 1.

### Adding query params with REST Assured

Instead of manually building the URL string, use `.queryParam()`:

```java
given()
    .queryParam("userId", 1)
.when()
    .get("/posts")
.then()
    .statusCode(200);
```

REST Assured automatically builds the full URL: `/posts?userId=1`

### Multiple query parameters

```java
given()
    .queryParam("userId", 1)
    .queryParam("_limit", 5)
.when()
    .get("/posts")
.then()
    .statusCode(200)
    .body("size()", equalTo(5));
```

### Query params using a Map

```java
Map<String, Object> params = new HashMap<>();
params.put("userId", 1);
params.put("_limit", 3);

given()
    .queryParams(params)
.when()
    .get("/posts")
.then()
    .statusCode(200)
    .body("size()", equalTo(3));
```

---

## Step 3: Adding Path Parameters

A **path parameter** is a variable embedded inside the URL path itself.

For example:
```
/posts/1    →  1 is the path parameter (the post ID)
/users/42   →  42 is the path parameter (the user ID)
```

In REST Assured, you define the placeholder with `{name}` and supply the value with `.pathParam()`:

```java
given()
    .pathParam("postId", 5)
.when()
    .get("/posts/{postId}")
.then()
    .statusCode(200)
    .body("id", equalTo(5));
```

REST Assured replaces `{postId}` with `5` before sending the request, resulting in `/posts/5`.

### Multiple path parameters

```java
given()
    .pathParam("userId", 1)
    .pathParam("postId", 1)
.when()
    .get("/users/{userId}/posts/{postId}")
.then()
    .statusCode(200);
```

### Query params vs Path params — summary

| Type | URL Example | REST Assured method |
|---|---|---|
| **Path param** | `/posts/5` | `.pathParam("postId", 5)` |
| **Query param** | `/posts?userId=1` | `.queryParam("userId", 1)` |

---

## Step 4: Writing a Complex Request Body

So far, the POST body was a simple flat JSON string. Real APIs often need **nested** JSON objects.

For example, a user creation request might look like:

```json
{
  "name": "Alice",
  "username": "alice99",
  "email": "alice@example.com",
  "address": {
    "street": "Main Street",
    "city": "Chennai",
    "zipcode": "600001"
  },
  "company": {
    "name": "KRCE"
  }
}
```

### Option A: Multi-line String (simplest)

Use Java's text block (Java 15+):

```java
String requestBody = """
        {
            "name": "Alice",
            "username": "alice99",
            "email": "alice@example.com",
            "address": {
                "street": "Main Street",
                "city": "Chennai",
                "zipcode": "600001"
            },
            "company": {
                "name": "KRCE"
            }
        }
        """;

given()
    .contentType(ContentType.JSON)
    .body(requestBody)
.when()
    .post("/users")
.then()
    .statusCode(201);
```

### Option B: HashMap (programmatic, good for dynamic data)

```java
Map<String, Object> address = new HashMap<>();
address.put("street", "Main Street");
address.put("city", "Chennai");
address.put("zipcode", "600001");

Map<String, Object> company = new HashMap<>();
company.put("name", "KRCE");

Map<String, Object> requestBody = new HashMap<>();
requestBody.put("name", "Alice");
requestBody.put("username", "alice99");
requestBody.put("email", "alice@example.com");
requestBody.put("address", address);
requestBody.put("company", company);

given()
    .contentType(ContentType.JSON)
    .body(requestBody)
.when()
    .post("/users")
.then()
    .statusCode(201)
    .body("name", equalTo("Alice"));
```

REST Assured automatically serializes the Map to JSON before sending.

> **Which option to use?**
> - Use **text blocks** when the body is fixed across tests.
> - Use **Maps** when you need to build the body dynamically (e.g., in data-driven tests).

---

## Step 5: Reusing Setup with RequestSpecification

If every test in a class uses the same base URL, headers, and content type, copy-pasting them into every test is messy. Use `RequestSpecification` to define it once and reuse it everywhere.

```java
import io.restassured.specification.RequestSpecification;
import io.restassured.builder.RequestSpecBuilder;

public class UserApiTest {

    private RequestSpecification requestSpec;

    @BeforeClass
    public void setup() {
        requestSpec = new RequestSpecBuilder()
                .setBaseUri("https://jsonplaceholder.typicode.com")
                .setContentType(ContentType.JSON)
                .addHeader("Accept", "application/json")
                .build();
    }

    @Test
    public void getUser_shouldReturn200() {
        given()
            .spec(requestSpec)
            .pathParam("userId", 1)
        .when()
            .get("/users/{userId}")
        .then()
            .statusCode(200)
            .body("id", equalTo(1));
    }

    @Test
    public void getAllUsers_shouldReturn10() {
        given()
            .spec(requestSpec)
        .when()
            .get("/users")
        .then()
            .statusCode(200)
            .body("size()", equalTo(10));
    }
}
```

`.spec(requestSpec)` injects all the shared setup into the `given()` block. You can still add extra headers or params on top of the spec for individual tests.

---

## Step 6: Write the Full Test Class

Now put it all together. Create `src/test/java/com/krce/RequestBuildingTest.java`:

```java
package com.krce;

import io.restassured.RestAssured;
import io.restassured.builder.RequestSpecBuilder;
import io.restassured.http.ContentType;
import io.restassured.specification.RequestSpecification;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import java.util.HashMap;
import java.util.Map;

import static io.restassured.RestAssured.given;
import static org.hamcrest.Matchers.*;

public class RequestBuildingTest {

    private RequestSpecification requestSpec;

    @BeforeClass
    public void setup() {
        requestSpec = new RequestSpecBuilder()
                .setBaseUri("https://jsonplaceholder.typicode.com")
                .setContentType(ContentType.JSON)
                .addHeader("Accept", "application/json")
                .build();
    }

    // --- Headers ---

    @Test
    public void getPost_withCustomHeader_shouldReturn200() {
        given()
            .spec(requestSpec)
            .header("X-Test-Source", "KRCE-Codelab")
        .when()
            .get("/posts/1")
        .then()
            .statusCode(200);
    }

    // --- Query Parameters ---

    @Test
    public void getPosts_filteredByUserId_shouldReturnPostsForThatUser() {
        given()
            .spec(requestSpec)
            .queryParam("userId", 1)
        .when()
            .get("/posts")
        .then()
            .statusCode(200)
            .body("userId", everyItem(equalTo(1)));
    }

    @Test
    public void getPosts_withLimit_shouldReturnLimitedPosts() {
        given()
            .spec(requestSpec)
            .queryParam("_limit", 5)
        .when()
            .get("/posts")
        .then()
            .statusCode(200)
            .body("size()", equalTo(5));
    }

    // --- Path Parameters ---

    @Test
    public void getPost_withPathParam_shouldReturnCorrectPost() {
        int postId = 7;

        given()
            .spec(requestSpec)
            .pathParam("postId", postId)
        .when()
            .get("/posts/{postId}")
        .then()
            .statusCode(200)
            .body("id", equalTo(postId));
    }

    // --- Complex Request Body (text block) ---

    @Test
    public void createUser_withTextBlockBody_shouldReturn201() {
        String requestBody = """
                {
                    "name": "Alice",
                    "username": "alice99",
                    "email": "alice@example.com",
                    "address": {
                        "street": "Main Street",
                        "city": "Chennai",
                        "zipcode": "600001"
                    },
                    "company": {
                        "name": "KRCE"
                    }
                }
                """;

        given()
            .spec(requestSpec)
            .body(requestBody)
        .when()
            .post("/users")
        .then()
            .statusCode(201)
            .body("name", equalTo("Alice"))
            .body("username", equalTo("alice99"));
    }

    // --- Complex Request Body (HashMap) ---

    @Test
    public void createUser_withMapBody_shouldReturn201() {
        Map<String, Object> address = new HashMap<>();
        address.put("street", "Park Avenue");
        address.put("city", "Mumbai");
        address.put("zipcode", "400001");

        Map<String, Object> company = new HashMap<>();
        company.put("name", "KRCE");

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("name", "Bob");
        requestBody.put("username", "bob88");
        requestBody.put("email", "bob@example.com");
        requestBody.put("address", address);
        requestBody.put("company", company);

        given()
            .spec(requestSpec)
            .body(requestBody)
        .when()
            .post("/users")
        .then()
            .statusCode(201)
            .body("name", equalTo("Bob"))
            .body("address.city", equalTo("Mumbai"));
    }
}
```

---

## Step 7: Run the Tests

```bash
mvn test
```

Expected output:

```
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running com.krce.RequestBuildingTest
Tests run: 6, Failures: 0, Errors: 0, Skipped: 0

Results:
Tests run: 6, Failures: 0, Errors: 0, Skipped: 0

[INFO] BUILD SUCCESS
```

---

## Your Project Structure Now

```
api-testing-project/
├── src/
│   └── test/
│       └── java/
│           └── com/krce/
│               ├── GetPostTest.java            ← GET tests (codelab 2)
│               ├── CreatePostTest.java         ← POST tests (codelab 2)
│               └── RequestBuildingTest.java    ← This codelab
└── pom.xml
```

---

## Common Mistakes

| Mistake | What happens | Fix |
|---|---|---|
| Putting query params in the URL string manually | Works, but messy and error-prone | Use `.queryParam()` |
| Forgetting `{placeholder}` in the path when using `.pathParam()` | REST Assured ignores the param, wrong URL is called | Always match the name inside `{}` and in `.pathParam("name", value)` |
| Using `.header()` vs `.headers()` | `.header()` adds one. `.headers()` adds many from a Map | Pick the right one |
| Not calling `.contentType(ContentType.JSON)` on POST requests | Server may return `400 Bad Request` or `415 Unsupported Media Type` | Always set content type for requests with a body |
| Building a new `RequestSpecification` inside every test | Repeated code, harder to maintain | Build it once in `@BeforeClass` |

---

## Summary

| Concept | Method | Example |
|---|---|---|
| **Single header** | `.header(key, value)` | `.header("Accept", "application/json")` |
| **Multiple headers** | `.headers(map)` | `.headers(headersMap)` |
| **Query parameter** | `.queryParam(key, value)` | `.queryParam("userId", 1)` |
| **Path parameter** | `.pathParam(key, value)` | `.pathParam("postId", 5)` used with `/posts/{postId}` |
| **Request body (string)** | `.body(jsonString)` | `.body("{ \"name\": \"Alice\" }")` |
| **Request body (map)** | `.body(map)` | `.body(requestBodyMap)` |
| **Reusable setup** | `RequestSpecBuilder` + `.spec()` | Build once in `@BeforeClass`, reuse with `.spec(requestSpec)` |

---

## What's Next?

You can now build any request a real API needs.

In the next codelab you will learn **Deep Response Assertions** — how to use JSONPath and Hamcrest matchers to validate nested JSON fields, arrays, partial matches, and multiple conditions in a single test.

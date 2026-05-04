author: Pratham Sarankar
summary: Understand what APIs are, how REST works, HTTP methods, status codes, and JSON — the foundation of API testing
id: api-testing-introduction
categories: Java,API Testing,REST,HTTP,JSON
environments: Web
status: Draft
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Introduction to API Testing

## Overview

Before writing any code, you need to understand **what an API is** and **how it works**.

In this codelab, you will learn:
- What an API is and why it matters
- What REST means
- The four main HTTP methods (GET, POST, PUT, DELETE)
- How HTTP status codes communicate results
- What JSON looks like and how to read it
- How to manually test an API using a browser and Postman

**No code is written in this codelab — only concepts. Master these, and the rest of the series will make much more sense.**

---

## Prerequisites

Before starting, make sure you have:
- ✅ Completed the **Java Core** codelabs
- ✅ Completed the **Maven** codelabs
- ✅ Completed the **Selenium** codelabs (or at least understand what automated testing means)
- ✅ **Postman** installed — download free from [postman.com](https://www.postman.com/downloads/)

---

## What is an API?

**API** stands for **Application Programming Interface**.

Think of it like a waiter at a restaurant:

| Restaurant | Software |
|---|---|
| You (customer) | Your application / test |
| Waiter | API |
| Kitchen | Server / database |
| Menu | API documentation |

You don't walk into the kitchen yourself. You tell the waiter what you want (a **request**), and the waiter brings back food (a **response**).

An API works the same way:
- Your program sends a **request** to the server
- The server processes it and sends back a **response**
- You never talk to the database directly

---

## What is a REST API?

**REST** stands for **Representational State Transfer**. It is the most popular style of API used on the web today.

A REST API has a few simple rules:
1. Communication happens over **HTTP** (the same protocol used by web browsers)
2. Each request is **independent** — the server does not remember previous requests
3. Data is usually exchanged as **JSON**
4. Resources (data) are identified by **URLs**

### Example

Imagine a simple student management system. The REST API URL might look like:

```
https://api.example.com/students
https://api.example.com/students/42
https://api.example.com/students/42/grades
```

- `/students` → refers to the collection of all students
- `/students/42` → refers to the specific student with ID 42
- `/students/42/grades` → refers to the grades of student 42

These URLs are called **endpoints**.

---

## HTTP Methods

A URL tells the server *what* resource you are talking about. An **HTTP method** tells the server *what you want to do* with it.

There are four main methods you will use in API testing:

| Method | Meaning | Example |
|---|---|---|
| **GET** | Read / fetch data | Get a list of all students |
| **POST** | Create new data | Add a new student |
| **PUT** | Update existing data | Update a student's name |
| **DELETE** | Delete data | Remove a student |

### Real-world analogy

Think of a library database:

| HTTP Method | Library action |
|---|---|
| GET | Search for a book |
| POST | Add a new book to the catalog |
| PUT | Edit a book's details |
| DELETE | Remove a book from the catalog |

---

## HTTP Status Codes

Every API response includes a **status code** — a 3-digit number that tells you whether the request succeeded or failed.

Status codes are grouped into ranges:

| Range | Category | Meaning |
|---|---|---|
| 2xx | ✅ Success | The request worked |
| 4xx | ❌ Client Error | You made a mistake in the request |
| 5xx | 💥 Server Error | The server crashed or has a bug |
| 3xx | ↩️ Redirection | The resource has moved |

### The codes you will see most often

| Code | Name | When you see it |
|---|---|---|
| **200** | OK | Successful GET or PUT |
| **201** | Created | Successful POST (new resource created) |
| **204** | No Content | Successful DELETE (nothing to return) |
| **400** | Bad Request | You sent invalid data |
| **401** | Unauthorized | You are not logged in |
| **403** | Forbidden | You are logged in but not allowed |
| **404** | Not Found | The resource does not exist |
| **500** | Internal Server Error | The server crashed |

> **Tip:** In API testing, checking the status code is always your **first assertion**.

---

## What is JSON?

**JSON** stands for **JavaScript Object Notation**. It is the standard format for sending and receiving data in REST APIs.

JSON is just structured text. Here is an example of a student object in JSON:

```json
{
  "id": 42,
  "name": "Riya Sharma",
  "age": 20,
  "isEnrolled": true,
  "courses": ["Java", "Selenium", "API Testing"]
}
```

### JSON building blocks

| Concept | Example | Description |
|---|---|---|
| **Object** | `{ "key": "value" }` | A collection of key-value pairs |
| **Array** | `[ "a", "b", "c" ]` | An ordered list of values |
| **String** | `"Riya Sharma"` | Text, always in double quotes |
| **Number** | `42`, `3.14` | A numeric value |
| **Boolean** | `true`, `false` | A yes/no value |
| **Null** | `null` | No value / empty |

### Nested JSON

JSON objects can contain other objects:

```json
{
  "id": 42,
  "name": "Riya Sharma",
  "address": {
    "city": "Mumbai",
    "state": "Maharashtra"
  }
}
```

To access the city, you would use the path: `address.city` → `"Mumbai"`

This notation is called **JSONPath** and you will use it to extract values in your tests.

---

## Anatomy of an HTTP Request

Every API call you make consists of four parts:

```
[METHOD] [URL]
[Headers]

[Body]
```

### Example: Creating a new student

```
POST https://api.example.com/students
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...

{
  "name": "Riya Sharma",
  "age": 20
}
```

| Part | What it is |
|---|---|
| `POST` | HTTP method — we are creating |
| URL | The endpoint |
| `Content-Type` | Header telling the server we are sending JSON |
| `Authorization` | Header carrying login credentials |
| Body | The JSON data we are sending |

---

## Anatomy of an HTTP Response

The server replies with:

```
[Status Code] [Status Message]
[Headers]

[Body]
```

### Example response

```
HTTP/1.1 201 Created
Content-Type: application/json

{
  "id": 42,
  "name": "Riya Sharma",
  "age": 20
}
```

The body contains the newly created student, including the `id` assigned by the server.

---

## Try It: Your First API Call in a Browser

You can make a GET request directly from your browser!

1. Open any browser (Chrome, Firefox, etc.)
2. Go to this URL:

```
https://jsonplaceholder.typicode.com/users/1
```

3. You should see a JSON response like this:

```json
{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "city": "Gwenborough"
  },
  "phone": "1-770-736-0988 x56442",
  "website": "hildegard.org"
}
```

> **JSONPlaceholder** (`jsonplaceholder.typicode.com`) is a free, public fake REST API designed for practice and learning. We will use it throughout this series.

Now try changing the URL to `/users/2`, `/users/3`, etc. Each returns a different user.

---

## Try It: Explore Endpoints in Postman

Postman gives you a proper API testing interface. Let's make a few requests.

### Step 1: Open Postman and create a new request

Click **New → HTTP Request**.

### Step 2: Make a GET request

- Method: `GET`
- URL: `https://jsonplaceholder.typicode.com/posts`
- Click **Send**

You should see a list of 100 posts in the response body, and **Status: 200 OK** in the top right.

### Step 3: Get a single post

- URL: `https://jsonplaceholder.typicode.com/posts/1`
- Click **Send**

Notice how the response contains only one post now.

### Step 4: Make a POST request

- Method: `POST`
- URL: `https://jsonplaceholder.typicode.com/posts`
- Go to the **Body** tab → select **raw** → select **JSON** from the dropdown
- Enter:

```json
{
  "title": "My First API Test",
  "body": "Learning API testing at KRCE",
  "userId": 1
}
```

- Click **Send**

You should see **Status: 201 Created** and the response will echo your data back with a new `id`.

### Step 5: Make a DELETE request

- Method: `DELETE`
- URL: `https://jsonplaceholder.typicode.com/posts/1`
- Click **Send**

You should see **Status: 200 OK** and an empty body `{}`.

> **Note:** JSONPlaceholder is a fake API — it doesn't actually save or delete data. It just simulates realistic responses for learning purposes.

---

## Summary

| Concept | What you learned |
|---|---|
| **API** | A contract between a client and server for exchanging data |
| **REST** | An architectural style for APIs using HTTP |
| **Endpoint** | A URL that represents a resource |
| **HTTP Method** | What action to perform (GET / POST / PUT / DELETE) |
| **Status Code** | Whether the request succeeded (200, 201, 404, 500…) |
| **JSON** | The data format used in REST API requests and responses |
| **JSONPlaceholder** | The free fake API we will use for all practice in this series |

---

## What's Next?

In the next codelab, you will write your first **automated API test in Java** using the **REST Assured** library.

You will turn what you just did manually in Postman into a repeatable, automated Java test.

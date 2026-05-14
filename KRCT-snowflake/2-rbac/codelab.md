author: Pratham Sarankar
summary: A beginner-friendly introduction to Role-Based Access Control (RBAC) in Snowflake — understand what roles are, why they matter, and how to control who can see what data using a simple school example
id: krct-snowflake-rbac
categories: Snowflake,Security,RBAC,Access Control,Cloud Data
environments: Web
status: Draft
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Snowflake: Who Can See What? — Intro to RBAC

## Overview

Imagine you work at a school. The **principal** can access everything — student records, teacher salaries, exam results. A **teacher** can see their students' grades but not other teachers' salaries. A **student** can only see their own grades.

This idea — giving different people different levels of access — is called **Role-Based Access Control**, or **RBAC**.

In Snowflake, instead of giving permissions directly to each person, you create a **role** (like "Teacher" or "Student") and give the role the right permissions. Then you assign that role to people.

In this codelab, you will:
- Learn what roles and permissions are in Snowflake
- See the built-in roles Snowflake gives you
- Create your own roles for a simple school scenario
- Give roles the right permissions
- Assign roles to users
- Test that the access controls work

---

## Prerequisites

Before starting, make sure you have:
- A Snowflake account (free 30-day trial at [trial.snowflake.com](https://trial.snowflake.com))
- You can log in to Snowsight (the Snowflake web interface)
- You know how to open a Worksheet and run a SQL query
- No prior security knowledge needed!

---

## Step 1: What is a Role?

Think of a **role** as a **job title** that comes with a set of keys.

- A **librarian** has a key to the library — they can read and add books.
- A **student** has a library card — they can only read books, not add new ones.
- The **principal** has a master key — they can access everything.

In Snowflake:
- A **role** is like the job title.
- A **privilege** is like one of those keys (e.g., the ability to read a specific table).
- You give privileges to roles, then assign roles to users.

```
What can be done  →  given to a Role  →  Role given to a User
   (privilege)                              
```

**Example:**
- You create a role called `TEACHER`
- You give `TEACHER` the ability to read the `GRADES` table
- You assign `TEACHER` to the user `mrs_smith`
- Now `mrs_smith` can read the `GRADES` table

---

## Step 2: Snowflake's Built-in Roles

When you create a Snowflake account, five roles are already there. You do not need to create them.

| Role | Think of it as... | What it can do |
|---|---|---|
| `ACCOUNTADMIN` | The owner of the whole school | Controls everything — billing, users, all data |
| `SECURITYADMIN` | The HR manager | Creates users and roles |
| `USERADMIN` | The receptionist | Creates users only |
| `SYSADMIN` | The IT admin | Creates databases, tables, warehouses |
| `PUBLIC` | A visitor badge | Automatically given to everyone — very limited access |

> **Important:** `ACCOUNTADMIN` is like a master key. Do not use it for everyday work. Use it only when you really need to (like setting up the account for the first time).

### See all roles

Open a **Worksheet** and run:

```sql
SHOW ROLES;
```

You will see the five built-in roles listed.

---

## Step 3: Set Up the School Database

Let's build a simple school scenario. We will create:
- A database called `SCHOOL_DB`
- Two tables: one for **grades** and one for **announcements**

Grades are private — only teachers should see them.
Announcements are public — everyone can read them.

Run this SQL in a Worksheet:

```sql
-- Step 1: Use the IT admin role to create our database and tables
USE ROLE SYSADMIN;

-- Create the school database
CREATE DATABASE IF NOT EXISTS SCHOOL_DB;

-- Create a schema (think of a schema as a folder inside the database)
CREATE SCHEMA IF NOT EXISTS SCHOOL_DB.ACADEMICS;

-- Create a warehouse (the engine that runs our queries)
CREATE WAREHOUSE IF NOT EXISTS SCHOOL_WH
  WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE;
```

Now create the two tables:

```sql
-- Grades table — should only be visible to teachers
CREATE TABLE IF NOT EXISTS SCHOOL_DB.ACADEMICS.GRADES (
    STUDENT_NAME  VARCHAR(100),
    SUBJECT       VARCHAR(50),
    GRADE         VARCHAR(5),
    TEACHER_NAME  VARCHAR(100)
);

-- Announcements table — visible to everyone
CREATE TABLE IF NOT EXISTS SCHOOL_DB.ACADEMICS.ANNOUNCEMENTS (
    TITLE         VARCHAR(200),
    MESSAGE       VARCHAR(1000),
    POSTED_DATE   DATE
);
```

Add some sample data:

```sql
INSERT INTO SCHOOL_DB.ACADEMICS.GRADES VALUES
    ('Alice', 'Math',    'A',  'Mr. Johnson'),
    ('Alice', 'Science', 'B+', 'Ms. Patel'),
    ('Bob',   'Math',    'B',  'Mr. Johnson'),
    ('Bob',   'Science', 'A-', 'Ms. Patel'),
    ('Carol', 'Math',    'A+', 'Mr. Johnson');

INSERT INTO SCHOOL_DB.ACADEMICS.ANNOUNCEMENTS VALUES
    ('School Picnic',    'Annual picnic is on Friday at 10am.',    '2024-09-01'),
    ('Holiday Notice',  'School is closed on Monday.',             '2024-09-05'),
    ('Exam Schedule',   'Mid-term exams start next week.',         '2024-09-10');
```

---

## Step 4: Create Custom Roles

Now let's create two roles for our school:

| Role | Who gets it | What they can do |
|---|---|---|
| `TEACHER` | Teachers | Read grades AND announcements |
| `STUDENT` | Students | Read announcements ONLY (not grades) |

Run this SQL:

```sql
-- Switch to the HR manager role to create roles
USE ROLE SECURITYADMIN;

CREATE ROLE IF NOT EXISTS TEACHER
  COMMENT = 'Can read grades and announcements';

CREATE ROLE IF NOT EXISTS STUDENT
  COMMENT = 'Can only read announcements';
```

Verify the roles were created:

```sql
SHOW ROLES LIKE 'TEACHER';
SHOW ROLES LIKE 'STUDENT';
```

---

## Step 5: Give Permissions to Each Role

Right now our roles exist but have no permissions — they are like job titles without any keys.

To let a role read a table, you need to give it three things in order:
1. **Access to the database** (so it can see the database exists)
2. **Access to the schema** (so it can see the folder inside the database)
3. **Access to the table** (so it can actually read the data)

Think of it like entering a school building:
- Step 1: You need a pass to enter the school gates (database)
- Step 2: You need a pass to enter the correct corridor (schema)
- Step 3: You need a key to open the specific classroom (table)

### Give permissions to TEACHER

```sql
USE ROLE SYSADMIN;

-- 1. Let TEACHER enter the database
GRANT USAGE ON DATABASE SCHOOL_DB TO ROLE TEACHER;

-- 2. Let TEACHER enter the schema (folder)
GRANT USAGE ON SCHEMA SCHOOL_DB.ACADEMICS TO ROLE TEACHER;

-- 3. Let TEACHER read the GRADES table
GRANT SELECT ON TABLE SCHOOL_DB.ACADEMICS.GRADES TO ROLE TEACHER;

-- 4. Let TEACHER read the ANNOUNCEMENTS table
GRANT SELECT ON TABLE SCHOOL_DB.ACADEMICS.ANNOUNCEMENTS TO ROLE TEACHER;

-- 5. Let TEACHER use the warehouse to run queries
GRANT USAGE ON WAREHOUSE SCHOOL_WH TO ROLE TEACHER;
```

### Give permissions to STUDENT

```sql
-- 1. Let STUDENT enter the database
GRANT USAGE ON DATABASE SCHOOL_DB TO ROLE STUDENT;

-- 2. Let STUDENT enter the schema
GRANT USAGE ON SCHEMA SCHOOL_DB.ACADEMICS TO ROLE STUDENT;

-- 3. Let STUDENT read ONLY the ANNOUNCEMENTS table (NOT grades)
GRANT SELECT ON TABLE SCHOOL_DB.ACADEMICS.ANNOUNCEMENTS TO ROLE STUDENT;

-- 4. Let STUDENT use the warehouse
GRANT USAGE ON WAREHOUSE SCHOOL_WH TO ROLE STUDENT;
```

Notice that `STUDENT` was NOT given access to the `GRADES` table. This means students cannot read grades — even if they try.

---

## Step 6: Create Users and Give Them Roles

Now let's create two users — one teacher and one student.

```sql
USE ROLE USERADMIN;

-- Create a teacher user
CREATE USER IF NOT EXISTS mr_johnson
  PASSWORD             = 'Teacher@123'
  DEFAULT_ROLE         = TEACHER
  DEFAULT_WAREHOUSE    = SCHOOL_WH
  DEFAULT_NAMESPACE    = SCHOOL_DB.ACADEMICS
  MUST_CHANGE_PASSWORD = TRUE;

-- Create a student user
CREATE USER IF NOT EXISTS alice_student
  PASSWORD             = 'Student@123'
  DEFAULT_ROLE         = STUDENT
  DEFAULT_WAREHOUSE    = SCHOOL_WH
  DEFAULT_NAMESPACE    = SCHOOL_DB.ACADEMICS
  MUST_CHANGE_PASSWORD = TRUE;
```

Now assign the roles to the users:

```sql
USE ROLE SECURITYADMIN;

GRANT ROLE TEACHER TO USER mr_johnson;
GRANT ROLE STUDENT TO USER alice_student;
```

What each setting means:

| Setting | What it does |
|---|---|
| `DEFAULT_ROLE` | The role the user starts with when they log in |
| `DEFAULT_WAREHOUSE` | The warehouse automatically used to run queries |
| `DEFAULT_NAMESPACE` | The default database and schema |
| `MUST_CHANGE_PASSWORD` | Forces the user to create a new password on first login |

---

## Step 7: Test — Does the Access Work?

Let's test by switching roles in a Worksheet. In Snowflake you can pretend to be a different role using `USE ROLE`.

### Test 1: Teacher can read grades 

```sql
USE ROLE TEACHER;
USE WAREHOUSE SCHOOL_WH;

SELECT * FROM SCHOOL_DB.ACADEMICS.GRADES;
```

You should see all the grades. 

### Test 2: Teacher can read announcements 

```sql
SELECT * FROM SCHOOL_DB.ACADEMICS.ANNOUNCEMENTS;
```

You should see all three announcements. 

### Test 3: Student can read announcements 

```sql
USE ROLE STUDENT;

SELECT * FROM SCHOOL_DB.ACADEMICS.ANNOUNCEMENTS;
```

You should see all three announcements. 

### Test 4: Student CANNOT read grades ❌

```sql
USE ROLE STUDENT;

SELECT * FROM SCHOOL_DB.ACADEMICS.GRADES;
```

You should see an error like this:

```
SQL access control error: Insufficient privileges to operate on table 'GRADES'
```

This is exactly what we want. The student is blocked from seeing grades.

---

## Step 8: Check What Access Has Been Given

Snowflake lets you see exactly what permissions each role has. This is useful when you want to double-check access.

### What can the TEACHER role do?

```sql
SHOW GRANTS TO ROLE TEACHER;
```

This lists every permission the `TEACHER` role has.

### What can the STUDENT role do?

```sql
SHOW GRANTS TO ROLE STUDENT;
```

### Who has been given the TEACHER role?

```sql
SHOW GRANTS OF ROLE TEACHER;
```

You will see `mr_johnson` listed here.

### What roles does mr_johnson have?

```sql
SHOW GRANTS TO USER mr_johnson;
```

---

## Step 9: Remove Access (Revoke)

Sometimes you need to take away access. In Snowflake, this is called **revoking**.

### Remove a permission from a role

Let's say teachers should no longer be able to see grades (maybe grades moved to a different system).

```sql
USE ROLE SYSADMIN;

REVOKE SELECT ON TABLE SCHOOL_DB.ACADEMICS.GRADES FROM ROLE TEACHER;
```

Now if you run `SELECT * FROM SCHOOL_DB.ACADEMICS.GRADES` as `TEACHER`, you will get a permission error.

### Remove a role from a user

Let's say Alice graduated and should no longer be a student in the system.

```sql
USE ROLE SECURITYADMIN;

REVOKE ROLE STUDENT FROM USER alice_student;
```

Alice no longer has the `STUDENT` role and cannot access anything.

---

## Step 10: Key Rules to Remember

Here are the most important things to keep in mind when working with RBAC in Snowflake:

### Give the minimum access needed
Only give a role what it actually needs. A student does not need to see salaries or grades. Start small and add more only if needed.

### Do not use ACCOUNTADMIN every day
`ACCOUNTADMIN` is the most powerful role. Use it only for account setup tasks. For everything else, use `SYSADMIN`, `SECURITYADMIN`, or your own custom roles.

### Always set a DEFAULT_ROLE for users
If a user has no default role, they log in with the `PUBLIC` role which has almost no access. They will see confusing errors. Always set `DEFAULT_ROLE` when creating a user.

### Use MUST_CHANGE_PASSWORD for new users
When you create a user, set `MUST_CHANGE_PASSWORD = TRUE` so they set their own private password on first login.

---

## Step 11: Clean Up

Remove everything we created in this codelab:

```sql
-- Remove the database and warehouse
USE ROLE SYSADMIN;
DROP DATABASE  IF EXISTS SCHOOL_DB;
DROP WAREHOUSE IF EXISTS SCHOOL_WH;

-- Remove the custom roles
USE ROLE SECURITYADMIN;
DROP ROLE IF EXISTS TEACHER;
DROP ROLE IF EXISTS STUDENT;

-- Remove the users
USE ROLE USERADMIN;
DROP USER IF EXISTS mr_johnson;
DROP USER IF EXISTS alice_student;
```

---

## Summary

Great work! Here is everything you learned in this codelab:

| What you learned | Key idea |
|---|---|
| What a role is | A job title that comes with a set of permissions |
| Built-in Snowflake roles | `ACCOUNTADMIN`, `SECURITYADMIN`, `USERADMIN`, `SYSADMIN`, `PUBLIC` |
| Creating custom roles | `CREATE ROLE role_name;` |
| Giving permissions | `GRANT SELECT ON TABLE ... TO ROLE ...;` |
| The 3-step access rule | Always grant: database → schema → table |
| Creating users | `CREATE USER` with `DEFAULT_ROLE` and `MUST_CHANGE_PASSWORD` |
| Assigning roles to users | `GRANT ROLE ... TO USER ...;` |
| Testing access | Switch roles with `USE ROLE ...;` |
| Checking access | `SHOW GRANTS TO ROLE ...;` |
| Removing access | `REVOKE SELECT ON TABLE ... FROM ROLE ...;` |

### What's Next?

- **Multiple Roles** — a user can have more than one role and switch between them
- **Role Hierarchies** — you can give one role to another role so it inherits all its permissions
- **Column-level Security** — hide specific columns (like salary amounts) from certain roles
- **Row-level Security** — let students see only their own grades, not other students'

author: Pratham Sarankar
summary: Step-by-step guide to install and set up Apache Maven on Windows computers
id: maven-windows-setup
categories: Java,Maven,Build Tools,Windows
environments: Web
status: Published
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Installing and Setting Up Maven on Windows

## Overview

Welcome back! 🎉 Now that you know what Maven is and why it's helpful, let's learn how to install it on your Windows computer.

By the end of this codelab, you will have Maven working on your computer and be ready to create your first Maven project.

**This guide is designed for beginners** - we'll go through each step slowly with clear instructions and pictures where helpful.

---

## Prerequisites

Before installing Maven, you need:

### 1. Java Development Kit (JDK) Installed
Maven needs Java to work, so you must have JDK installed first.

**If you don't have JDK yet:**
- Download from: https://adoptium.net/temurin/releases/
- Choose **JDK 17** or **JDK 11** (LTS versions are recommended)
- Download the **Windows installer (.msi)**
- Run the installer and follow the steps

### 2. Basic Computer Skills
You should know how to:
- Download files from the internet
- Extract ZIP files
- Open Command Prompt or PowerShell

**Don't worry if you're not an expert!** We'll explain everything. 💪

---

## Step 1: Download Maven

First, let's download the Maven software from the official website.

### How to Download:

1. **Open your web browser** (Chrome, Edge, Firefox, etc.)

2. **Go to the Maven download page:**
   ```
   https://maven.apache.org/download.cgi
   ```

3. **Find the "Binary zip archive" section**

4. **Download the file that ends with "bin.zip"**
   - Look for: `apache-maven-X.X.X-bin.zip`
   - X.X.X is the version number (like 3.9.4)
   - **Choose the latest stable version**

5. **Save the file** to your Downloads folder

**Tip:** The file is about 10-20 MB, so it won't take long to download.

---

## Step 2: Extract Maven

Now we need to unzip the downloaded file.

### How to Extract:

1. **Find the downloaded ZIP file** in your Downloads folder
   - It should be named something like: `apache-maven-3.9.4-bin.zip`

2. **Right-click on the ZIP file**

3. **Choose "Extract All..."** or "Extract Here"

4. **Choose where to extract:**
   - **Recommended:** Extract to `C:\Program Files\`
   - Or create a folder like `C:\Tools\` and extract there

5. **After extraction, you should see a folder like:**
   ```
   C:\Program Files\apache-maven-3.9.4\
   ```

**Important:** Remember this folder location - we'll need it later!

---

## Step 3: Set Up Environment Variables

Windows needs to know where Maven is installed. We do this by setting environment variables.

### What are Environment Variables?
Environment variables are like notes that tell Windows where to find programs.

### Setting MAVEN_HOME:

1. **Press Windows key + R** to open Run dialog

2. **Type `sysdm.cpl`** and press Enter
   - This opens System Properties

3. **Click on "Advanced" tab**

4. **Click "Environment Variables" button**

5. **Under "System variables" section, click "New..."**

6. **Enter variable details:**
   - **Variable name:** `MAVEN_HOME`
   - **Variable value:** The path to your Maven folder
     - Example: `C:\Program Files\apache-maven-3.9.4`
   - **Make sure there are no spaces at the end!**

7. **Click "OK" to save**

### Updating PATH Variable:

The PATH variable tells Windows where to look for programs.

1. **Find the "Path" variable** in System variables

2. **Click "Edit..."**

3. **Click "New"**

4. **Add this path:**
   ```
   %MAVEN_HOME%\bin
   ```

5. **Click "OK" on all windows to save**

**Important:** You need to restart any open Command Prompt windows for changes to take effect.

---

## Step 4: Verify Installation

Let's make sure Maven is installed correctly.

### How to Test:

1. **Open Command Prompt:**
   - Press Windows key + R
   - Type `cmd`
   - Press Enter

2. **Type this command and press Enter:**
   ```
   mvn -version
   ```

3. **You should see output like:**
   ```
   Apache Maven 3.9.4 (9f2842ce6743c59...)
   Maven home: C:\Program Files\apache-maven-3.9.4
   Java version: 17.0.7, vendor: Eclipse Adoptium, runtime: C:\Program Files\Eclipse Adoptium\jdk-17.0.7+7
   Default locale: en_US, platform encoding: Cp1252
   OS name: "windows 10", version: "10.0", arch: "amd64", family: "windows"
   ```

**If you see this, congratulations! Maven is working!** 🎉

### Troubleshooting:

**If you get "mvn is not recognized":**
- Check that PATH is set correctly
- Try restarting Command Prompt
- Make sure MAVEN_HOME points to the correct folder

**If you get Java errors:**
- Make sure JDK is installed
- Check that JAVA_HOME is set (we'll cover this in the next section)

---

## Step 5: Set JAVA_HOME (Important!)

Maven needs to know where Java is installed.

### Setting JAVA_HOME:

1. **Find where JDK is installed:**
   - Usually: `C:\Program Files\Eclipse Adoptium\jdk-17.0.7+7`
   - Or: `C:\Program Files\Java\jdk-17.0.7`

2. **Open Environment Variables again:**
   - Windows key + R → `sysdm.cpl` → Advanced → Environment Variables

3. **Under "System variables", click "New..."**

4. **Enter:**
   - **Variable name:** `JAVA_HOME`
   - **Variable value:** Your JDK installation path
     - Example: `C:\Program Files\Eclipse Adoptium\jdk-17.0.7+7`

5. **Click "OK"**

6. **Restart Command Prompt and test again:**
   ```
   mvn -version
   ```

**JAVA_HOME is very important for Maven to work properly!**

---

## Step 6: Test with a Simple Project

Let's create a simple Maven project to make sure everything works.

### Create a Test Project:

1. **Open Command Prompt**

2. **Create a new folder for testing:**
   ```
   mkdir C:\MavenTest
   cd C:\MavenTest
   ```

3. **Create a simple Maven project:**
   ```
   mvn archetype:generate -DgroupId=com.example -DartifactId=my-test-app -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
   ```

4. **This will create a folder structure with:**
   - `src/main/java/` - Your Java code
   - `pom.xml` - Maven configuration

5. **Compile the project:**
   ```
   cd my-test-app
   mvn compile
   ```

6. **If it compiles successfully, Maven is working!** ✅

---

## Common Problems and Solutions

### Problem 1: "JAVA_HOME is not set"
**Solution:** Follow Step 5 above to set JAVA_HOME

### Problem 2: "mvn command not found"
**Solution:** 
- Check PATH variable includes `%MAVEN_HOME%\bin`
- Restart Command Prompt
- Make sure MAVEN_HOME is set correctly

### Problem 3: Permission Errors
**Solution:** Run Command Prompt as Administrator

### Problem 4: Old Maven Version
**Solution:** Download the latest version from the website

---

## What You Learned

In this codelab, you learned how to:

✅ **Download Maven** from the official website  
✅ **Extract Maven** to the correct location  
✅ **Set environment variables** (MAVEN_HOME and PATH)  
✅ **Set JAVA_HOME** for Java  
✅ **Verify installation** with `mvn -version`  
✅ **Create and compile** a test project  

**Maven is now ready on your Windows computer!** 🚀

---

## Next Steps

Now that Maven is installed, you can:

1. **Create your first Maven project** from scratch
2. **Add dependencies** like JUnit for testing
3. **Build and package** your Java applications
4. **Learn advanced Maven features**

**Ready to create your first project?** Let's go! 💪

---

## Quick Quiz

Test what you learned:

1. What do you download from maven.apache.org? (Binary zip archive)
2. What environment variable points to Maven folder? (MAVEN_HOME)
3. What command checks if Maven is working? (mvn -version)
4. Why do you need JAVA_HOME? (Tells Maven where Java is installed)

**Excellent work!** You've successfully set up Maven on Windows. 🎉
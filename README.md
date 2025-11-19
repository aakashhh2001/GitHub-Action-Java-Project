# 🚀 Java Maven CI/CD Pipeline with Docker, Docker Hub, and GHCR

A complete end-to-end CI/CD project that:

* Runs Maven unit tests
* Builds a Docker image (single-stage Dockerfile)
* Pushes the image to **Docker Hub**
* Pushes the image to **GitHub Container Registry (GHCR)**
* Uses **GitHub Actions** for full automation

This repo contains:

* Java source code (`App.java`)
* Unit test (`AppTest.java`)
* Maven build file (`pom.xml`)
* Dockerfile
* GitHub Actions CI/CD workflow (`ci-cd.yml`)

Perfect reference for DevOps engineers learning CI/CD + Docker + GitHub Actions.

---

# 📁 Project Structure

```
Project-2/
  ├── App.java
  ├── AppTest.java
  ├── pom.xml
  ├── Dockerfile
  └── .github/
        └── workflows/
              └── ci-cd.yml
```

---

# 🧪 Java Source Code & Tests

## **App.java**

This is a simple Java program with an `add()` method and a `main()`.

```
package com.example;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello,World!");
    }

    public static int add(int a, int b) {
        return a + b;
    }
}
```

## **AppTest.java**

A JUnit test that validates the `add()` method.

```
package com.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class AppTest {
    @Test
    void testAdd() {
        assertEquals(5, App.add(2, 3));
    }
}
```

---

# ⚙️ pom.xml (Maven Build File)

This Maven file configures Java 17 + JUnit Jupiter.

```
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>demo-app</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.10.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.1.2</version>
            </plugin>
        </plugins>
    </build>
</project>
```

---

# 🐳 Dockerfile (Single-Stage Build)

Works perfectly with your flat Java project structure.

```
FROM maven:3.9.5-eclipse-temurin-17

WORKDIR /app

COPY pom.xml .

RUN mkdir -p src/main/java src/test/java

COPY App.java src/main/java/
COPY AppTest.java src/test/java/

RUN mvn -B package

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "target/demo-app-1.0-SNAPSHOT.jar"]
```

---

# 🚀 GitHub Actions CI/CD Workflow

Create this file:

```
.github/workflows/ci-cd.yml
```

Paste:

```
name: CI-CD Pipeline

on:
  push:
    branches: ["main"]
  pull_request:
    branches: ["main"]

env:
  IMAGE_NAME: demo-app

jobs:
  test:
    name: Run unit tests
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Java 17
        uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: 17

      - name: Run Maven Tests
        run: mvn -B test

  build:
    name: Build and Push Docker Image
    needs: test
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to DockerHub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Login to GHCR
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push images
        uses: docker/build-push-action@v4
        with:
          context: .
          file: ./Dockerfile
          push: true
          tags: |
            ${{ secrets.DOCKERHUB_USERNAME }}/${{ env.IMAGE_NAME }}:latest
            ghcr.io/${{ github.repository_owner }}/${{ env.IMAGE_NAME }}:latest
```

---

# 🔐 GitHub Secrets Setup

Go to:

```
GitHub Repo → Settings → Secrets → Actions
```

Add these:

| Secret Name          | Value                   |
| -------------------- | ----------------------- |
| `DOCKERHUB_USERNAME` | your DockerHub username |
| `DOCKERHUB_TOKEN`    | DockerHub Access Token  |

GHCR uses `GITHUB_TOKEN` automatically.

---

# 🔧 Required GitHub Settings for GHCR Push

Go to:

```
Repo → Settings → Actions → General
```

Scroll to **Workflow Permissions**:

✔ Read and Write Permissions
✔ Allow GitHub Actions to create and publish packages

Save.

This is crucial — GHCR push fails without it.

---

# 🏃 How to Run This Project Locally

### 1. Run Maven tests

```
mvn test
```

### 2. Build jar

```
mvn package
```

### 3. Build Docker image

```
docker build -t demo-app .
```

### 4. Run container

```
docker run --rm demo-app
```

Output:

```
Hello,World!
```

---

# 🌍 Pull Images After CI/CD Push

### Docker Hub:

```
docker pull <dockerhub-username>/demo-app:latest
```

### GHCR:

```
docker pull ghcr.io/<github-username>/demo-app:latest
```

---



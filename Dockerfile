FROM ubuntu:latest

# install java and maven (missing apt-get update; will fail)
RUN apt-get install -y openjdk-17-jdk maven

# copies everything (no .dockerignore yet)
ADD . /app

# wrong workdir (doesn't match /app)
WORKDIR /usr/src/app

# will run in the wrong folder, so Maven can't find pom.xml
RUN mvn -B -DskipTests package

# Using ARG for something needed at runtime; ENV set from unset ARG
ARG JAR_NAME=target/app.jar
ENV JAR_PATH $JAR_NAME

# not necessary to specify /tcp here, but harmless
EXPOSE 8080/tcp

# explicitly running as root (default anyway)
USER root

# shell form; signal handling isn't ideal; path likely wrong at runtime
CMD "java -jar $JAR_PATH"

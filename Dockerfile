# Start with a base image containing Java runtime
## BUILD
FROM openjdk:8-jdk-alpine as BUILDER

LABEL maintainer="kalnet17@gmail.com"

WORKDIR /workdir

# Dependencies
COPY .mvn /workdir/.mvn
COPY pom.xml /workdir/pom.xml
COPY mvnw /workdir/mvnw
RUN chmod +x mvnw && ./mvnw dependency:go-offline

# Project sources
COPY src /workdir/src
RUN ./mvnw package -DskipTests

## RUN
FROM openjdk:11-jre-slim
COPY --from=BUILDER /workdir/target/*.jar /petclinic.jar

VOLUME /tmp

EXPOSE 9090

CMD ["java", "-jar", "/petclinic.jar"]

#### OLD COMMANDS
## The application's jar file
#ARG JAR_FILE=target/*.jar
#
## Add the application's jar to the container
#ADD ${JAR_FILE} petclinic.jar
#
## Run the jar file
#ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/petclinic.jar"]

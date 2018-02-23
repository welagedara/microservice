FROM openjdk:8-jre-alpine

COPY ./microservice-0.0.1.jar /usr/src/microservice/

WORKDIR /usr/src/microservice

EXPOSE 8080

CMD ["java", "-jar", "microservice-0.0.1.jar"]

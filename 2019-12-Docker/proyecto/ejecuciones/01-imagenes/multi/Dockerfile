# builder es el alias
FROM maven:3.5-alpine as builder 

COPY app /app

RUN cd /app && mvn package

FROM openjdk:8-alpine

# --from=builder del docker, copiamos un archivo de un docker a otro
COPY --from=builder /app/target/my-app-1.0-SNAPSHOT.jar /opt/app.jar 

CMD java -jar /opt/app.jar

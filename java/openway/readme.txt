#compile
javac -classpath ./classes -d ./classes src/test.java
#run
java -classpath ./classes test

javac -classpath ./out -d ./out src/ex1Labyrinth.java
javac -classpath ./out -d ./out src/CalculateExpression.java
javac -classpath ./out -d ./out src/Main.java

java -classpath ./out Main
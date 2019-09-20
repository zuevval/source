package main.java.com.zuevval.console1;

import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
        /**@author Valerii Zuev 3630102/70401
         * @version 1.0
         * @usage enter text line by line. Prints every input line not starting with "q". To quit, enter "q".*/
        char exit = 'q';
        Scanner sc = new Scanner(System.in);
        String s;
        try{
            while(sc.hasNextLine()){
                s = sc.nextLine();
                if (s.toLowerCase().charAt(0) == exit) {
                    System.out.println("goodbye");
                    return;
                }
                System.out.println(s);
            }
        } catch (java.util.NoSuchElementException e){
            System.out.println("no such element exception");
        }
    }
}

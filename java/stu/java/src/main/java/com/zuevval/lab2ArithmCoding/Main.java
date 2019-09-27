package com.zuevval.lab2ArithmCoding;


import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.logging.*;

public class Main {
    final static private int nArguments;

    static {
        nArguments = 1;
    }

    /** entry point of arithmetic coding console application
     * @param args [0] - path to properties file with configuration
     */
    public static void main (String [] args){
        Logger logger = setupLogger();
        if (args.length < nArguments){
            logger.severe("too few arguments: " + args.length + " instead of " + nArguments);
            return;
        }
        String configFilename = args[0];
        Parser parser = parseConfig(configFilename, logger);
        if(parser == null) return;

        String inputFilename = parser.inputFilename();
        String input = readInput(inputFilename, logger);
        if(input == null) return;

        if (parser.encodeMode()){
            EncodedText encodedText = Converter.encode(input);
            System.out.println(encodedText.value);
        }
    }

    private static String readInput(String inputFilename, Logger logger){
        String res = null;
        try{
            BufferedReader reader = new BufferedReader(new FileReader(inputFilename));
            StringBuilder stringBuilder = new StringBuilder();
            String line = null;
            String ls = System.getProperty("line.separator");
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
                stringBuilder.append(ls);
            }
            reader.close();

            res = stringBuilder.toString();
            // delete the last new line separator
            res = res.substring(0, res.length() - ls.length());
        } catch (IOException e){
            logger.severe("error processing input file: ");
            logger.info(e.getMessage());
        }
        return res;
    }

    private static Parser parseConfig (String configFilename, Logger logger){
        Parser res = null;
        try {
            res = new Parser(configFilename);
        } catch (IOException e){
            logger.severe("error opening properties file");
        } catch (MissingParametersException e){
            logger.severe(e.getMessage());
        }
        return res;
    }

    private static Logger setupLogger() {
        Logger logger = Logger.getLogger("ArithmeticCoding");
        FileHandler fh;
        try{
            fh = new FileHandler("./error.log");
            logger.addHandler(fh);
            SimpleFormatter formatter = new SimpleFormatter();
            fh.setFormatter(formatter);
            // disable default console handler
            logger.setUseParentHandlers(false);
        } catch (SecurityException e){
            System.out.println("warning: unable to create log file - permission denied");
        } catch (IOException e){
            System.out.println("warning: unable to create log file for some reason");
        }
        return logger;
    }
}

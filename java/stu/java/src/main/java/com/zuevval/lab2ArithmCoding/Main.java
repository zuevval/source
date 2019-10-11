package com.zuevval.lab2ArithmCoding;


import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.*;

public class Main {
    final static private int nArguments;
    final static private String outputFilename;
    final static private String logFilename;
    final static private String loggerTitle;
    final static private String keyValueSeparator;
    final static private String lineSeparator;

    static {
        nArguments = 1;
        outputFilename = "out.txt";
        logFilename = "./error.log";
        loggerTitle = "arithmeticCoding";
        keyValueSeparator = ":";
        lineSeparator = System.getProperty("line.separator");
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
            writeOutput(encodedText, logger);
        }
    }

    private static void writeOutput (EncodedText encodedText, Logger logger){
        List<String> lines = new ArrayList<>();
        lines.add(encodedText.value+"");
        for (Character key : encodedText.dictionary.keySet()){
            lines.add(key + keyValueSeparator + encodedText.dictionary.get(key).toString());
        }
        Path outputFile = Paths.get(outputFilename);
        try{
            Files.write(outputFile, lines, StandardCharsets.UTF_8);
        } catch (IOException e){
            logger.severe("unable to write output: \n" + e.getMessage());
        }
    }

    private static String readInput(String inputFilename, Logger logger){
        String res = null;
        try{
            BufferedReader reader = new BufferedReader(new FileReader(inputFilename));
            StringBuilder stringBuilder = new StringBuilder();
            String line = null;
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
                stringBuilder.append(lineSeparator);
            }
            reader.close();

            res = stringBuilder.toString();
            // delete the last new line separator
            res = res.substring(0, res.length() - lineSeparator.length());
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
        Logger logger = Logger.getLogger(loggerTitle);
        FileHandler fh;
        try{
            fh = new FileHandler(logFilename);
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

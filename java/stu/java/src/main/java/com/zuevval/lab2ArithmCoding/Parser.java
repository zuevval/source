package com.zuevval.lab2ArithmCoding;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class Parser {

    private static final String ModeName;
    private static final String EncodeModeName;
    private static final String DecodeModeName;
    private static final String inputFilenameName;

    static {
        ModeName = "mode";
        EncodeModeName = "encode";
        DecodeModeName = "decode";
        inputFilenameName = "inputFilename";
    }

    private Properties properties;

    private static Properties readConfig (String configFilename) throws IOException {
        Properties res = new Properties();
        InputStream is = new FileInputStream(configFilename);
        res.load(is);
        is.close();
        return res;
    }

    public Parser (String configFilename) throws IOException, MissingParametersException {
        properties = readConfig(configFilename);
        if(properties.getProperty(ModeName) == null){
            throw new MissingParametersException(
                    "No such parameter in properties file: " + ModeName);
        }
        if (properties.getProperty(inputFilenameName) == null){
            throw new MissingParametersException(
                    "No such parameter in properties file: " + inputFilenameName);
        }
    }

    public Boolean encodeMode () {
        return properties.getProperty(ModeName).equals(EncodeModeName);
    }

    public String inputFilename () {
        return properties.getProperty(inputFilenameName);
    }
}

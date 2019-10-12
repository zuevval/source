package com.zuevval.lab2ArithmCoding;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class Parser {

    private enum field{
        inputFilename("inputFilename"),
        mode("mode");
        public enum modeValue {
            encode("encode"),
            decode("decode");
            private final String title;

            modeValue(String title) {
                this.title = title;
            }
        }

        private final String title;

        public String toString(){
            return title;
        }

        field(String title) {
            this.title = title;
        }
    }

    private MyProperties properties;

    private static MyProperties readConfig (String configFilename) throws IOException {
        MyProperties res = new MyProperties();
        InputStream is = new FileInputStream(configFilename);
        res.load(is);
        is.close();
        return res;
    }

    public Parser (String configFilename) throws IOException, MissingParametersException {
        properties = readConfig(configFilename);
        if(properties.get(field.mode.toString()) == null){
            throw new MissingParametersException(
                    "No such parameter in properties file: " + field.mode);
        }
        if (properties.get(field.inputFilename.toString()) == null){
            throw new MissingParametersException(
                    "No such parameter in properties file: " + field.inputFilename);
        }
    }

    public Boolean encodeMode () {
        return properties.get(field.mode.toString()).equals(
                field.modeValue.encode.toString());
    }

    public String inputFilename () {
        return properties.get(field.inputFilename.toString());
    }
}

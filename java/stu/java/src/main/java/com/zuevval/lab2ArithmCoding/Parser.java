package main.java.com.zuevval.lab2ArithmCoding;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class Parser {
    private static Properties readConfig (String configFilename) throws IOException {
        Properties res = new Properties();
        InputStream is = new FileInputStream(configFilename);
        res.load(is);
        is.close();
        //System.out.println(prop.getProperty("inputFileName"));
        return res;
    }
}

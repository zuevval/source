package main.java.com.zuevval.lab2ArithmCoding;

import java.io.IOException;
import java.io.InputStream;
import java.io.FileInputStream;
import java.util.Properties;


/** arithmetic coding for data compression
 * @author Valerii Zuev
 * */

public class converter {
    private static Properties readConfig (String configFilename) throws IOException {
        Properties res = new Properties();
        InputStream is = new FileInputStream(configFilename);
        res.load(is);
        is.close();
        //System.out.println(prop.getProperty("inputFileName"));
        return res;
    }
    public static double encode(String configFilename){
        double res = 0.0;
        return res;
    }
}

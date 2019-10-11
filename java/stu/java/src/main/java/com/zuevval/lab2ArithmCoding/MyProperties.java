package com.zuevval.lab2ArithmCoding;

import java.io.*;
import java.nio.charset.Charset;
import java.util.Hashtable;

public class MyProperties extends Hashtable <String, String> {

    final private static char keyValueSeparator = '=';
    final private static char lineSeparator = '\n';
    final private static char empty = ' ';
    final private static int eof = -1;
    final private static String charset;

    static {
        /*  By the way. Even Java developers sometimes don't mind hardcode :)
         *   "...if ((c == '=' ||  c == ':') && !precedingBackslash)..."
         *   (C) java/util/Properties.java, line 364 */
        charset = "UTF-8";
    }

    String getProperty(String key) {
        return super.get(key);
    }

    void load(InputStream inStream) throws IOException{
        BufferedReader reader = new BufferedReader(new InputStreamReader(inStream,
                Charset.forName(charset)));
        int currentChar;
        StringBuilder key = new StringBuilder();
        StringBuilder value = new StringBuilder();
        boolean readingKey = true;
        while ((currentChar = reader.read()) != eof){
            char character = (char) currentChar;
            switch (character) {
                case keyValueSeparator:
                    readingKey = false; // from next char until line separator: read value
                    break;

                case lineSeparator:
                    put(key.toString(), value.toString());
                    readingKey = true; // reading key again
                    key.setLength(0); // reset 'key' string
                    value.setLength(0); // reset 'value' string
                    break;

                case empty:
                    break; // skip whitespaces

                default:
                    if (readingKey) key.append(character);
                    else value.append(character);
            }
        }
    }
}

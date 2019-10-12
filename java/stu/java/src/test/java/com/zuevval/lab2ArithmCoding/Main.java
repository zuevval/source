package com.zuevval.lab2ArithmCoding;

import com.zuevval.lab2ArithmCoding.EncodedText;
import com.zuevval.lab2ArithmCoding.Converter;
import org.junit.Assert;
import org.junit.Test;

import java.util.Map;
import java.util.HashMap;


public class Main {
    // TODO refresh test to fit the new Converter interface
    @Test
    public void simpleEncode(){
        String input = "ab";
        Map<Character, Double> expectedDictionary = new HashMap<>();
        expectedDictionary.put('a', 0.5D);
        expectedDictionary.put('b', 0.5D);
        double expectedValue = 0.25D;
        /*
        EncodedText encoded = Converter.encode(input);

        Assert.assertEquals(encoded.value, expectedValue, 1e-10);
        Assert.assertEquals(encoded.dictionary, expectedDictionary);
         */
    }
}

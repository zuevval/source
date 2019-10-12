package com.zuevval.lab2ArithmCoding;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;


/** arithmetic coding for data compression
 *  @author Valerii Zuev
 */

public class Converter {

    private static final double maxProbability;
    private static final double minProbability;
    final private static int eof;
    final private static Charset charset;
    static {
        eof = -1;
        maxProbability = 1.0;
        minProbability = 0.0;
        charset = StandardCharsets.UTF_8;
    }

    private Map<Character, Double> probabilities;
    private EncodedText encoded;
    private String raw;

    /** Split interval [0;1) into non-intersecting pieces for arithmetic coding
     * corresponding to each character's probability
     * @return for each char - interval [a;b) in [0;1)
     */
    private Map<Character, Segment> segmentate (Map<Character, Double> probabilities){
        Map<Character, Segment> res = new HashMap<>();
        double bound = minProbability;
        for (Character key : probabilities.keySet()){
            Segment s = new Segment();
            s.left = bound;
            bound += (double)probabilities.get(key);
            s.right = bound;
            res.put(key, s);
        }
        return res;
    }

    private EncodedText encode(String input){
        Map<Character, Double> dictionary = probabilities;
        Map<Character, Segment> fractions = segmentate(dictionary);

        Segment res = new Segment(minProbability, maxProbability);
        for(int i=0; i < input.length(); i++){
            double interval = res.right - res.left;
            Segment fraction = fractions.get(input.charAt(i));
            res.right = res.left + fraction.right * interval;
            res.left += fraction.left * interval;
        }

        return new EncodedText(dictionary, res.left);
    }

    private void loadRaw (InputStream iStream, int istart, int istop) throws IOException, IllegalArgumentException{
        BufferedReader reader = new BufferedReader(new InputStreamReader(iStream, charset));
        int ichar = 0;
        int currentChar;
        StringBuilder rawText = new StringBuilder();
        Map<Character, Integer> instances = new HashMap<>();
        while ((currentChar = reader.read()) != eof){
            // update text statistics: count currentChar
            Integer count = instances.get((char)currentChar);
            if (count == null) count = 0;
            count++;
            instances.put((char)currentChar, count);

            // append to raw text
            if (ichar >= istart && ichar < istop)
                rawText.append((char)currentChar);
            ichar++;

            if(ichar == Integer.MAX_VALUE){
                throw new IllegalArgumentException("input stream too long");
            }
        }
        final int nInstances = ichar;
        probabilities = new HashMap<>();
        for(Character key : instances.keySet()){
            probabilities.put(key, (double)instances.get(key) / nInstances);
        }

        raw = rawText.toString();
    }

    private Converter (InputStream inStream, int istart, int istop) throws IOException {
        loadRaw(inStream, istart, istop);
        encoded = encode(raw);
    }

    /** 1. Calculate probabilities of each character in input stream
     *  as [number of occurences]/[overall characters quantity]
     *  2. encode a specified subset of characters in input stream
     *  @param inStream input text (to calculate probabilities)
     *  @param istart from char No. 'istart' starts sequence that must be encoded
     *  @param istop from char No. 'istop' we don't include literals into initial sequence
     */
    public static Converter initFromRaw (InputStream inStream, int istart, int istop, Logger logger){
        Converter res = null;
        try {
            res = new Converter(inStream, istart, istop);
        } catch (IllegalArgumentException e){
            logger.severe(e.getMessage());
        } catch (IOException e) {
            logger.severe("error loading raw data from input sream (in Converter.loadRaw): ");
            logger.info(e.getMessage());
        }
        return res;
    }

    public static Converter initFromRaw (InputStream inStream, Logger logger){
        int istart = 0;
        int istop = Integer.MAX_VALUE;
        return initFromRaw(inStream, istart, istop, logger);
    }

    public EncodedText getEncoded (){
        return encoded;
    }
}

package com.zuevval.lab2ArithmCoding;

import java.util.HashMap;
import java.util.Map;


/** arithmetic coding for data compression
 *  @author Valerii Zuev
 */

public class Converter {

    private static final double maxProbability;
    private static final double minProbability;
    static {
        maxProbability = 1.0;
        minProbability = 0.0;
    }

    /** Calculate probabilities of each character in input string
     *  as [number of occurences]/[length of string]
     */
    static Map<Character, Double> probabilities(String input){
        Map<Character, Integer> instances = new HashMap<>();
        final int nInput = input.length();
        for (int i = 0; i < nInput; i++){
            char key = input.charAt(i);
            Integer count = instances.get(key);
            if (count == null) count = 0;
            count++;
            instances.put(key, count);
        }

        final int nInstances = instances.size();
        Map<Character, Double> res = new HashMap<>();
        for(Character key : instances.keySet()){
            res.put(key, (double)instances.get(key) / nInstances);
        }
        return res;
    }

    /** Split interval [0;1) into non-intersecting pieces for arithmetic coding
     * corresponding to each character's probability
     * @return for each char - interval [a;b) in [0;1)
     */
    static Map<Character, Segment> segmentate (Map<Character, Double> probabilities){
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

    public static EncodedText encode(String input){
        Map<Character, Double> dictionary = probabilities(input);
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
}

package com.zuevval.lab2ArithmCoding;

/** Segment - a unit representing an interval [left; right) in real numbers
 *  serves Converter class for arithmetic coding
 */
class Segment {
    double left;
    double right;

    Segment (double l, double r){
        left = l;
        right = r;
    }

    Segment() {
        left = 0.0;
        right = 0.0;
    }
}

package org.anttijuustila;

public interface WordProcessor {
    WordProcessor setWordFilter(WordFilter handler);
    void process(char ch);
    void finish();
}

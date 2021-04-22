package org.anttijuustila;

public class WordProcessorImplementation implements WordProcessor {

    private WordFilter filter = null;
    private static int MAX_CHAR_ARRAY_LEN = 100;
    private char array[] = null;
    private int currentIndex = 0;

    @Override
    public WordProcessor setWordFilter(WordFilter handler) {
        if (handler == null) {
            throw new IllegalArgumentException("Handler was null");
        }
        this.filter = handler;
        array = new char[MAX_CHAR_ARRAY_LEN];
        return this;
    }

    @Override
    public void process(char ch) {
        if (Character.isLetter(ch)) {
            array[currentIndex] = Character.toLowerCase(ch);
            currentIndex++;
        } else {
            if (currentIndex > 0) {
                String word = new String(array, 0, currentIndex);
                currentIndex = 0;
                filter.handle(word);
            }
        }
    }

    @Override
    public void finish() {
        filter.finish();
    }
    
}

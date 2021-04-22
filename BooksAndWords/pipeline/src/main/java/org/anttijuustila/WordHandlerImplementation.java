package org.anttijuustila;

import java.util.HashMap;
import java.util.Map;

public class WordHandlerImplementation implements WordHandler {

    private ResultHandler handler = null;
    private Map<String, Integer> wordCounts = null;

    @Override
    public WordHandler setResultHandler(ResultHandler handler) {
        if (handler == null) {
            throw new IllegalArgumentException("Handler was null");
        }
        this.handler = handler;
        wordCounts = new HashMap<>();
        return this;
    }

    @Override
    public void handle(String word) {
        if (wordCounts.containsKey(word)) {
            Integer value = wordCounts.get(word);
            value += 1;
            wordCounts.replace(word, value);
        } else {
            wordCounts.put(word, 1);
        }
    }

    @Override
    public void finish() {
        handler.handleResults(wordCounts);
    }
    
}

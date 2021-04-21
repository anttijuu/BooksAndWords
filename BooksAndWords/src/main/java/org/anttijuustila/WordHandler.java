package org.anttijuustila;

public interface WordHandler {
    WordHandler setResultHandler(ResultHandler handler);
    void handle(String word);
    void finish();
}

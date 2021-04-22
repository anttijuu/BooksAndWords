package org.anttijuustila;

import java.io.FileNotFoundException;
import java.io.IOException;

public interface WordFilter {
    WordFilter setWordHandler(WordHandler handler);
    WordFilter readFile(String fileName) throws IOException, FileNotFoundException;
    void handle(String word);
    void finish();
}

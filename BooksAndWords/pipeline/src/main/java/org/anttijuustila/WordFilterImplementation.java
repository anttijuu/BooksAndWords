package org.anttijuustila;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class WordFilterImplementation implements WordFilter {

    private List<String> wordsToFilter = new ArrayList<>();
    private WordHandler handler = null;

    @Override
    public WordFilter setWordHandler(WordHandler handler) {
        this.handler = handler;
        return this;
    }

    @Override
    public WordFilter readFile(String fileName) throws IOException, FileNotFoundException {
        File file = new File(fileName); 
        FileReader fileReader = new FileReader(file);
        BufferedReader bufferedReader = new BufferedReader(fileReader); 
        String line;
        while ((line = bufferedReader.readLine()) != null) {
            String [] items = line.split(",");
            Collections.addAll(wordsToFilter, items);
        }
        fileReader.close(); 
        return this;
    }

    @Override
    public void handle(String word) {
        if (!wordsToFilter.contains(word)) {
            handler.handle(word);
        }
    }

    @Override
    public void finish() {
        handler.finish();
    }
}

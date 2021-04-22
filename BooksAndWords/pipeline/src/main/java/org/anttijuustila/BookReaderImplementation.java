package org.anttijuustila;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class BookReaderImplementation implements BookReader {

    private WordProcessor processor = null;

    @Override
    public BookReader setWordProcessor(WordProcessor processor) {
        if (processor == null) {
            throw new IllegalArgumentException("Processor was null");
        }
        this.processor = processor;
        return this;
    }

    @Override
    public void readFile(String fileName) throws IOException, IllegalArgumentException, FileNotFoundException {
        if (fileName == null || processor == null) {
            throw new IllegalArgumentException("File name or processor was null");
        }
        FileReader reader = new FileReader(fileName);
        int c;
        while ((c = reader.read()) != -1) {
            processor.process((char)c);
        }
        reader.close();
        processor.finish();
    }
    
}

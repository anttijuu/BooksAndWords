package org.anttijuustila;

import java.io.FileNotFoundException;
import java.io.IOException;

public interface BookReader {
    BookReader setWordProcessor(WordProcessor processor);
    void readFile(String fileName) throws IOException, IllegalArgumentException, FileNotFoundException;
}

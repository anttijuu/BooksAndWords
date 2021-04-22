package org.anttijuustila;

import java.io.IOException;


/**
 * Hello world!
 *
 */
public class BooksAndWordsApp 
{
    public static void main(String[] args)
    {
        if (args.length != 3) {
            System.out.println("Usage: java -cp target/classes org.anttijuustila.BooksAndReadersApp book-file filter-file count-of-top-words");
            System.out.println("Example: java -cp target/classes org.anttijuustila.BooksAndWordsApp Bulk.txt filter.txt 25");
            return;
        }
        String file = args[0];
        String filter = args[1];
        int count = Integer.parseInt(args[2]);
        try {
            System.out.println("\nFile: " + file);
            System.out.println("Filter file: " + filter);
            System.out.println("Listing top " + count + " words...\n");
            long start = System.nanoTime();
            bookReader()
                .setWordProcessor(wordProcessor()
                    .setWordFilter(wordFilter()
                        .readFile(filter)
                        .setWordHandler(wordHandler()
                            .setResultHandler(resultHandler(count))
                            )
                        )
                    )
                    .readFile(file);
            long duration = System.nanoTime() - start;
            System.out.format("%n >>> Performance %5.5f secs.%n", duration / 1000000000.0);
        } catch (IllegalArgumentException | IOException e) {
            e.printStackTrace();
        }
    }

    private static BookReader bookReader() {
        return new BookReaderImplementation();
    }

    private static WordProcessor wordProcessor() {
        return new WordProcessorImplementation();
    }

    private static WordFilter wordFilter() {
        return new WordFilterImplementation();
    }

    private static WordHandler wordHandler() {
        return new WordHandlerImplementation();
    }

    private static ResultHandler resultHandler(int count) {
        return new ResultHandlerImplementation(count);
    }
}

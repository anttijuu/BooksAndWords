package org.anttijuustila;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.function.BiConsumer;
import java.util.function.Consumer;
import java.util.regex.Pattern;

/**
 * Hello world!
 *
 */
public class KickForwardApp 
{
    public static void main( String[] args )
    {
        if (args.length != 3) {
            System.out.println("Usage: java -cp target/classes org.anttijuustila.KickForwardApp book-file filter-file count-of-top-words");
            System.out.println("Example: java -cp target/classes org.anttijuustila.KickForwardApp Bulk.txt filter.txt 25");
            return;
        }
        run(args[0], args[1], Integer.parseInt(args[2]));
    }

    private static String stopWordsListFile = null;
    private static int countOfWordsToList = 100;

    // run > readfile > filterChars > normalize > scan > removeStopWords > frequencies > sort > print > noOp
    static void run(String fileName, String stopWordsFile, int countToList) {
        System.out.println("\nFile: " + fileName);
        System.out.println("Filter file: " + stopWordsFile);
        System.out.println("Listing top " + countToList + " words...\n");
        long start = System.nanoTime();
        stopWordsListFile = stopWordsFile;
        countOfWordsToList = countToList;
        readFile(fileName, KickForwardApp::filterChars);
        long duration = System.nanoTime() - start;
        System.out.format("%n >>> Performance %5.5f secs.%n", duration / 1000000000.0);
    }

    static void readFile(String fileName, BiConsumer<String, BiConsumer> filter) {
        try {
            Path path = Paths.get(fileName);
            String content;
            content = Files.readString(path, StandardCharsets.UTF_8);
            filter.accept(content, (BiConsumer<String, BiConsumer>) KickForwardApp::normalize);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static void filterChars(String data, BiConsumer<String, BiConsumer> normalize) {
        Pattern pattern = Pattern.compile("[\\W_]+");
        normalize.accept(pattern.matcher(data).replaceAll(" "), (BiConsumer<String, BiConsumer>) KickForwardApp::scan);
    }

    static void normalize(String data, BiConsumer<String, BiConsumer> scanner) {
        scanner.accept(data.toLowerCase(), (BiConsumer<String[], BiConsumer>) KickForwardApp::removeStopWords);
    }

    static void scan(String data, BiConsumer<String [], BiConsumer> remover) {
        remover.accept(data.split(" "), (BiConsumer<List<String>, BiConsumer>) KickForwardApp::frequencies);
    }

    static void removeStopWords(String [] data, BiConsumer<List<String>, BiConsumer> frequencyCounter) {
        List<String> wordsToFilter = new ArrayList<String>();
        try {
            File file = new File(stopWordsListFile); 
            FileReader fileReader = new FileReader(file);
            BufferedReader bufferedReader = new BufferedReader(fileReader); 
            String line;
            while ((line = bufferedReader.readLine()) != null) {
                String [] items = line.split(",");
                Collections.addAll(wordsToFilter, items);
            }
            fileReader.close(); 
        } catch (IOException e) {
            e.printStackTrace();
        }

        List<String> cleanedWords = new ArrayList<String>();
        for (String word: data) {
            if (!wordsToFilter.contains(word)) {
                cleanedWords.add(word);
            }
        }
        frequencyCounter.accept(cleanedWords, (BiConsumer<Map<String,Integer>, BiConsumer>) KickForwardApp::sort);
    }

    static void frequencies(List<String> words, BiConsumer<Map<String,Integer>, BiConsumer> sorter) {
        Map<String, Integer> wordCounts = new HashMap<>();
		for (String word : words) {
			Integer count = wordCounts.get(word);
			if (count != null) {
				wordCounts.put(word, count + 1);
			} else {
				wordCounts.put(word, 1);
			}
		}
        sorter.accept(wordCounts, (BiConsumer<Map<String,Integer>, Consumer<Void>>) KickForwardApp::printTop);
    }

    static void sort(Map<String,Integer> wordFrequencies, BiConsumer<Map<String,Integer>, Consumer<Void>> printer) {
        Map<String,Integer> topList = new LinkedHashMap<>();
        wordFrequencies.entrySet()
            .stream()
            .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
            .forEachOrdered(x -> topList.put(x.getKey(), x.getValue()));
        printer.accept(topList, (Consumer<Void>) KickForwardApp::noOp);
    }

    static void printTop(Map<String, Integer> sortedWords, Consumer<Void> noOpFunc) {
        int counter = 1;
        for (Map.Entry<String,Integer> entry : sortedWords.entrySet()) {
            System.out.format("%4d. %-30s %7d %n", counter++, padRight(entry.getKey(), 30), entry.getValue());
            if (counter > countOfWordsToList) {
                break;
            }
        }
		noOpFunc.accept(null);
	}

    static void noOp(Void v) {
        // No implementation.
    }

    private static String padRight(String s, int n) {
        return String.format("%-" + n + "s", s).replace(' ', '.');  
    }
}

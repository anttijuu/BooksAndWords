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
        KickForwardApp app = new KickForwardApp();
        app.run(args[0], args[1], Integer.parseInt(args[2]));
    }

    private String stopWordsListFile = null;
    private int countOfWordsToList = 100;

    // run > readfile > filterChars > normalize > scan > removeStopWords > frequencies > sort > print > noOp
    void run(String fileName, String stopWordsFile, int countToList) {
        stopWordsListFile = stopWordsFile;
        countOfWordsToList = countToList;
        readFile(fileName, (t, u) -> {
            filterChars(t, u);
        });
    }

    void readFile(String fileName, BiConsumer<String, BiConsumer> filter) {
        try {
            Path path = Paths.get(fileName);
            String content;
            content = Files.readString(path, StandardCharsets.UTF_8);
            filter.accept(content, (BiConsumer<String, BiConsumer>) this::normalize);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    void filterChars(String data, BiConsumer<String, BiConsumer> normalize) {
        Pattern pattern = Pattern.compile("[\\W_]+");
        normalize.accept(pattern.matcher(data).replaceAll(" "), (BiConsumer<String, BiConsumer>) this::scan);
    }

    void normalize(String data, BiConsumer<String, BiConsumer> scanner) {
        scanner.accept(data.toLowerCase(), (BiConsumer<String[], BiConsumer>) this::removeStopWords);
    }

    void scan(String data, BiConsumer<String [], BiConsumer> remover) {
        remover.accept(data.split(" "), (BiConsumer<List<String>, BiConsumer>) this::frequencies);
    }

    void removeStopWords(String [] data, BiConsumer<List<String>, BiConsumer> frequencyCounter) {
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
        frequencyCounter.accept(cleanedWords, (BiConsumer<Map<String,Integer>, BiConsumer>) this::sort);
    }

    void frequencies(List<String> words, BiConsumer<Map<String,Integer>, BiConsumer> sorter) {
        Map<String, Integer> wordCounts = new HashMap<>();
		for (String word : words) {
			Integer count = wordCounts.get(word);
			if (count != null) {
				wordCounts.put(word, count + 1);
			} else {
				wordCounts.put(word, 1);
			}
		}
        sorter.accept(wordCounts, (BiConsumer<Map<String,Integer>, Consumer<Void>>) this::printTop);
    }

    void sort(Map<String,Integer> wordFrequencies, BiConsumer<Map<String,Integer>, Consumer<Void>> printer) {
        Map<String,Integer> topList = new LinkedHashMap<>();
        wordFrequencies.entrySet()
            .stream()
            .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
            .forEachOrdered(x -> topList.put(x.getKey(), x.getValue()));
        printer.accept(topList, (Consumer<Void>) this::noOp);
    }

    void printTop(Map<String, Integer> sortedWords, Consumer<Void> noOpFunc) {
        int counter = 1;
        for (Map.Entry<String,Integer> entry : sortedWords.entrySet()) {
            System.out.format("%4d. %-30s %7d %n", counter++, padRight(entry.getKey(), 30), entry.getValue());
            if (counter > countOfWordsToList) {
                break;
            }
        }
		noOpFunc.accept(null);
	}

    void noOp(Void v) {
        // No implementation.
    }

    private String padRight(String s, int n) {
        return String.format("%-" + n + "s", s).replace(' ', '.');  
    }
}

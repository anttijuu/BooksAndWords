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
public class ParallelKickForwardApp 
{
    public static void main( String[] args )
    {
        if (args.length != 3) {
            System.out.println("Usage: java -cp target/classes org.anttijuustila.ParallelKickForwardApp book-file filter-file count-of-top-words");
            System.out.println("Example: java -cp target/classes org.anttijuustila.ParallelKickForwardApp Bulk.txt filter.txt 25");
            return;
        }
        run(args[0], args[1], Integer.parseInt(args[2]));
    }

    private static String stopWordsListFile = null;
    private static int countOfWordsToList = 100;
    private static Map<String,Integer> finalTopList = new LinkedHashMap<>();

    // run > readfile > filterChars > normalize > scan > removeStopWords > frequencies > sort > print > noOp
    static void run(String fileName, String stopWordsFile, int countToList) {
        System.out.println("\nFile: " + fileName);
        System.out.println("Filter file: " + stopWordsFile);
        System.out.println("Listing top " + countToList + " words...\n");
        long start = System.nanoTime();
        stopWordsListFile = stopWordsFile;
        countOfWordsToList = countToList;
        readFile(fileName, ParallelKickForwardApp::filterChars);
        long duration = System.nanoTime() - start;
        System.out.format("%n >>> Performance %5.5f secs.%n", duration / 1000000000.0);
    }

    static void readFile(String fileName, BiConsumer<String, BiConsumer> func) {
        try {
            Path path = Paths.get(fileName);
            List<String> lines = Files.readAllLines(path, StandardCharsets.UTF_8);
            int linesTotal = lines.size();
            int sectionLines = lines.size() / 4;
            List<Thread> threads = new ArrayList<Thread>();
            int lastLine = linesTotal - 1;
            for (int i = 0; i < 4; i++) {
                int firstLine = Math.max(lastLine - sectionLines, 0);
                String section = lines.subList(firstLine, lastLine).toString();
                lastLine = firstLine - 1;
                Thread thread = new Thread( () -> {
                    func.accept(section, (BiConsumer<String, BiConsumer>) ParallelKickForwardApp::normalize);
                });
                threads.add(thread);
                thread.start();
            }
            for (Thread thread : threads) {
                thread.join();
            }
            sort(finalTopList, ParallelKickForwardApp::printTop);
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }

    static void filterChars(String data, BiConsumer<String, BiConsumer> func) {
        Pattern pattern = Pattern.compile("[\\W_]+");
        func.accept(pattern.matcher(data).replaceAll(" "), (BiConsumer<String, BiConsumer>) ParallelKickForwardApp::scan);
    }

    static void normalize(String data, BiConsumer<String, BiConsumer> func) {
        func.accept(data.toLowerCase(), (BiConsumer<String[], BiConsumer>) ParallelKickForwardApp::removeStopWords);
    }

    static void scan(String data, BiConsumer<String [], BiConsumer> func) {
        func.accept(data.split(" "), (BiConsumer<List<String>, BiConsumer>) ParallelKickForwardApp::frequencies);
    }

    static void removeStopWords(String [] data, BiConsumer<List<String>, BiConsumer> func) {
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
            if (!wordsToFilter.contains(word) && !isNumeric(word)) {
                cleanedWords.add(word);
            }
        }
        func.accept(cleanedWords, (BiConsumer<Map<String,Integer>, BiConsumer>) ParallelKickForwardApp::sort);
    }

    static void frequencies(List<String> words, BiConsumer<Map<String,Integer>, BiConsumer> func) {
        Map<String, Integer> wordCounts = new HashMap<>();
		for (String word : words) {
			Integer count = wordCounts.get(word);
			if (count != null) {
				wordCounts.put(word, count + 1);
			} else {
				wordCounts.put(word, 1);
			}
		}
        func.accept(wordCounts, (BiConsumer<Map<String,Integer>, Consumer<Void>>) ParallelKickForwardApp::saveTop);
    }

    static void sort(Map<String,Integer> wordFrequencies, BiConsumer<Map<String,Integer>, Consumer<Void>> func) {
        Map<String,Integer> topList = new LinkedHashMap<>();
        wordFrequencies.entrySet()
            .stream()
            .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
            .forEachOrdered(x -> topList.put(x.getKey(), x.getValue()));
        func.accept(topList, (Consumer<Void>) ParallelKickForwardApp::noOp);
    }

    static void saveTop(Map<String, Integer> sortedWords, Consumer<Void> func) {
        int counter = 1;
        for (Map.Entry<String,Integer> entry : sortedWords.entrySet()) {
            addToFinal(entry);
            if (counter > countOfWordsToList * 2) {
                break;
            }
        }
		func.accept(null);
	}

    static synchronized void addToFinal(Map.Entry<String,Integer> entry) {
        Integer count = finalTopList.get(entry.getKey());
        if (count != null) {
            finalTopList.put(entry.getKey(), count + entry.getValue());
        } else {
            finalTopList.put(entry.getKey(), entry.getValue());
        }
    }

    static void printTop(Map<String, Integer> sortedWords, Consumer<Void> func) {
        int counter = 1;
        for (Map.Entry<String,Integer> entry : sortedWords.entrySet()) {
            System.out.format("%4d. %-30s %7d %n", counter++, padRight(entry.getKey(), 30), entry.getValue());
            if (counter > countOfWordsToList) {
                break;
            }
        }
		func.accept(null);
	}

    static void noOp(Void v) {
        // No implementation.
    }

    private static String padRight(String s, int n) {
        return String.format("%-" + n + "s", s).replace(' ', '.');  
    }

    private static boolean isNumeric(String str) {
        return str.matches("-?\\d+(\\.\\d+)?");
      }
}

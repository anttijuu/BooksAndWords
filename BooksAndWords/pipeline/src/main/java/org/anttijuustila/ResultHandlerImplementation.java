package org.anttijuustila;

import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.Map;

public class ResultHandlerImplementation implements ResultHandler {

    private int itemsToList = 100;
    private Map<String,Integer> topList = null;

    ResultHandlerImplementation(int itemsToList) {
        this.itemsToList = itemsToList;
        topList = new LinkedHashMap<>();
    }

    @Override
    public void handleResults(Map<String, Integer> results) {
        results.entrySet()
            .stream()
            .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder()))
            .forEachOrdered(x -> topList.put(x.getKey(), x.getValue()));
        int counter = 1;
        for (Map.Entry<String,Integer> entry : topList.entrySet()) {
            System.out.format("%4d. %-30s %7d %n", counter++, padRight(entry.getKey(), 30), entry.getValue());
            if (counter > itemsToList) {
                break;
            }
        }
    }

    private String padRight(String s, int n) {
        return String.format("%-" + n + "s", s).replace(' ', '.');  
   }
   
}

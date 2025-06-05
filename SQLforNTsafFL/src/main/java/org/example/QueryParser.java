package org.example;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.util.*;

public class QueryParser {

        public static Map<String, List<SqlQuery>> parseQueriesFromResource() {
                Map<String, List<SqlQuery>> queriesByGroup = new LinkedHashMap<>();
                String currentGroup = null;
                String currentTitle = null;
                StringBuilder sqlBuilder = new StringBuilder();

                try (InputStream is = QueryParser.class.getClassLoader().getResourceAsStream("queries.sql");
                     BufferedReader reader = new BufferedReader(new InputStreamReader(is))) {

                        String line;
                        while ((line = reader.readLine()) != null) {
                                line = line.trim();

                                if (line.startsWith("### ")) {
                                        // Новая группа
                                        if (currentTitle != null && sqlBuilder.length() > 0 && currentGroup != null) {
                                                queriesByGroup.computeIfAbsent(currentGroup, k -> new ArrayList<>())
                                                        .add(new SqlQuery(currentTitle, sqlBuilder.toString()));
                                                sqlBuilder.setLength(0);
                                        }
                                        currentGroup = line.substring(4);
                                } else if (line.startsWith("#### ")) {
                                        // Новый заголовок
                                        if (currentTitle != null && sqlBuilder.length() > 0 && currentGroup != null) {
                                                queriesByGroup.computeIfAbsent(currentGroup, k -> new ArrayList<>())
                                                        .add(new SqlQuery(currentTitle, sqlBuilder.toString()));
                                                sqlBuilder.setLength(0);
                                        }
                                        currentTitle = line.substring(5);
                                } else if (line.startsWith("-- DATE_FIELDS:") || line.isEmpty()) {
                                        continue; // Пропускаем комментарии
                                } else {
                                        sqlBuilder.append(line).append("\n");
                                }
                        }

                        // Добавляем последний запрос
                        if (currentGroup != null && currentTitle != null && sqlBuilder.length() > 0) {
                                queriesByGroup.computeIfAbsent(currentGroup, k -> new ArrayList<>())
                                        .add(new SqlQuery(currentTitle, sqlBuilder.toString()));
                        }

                } catch (Exception e) {
                        throw new RuntimeException("Ошибка чтения файла queries.sql", e);
                }

                return queriesByGroup;
        }
}
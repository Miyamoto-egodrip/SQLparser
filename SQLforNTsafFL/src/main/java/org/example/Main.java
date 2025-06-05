package org.example;

import java.sql.*;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class Main {

    private static final String DB_URL = "jdbc:postgresql://10.19.54.115:5432/antifraud_41";
    private static final String DB_USER = "fraud_ic";
    private static final String DB_PASSWORD = "fraud_ic";

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

        System.out.print("Введите начальную дату и время (YYYY-MM-DD HH:MM:SS): ");
        String startInput = scanner.nextLine().trim();

        System.out.print("Введите конечную дату и время (YYYY-MM-DD HH:MM:SS): ");
        String endInput = scanner.nextLine().trim();

        LocalDateTime start, end;

        try {
            start = LocalDateTime.parse(startInput, formatter);
            end = LocalDateTime.parse(endInput, formatter);
        } catch (Exception e) {
            System.err.println("Неверный формат даты. Используйте: YYYY-MM-DD HH:MM:SS");
            return;
        }

        System.out.println("Период: " + start + " — " + end);

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            Map<String, List<SqlQuery>> allQueries = QueryParser.parseQueriesFromResource();

            for (Map.Entry<String, List<SqlQuery>> entry : allQueries.entrySet()) {
                System.out.println("Выполняется группа: " + entry.getKey());
                new QueryExecutor(conn, start, end).executeQueries(entry.getValue(), entry.getKey());
            }

        } catch (Exception e) {
            System.err.println("Ошибка работы с БД: " + e.getMessage());
        }
    }
}
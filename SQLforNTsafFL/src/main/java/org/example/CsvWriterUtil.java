package org.example;

import com.opencsv.CSVWriter;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.*;

public class CsvWriterUtil {

    public static void writeResultSetToCsv(ResultSet rs, String folder, String filename) throws IOException {
        String dirPath = "output/" + sanitizeFilename(folder);
        new File(dirPath).mkdirs();

        String fullPath = dirPath + "/" + sanitizeFilename(filename) + ".csv";

        try (CSVWriter writer = new CSVWriter(
                new OutputStreamWriter(new FileOutputStream(fullPath), StandardCharsets.UTF_8))) {

            ResultSetMetaData meta = rs.getMetaData();
            int columnCount = meta.getColumnCount();

            // Записываем заголовки
            String[] headers = new String[columnCount];
            for (int i = 1; i <= columnCount; i++) {
                headers[i - 1] = meta.getColumnName(i);
            }
            writer.writeNext(headers);

            // Записываем данные
            while (rs.next()) {
                String[] row = new String[columnCount];
                for (int i = 1; i <= columnCount; i++) {
                    row[i - 1] = rs.getString(i);
                }
                writer.writeNext(row);
            }

            System.out.println("Сохранено: " + fullPath);
        } catch (Exception e) {
            throw new IOException("Ошибка при записи CSV: " + e.getMessage());
        }
    }

    private static String sanitizeFilename(String filename) {
        return filename.replaceAll("[<>:/|?*\"\\n\\r]", "_");
    }
}
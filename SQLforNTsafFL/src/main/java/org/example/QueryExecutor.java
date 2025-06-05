package org.example;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class QueryExecutor {
    private final Connection connection;
    private final LocalDateTime start;
    private final LocalDateTime end;
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public QueryExecutor(Connection conn, LocalDateTime start, LocalDateTime end) {
        this.connection = conn;
        this.start = start;
        this.end = end;
    }

    public void executeQueries(List<SqlQuery> queries, String group) {
        for (SqlQuery query : queries) {
            System.out.println("Выполняется: " + query.getTitle());

            // Подставляем даты с одинарными кавычками
            String processedSql = query.getSql()
                    .replace("__START__",   start.format(formatter) )
                    .replace("__END__",   end.format(formatter) );

            // Для отладки — можно временно раскомментировать
             System.out.println("SQL: " + processedSql);

            try (PreparedStatement stmt = connection.prepareStatement(processedSql)) {
                boolean hasResults = stmt.execute();

                while (hasResults) {
                    try (ResultSet rs = stmt.getResultSet()) {
                        CsvWriterUtil.writeResultSetToCsv(rs, group, query.getTitle());
                    }
                    hasResults = stmt.getMoreResults();
                }

            } catch (Exception e) {
                System.err.println("Ошибка выполнения запроса '" + query.getTitle() + "': " + e.getMessage());
            }
        }
    }
}
package org.example;

public class SqlQuery {
    private final String title;
    private final String sql;

    public SqlQuery(String title, String sql) {
        this.title = title;
        this.sql = sql;
    }

    public String getTitle() {
        return title;
    }

    public String getSql() {
        return sql;
    }
}
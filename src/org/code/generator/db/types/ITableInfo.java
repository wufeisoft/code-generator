package org.code.generator.db.types;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by wufei on 16-4-23.
 */
public interface ITableInfo {

    String getTableName(ResultSet resultSet) throws SQLException;

    String getTableRemarks(ResultSet resultSet) throws SQLException;

    String getColumnName(ResultSet resultSet) throws SQLException;

    int getJdbcType(ResultSet resultSet) throws SQLException;

    int getLength(ResultSet resultSet) throws SQLException;

    int getScale(ResultSet resultSet) throws SQLException;

    String getRemarks(ResultSet resultSet) throws SQLException;

    String getDefaultValue(ResultSet resultSet) throws SQLException;

    String getUserDefaultValue(ResultSet resultSet);

    boolean getNullable(ResultSet resultSet) throws SQLException;
}

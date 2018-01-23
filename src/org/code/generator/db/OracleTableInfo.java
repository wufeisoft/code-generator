package org.code.generator.db;

import org.code.generator.db.types.ITableInfo;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by wufei on 16-4-23.
 */
public class OracleTableInfo implements ITableInfo{
    @Override
    public String getTableName(ResultSet resultSet) throws SQLException {
        return resultSet.getString("TABLE_NAME");
    }

    @Override
    public String getTableRemarks(ResultSet resultSet) throws SQLException {
        return resultSet.getString("REMARKS");
    }

    @Override
    public String getColumnName(ResultSet resultSet) throws SQLException {
        return resultSet.getString("COLUMN_NAME");
    }

    @Override
    public int getJdbcType(ResultSet resultSet) throws SQLException {
        return resultSet.getInt("DATA_TYPE");
    }

    @Override
    public int getLength(ResultSet resultSet) throws SQLException {
        return resultSet.getInt("COLUMN_SIZE");
    }

    @Override
    public int getScale(ResultSet resultSet) throws SQLException {
        return resultSet.getInt("DECIMAL_DIGITS");
    }

    @Override
    public String getRemarks(ResultSet resultSet) throws SQLException {
        return resultSet.getString("REMARKS");
    }

    @Override
    public String getDefaultValue(ResultSet resultSet) throws SQLException {
        return resultSet.getString("COLUMN_DEF");
    }

    @Override
    public String getUserDefaultValue(ResultSet resultSet) {
        return null;
    }

    @Override
    public boolean getNullable(ResultSet resultSet) throws SQLException {
        return resultSet.getInt("NULLABLE") == 0 ? false : true;
    }
}

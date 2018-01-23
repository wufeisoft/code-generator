package org.code.generator.db.types;

import org.code.generator.db.TableColumn;

import java.math.BigDecimal;
import java.sql.Types;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * Created by wufei on 16-4-23.
 */
public class MysqlJavaTypeResolver implements ColumnTypeResolver {
    private Map<Integer, String> typeMap;

    public MysqlJavaTypeResolver() {
        super();

        typeMap = new HashMap<Integer, String>();

        typeMap.put(Types.ARRAY, Object.class.getName());
        typeMap.put(Types.BIGINT, Long.class.getName());
        typeMap.put(Types.BINARY, "byte[]"); //$NON-NLS-1$
        typeMap.put(Types.BIT, Integer.class.getName());
        typeMap.put(Types.BLOB, "byte[]"); //$NON-NLS-1$
        typeMap.put(Types.BOOLEAN, Boolean.class.getName());
        typeMap.put(Types.CHAR, String.class.getName());
        typeMap.put(Types.CLOB, String.class.getName());
        typeMap.put(Types.DATALINK, Object.class.getName());
        typeMap.put(Types.DATE, String.class.getName());
        typeMap.put(Types.DISTINCT, Object.class.getName());
        typeMap.put(Types.DOUBLE, Double.class.getName());
        typeMap.put(Types.FLOAT, Double.class.getName());
        typeMap.put(Types.INTEGER, Integer.class.getName());
        typeMap.put(Types.JAVA_OBJECT, Object.class.getName());
        typeMap.put(Types.LONGVARBINARY, "byte[]"); //$NON-NLS-1$
        typeMap.put(Types.LONGVARCHAR, String.class.getName());
        typeMap.put(NCHAR, String.class.getName());
        typeMap.put(NCLOB, String.class.getName());
        typeMap.put(NVARCHAR, String.class.getName());
        typeMap.put(Types.NULL, Object.class.getName());
        typeMap.put(Types.OTHER, Object.class.getName());
        typeMap.put(Types.REAL, Float.class.getName());
        typeMap.put(Types.REF, Object.class.getName());
        typeMap.put(Types.SMALLINT, Short.class.getName());
        typeMap.put(Types.STRUCT, Object.class.getName());
        typeMap.put(Types.TIME, String.class.getName());
        typeMap.put(Types.TIMESTAMP, String.class.getName());
        typeMap.put(Types.TINYINT, Integer.class.getName());
        typeMap.put(Types.VARBINARY, "byte[]"); //$NON-NLS-1$
        typeMap.put(Types.VARCHAR, String.class.getName());
    }

    public void addConfigurationProperties(Properties properties) {
    }

    @Override
    public String calculateJavaType(
            TableColumn tableColumn) {
        String answer;
        String jdbcTypeInformation = typeMap
                .get(tableColumn.getJdbcType());

        if (jdbcTypeInformation == null) {
            switch (tableColumn.getJdbcType()) {
                case Types.DECIMAL:
                case Types.NUMERIC:
                    if (tableColumn.getScale() > 0
                            || tableColumn.getLength() > 18) {
                        answer = BigDecimal.class.getName();
                    } else if (tableColumn.getLength() > 9) {
                        answer = Long.class.getName();
                    } else if (tableColumn.getLength() > 4) {
                        answer = Integer.class.getName();
                    } else {
                        answer = Integer.class.getName();
                    }
                    break;

                default:
                    answer = null;
                    break;
            }
        } else {
            answer = jdbcTypeInformation;
        }

        return answer;
    }

}

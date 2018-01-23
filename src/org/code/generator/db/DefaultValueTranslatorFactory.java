package org.code.generator.db;

import org.code.generator.db.types.IDefaultValueTranslator;
import org.code.generator.util.StringUtility;

/**
 * Created by wufei on 16-4-23.
 */
public class DefaultValueTranslatorFactory {
    private static IDefaultValueTranslator iDefaultValueTranslator;
    public static void initIDefaultValueTranslator(String driverClass){
        if(driverClass.contains("oracle")){
            iDefaultValueTranslator = new OracleDefaultValueTranslator();
        } else if(driverClass.contains("mysql")){
            iDefaultValueTranslator = new MysqlDefaultValueTranslator();
        }
    }

    public static String getDefaultValue(TableColumn tableColumn, String defaultValue) {
        if(StringUtility.stringHasValue(defaultValue))
            return defaultValue;

        return iDefaultValueTranslator.getDefaultValue(tableColumn, defaultValue);
    }
}

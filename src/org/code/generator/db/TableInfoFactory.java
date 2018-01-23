package org.code.generator.db;

import org.code.generator.db.types.ITableInfo;

/**
 * Created by wufei on 16-4-23.
 */
public class TableInfoFactory {
    public static ITableInfo getITableInfo(String driverClass){
        if(driverClass.contains("oracle")){
            return new OracleTableInfo();
        } else if(driverClass.contains("mysql")){
            return  new MysqlTableInfo();
        }

        return null;
    }
}

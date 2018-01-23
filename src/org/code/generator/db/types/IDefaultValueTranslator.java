package org.code.generator.db.types;

import org.code.generator.db.TableColumn;

/**
 * Created by wufei on 16-4-23.
 */
public interface IDefaultValueTranslator {
    String getDefaultValue(TableColumn tableColumn, String defaultValue);
}

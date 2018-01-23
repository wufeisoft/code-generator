<#assign parameterType="${result.getFirstCharacterUppercase(result.getTableName())}">
<#assign tableLowercaseField="${result.getFirstCharacterLowercase(result.getTableName())}">
<#assign tableRemark="${result.getTableRemarks() ! parameterType}">
{
    "locales.txt.list.${tableLowercaseField}": "${tableRemark} List",
<#foreach prop in result.getColumns()>
    <#if !prop.pKey>
    "locales.placeholder.${result.getFirstCharacterLowercase(prop.columnName)}": "${prop.remarks}",
    "locales.th.${result.getFirstCharacterLowercase(prop.columnName)}": "${prop.remarks}",
    </#if>
</#foreach>
}
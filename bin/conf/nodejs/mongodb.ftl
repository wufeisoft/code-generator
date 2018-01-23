<#assign tableField="${result.getFirstCharacterUppercase(result.getTableName())}">
db.getCollection("t_menus").insert({
    "code": "${tableField}",
    "name": "${tableField}",
    "parent": null,
    "sort": 3,
    "icon": "icon-diamond",
    "url": "/${tableField}Manager"
})
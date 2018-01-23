/**
 * COPYRIGHT (C) ${year} ${company}. ALL RIGHTS RESERVED.
 *
 * No part of this publication may be reproduced, stored in a retrieval system,
 * or transmitted, on any form or by any means, electronic, mechanical, photocopying,
 * recording, or otherwise, without the prior written permission of ${company}.
 *
 * Created By: ${user}
 * Created On: ${date}
 *
 * Amendment History:
 *
 * Amended By       Amended On      Amendment Description
 * ------------     -----------     ---------------------------------------------
 *
 **/

<#assign tableName="${result.getTableName()}">
<#assign tableField="${result.getFirstCharacterUppercase(result.getTableName())}">
<#assign tableLowercaseField="${result.getFirstCharacterLowercase(result.getTableName())}">
import * as ${tableField}Action from '../actions/${tableField}Action'
import { combineReducers } from 'redux';

/**
* 单条记录
* @param state
* @param action
* @returns {*}
*/
function singleResult(state = {}, action){
    switch (action.type){
        case ${tableField}Action.${tableName}_GET_BY_PK:
            return action.data;
        default :
            return state;
    }
}

/**
* 分页记录
* @param state
* @param action
* @returns {*}
*/
function pgList(state = {resultList:[],total:0,pageNo:1}, action){
    switch (action.type){
        case ${tableField}Action.${tableName}_LIST_PG:
            return action.data;
        default :
            return state;
    }
}

/**
* 表单初始化
* @param state
* @param action
* @returns {{}}
*/
function initForm(state={},action){
    switch (action.type){
        case ${tableField}Action.${tableName}_INIT_FROM:
            return {
            <#foreach prop in result.getColumns()>
                <#if !prop.pKey>
                ${result.getFirstCharacterLowercase(prop.columnName)}:{},
                </#if>
            </#foreach>
            };
        default :
            return state;
    }
}

/**
* 聚合reducer
*/
export default combineReducers({
    singleResult,
    pgList,
    initForm,
});

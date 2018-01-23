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
import fetch from 'isomorphic-fetch'
import * as Constants from '../constants/constants'
import fetchUtil from '../utils/fetchUtil'

export const ${tableName}_GET_BY_PK = '${tableName}_GET_BY_PK';
export const ${tableName}_LIST_PG = '${tableName}_LIST_PG';
export const ${tableName}_ADD = '${tableName}_ADD';
export const ${tableName}_DELETE = '${tableName}_DELETE';
export const ${tableName}_UPDATE = '${tableName}_UPDATE';
export const ${tableName}_INIT_FROM = '${tableName}_INIT_FROM';

/**
* 根据主键获取单条
* @param key 主键id
* @returns {Function}
*/
export function getByPK(key){
    return dispatch => {
        //使页面处于loading状态
        dispatch(Constants.LOADING)

        fetch(Constants.URL_+'/${tableLowercaseField}/getByPK?key='+key,
        {
            method: 'get',
            headers: fetchUtil.getHeader(),
        })
        .then(fetchUtil.checkStatus)
        .then(fetchUtil.parseJSON)
        .then(function (data) {
            //取消页面loading状态
            dispatch(Constants.LOADED)
            //获取数据
            dispatch(fetchUtil.receivePosts(${tableName}_GET_BY_PK,data));
        }).catch(function (error) {
            //取消页面loading状态
            dispatch(Constants.LOADED)
            //显示异常
            fetchUtil.showError(error.message);
        })
    }
}

/**
* 显示列表数据
* @param pagination 查询条件
* @returns {Function}
*/
export function listPg(pagination){
    return dispatch => {
        //使页面处于loading状态
        dispatch(Constants.LOADING)
        fetch(Constants.URL_+'/${tableLowercaseField}/listPg',
        {
            method: 'post',
            headers: fetchUtil.getHeader(),
            body:JSON.stringify(pagination)
        })
        .then(fetchUtil.checkStatus)
        .then(fetchUtil.parseJSON)
        .then(function (data) {
            //使页面处于loading状态
            dispatch(Constants.LOADED)
            //获取数据
            dispatch(fetchUtil.receivePosts(${tableName}_LIST_PG,data));
            //初始化勾选状态
            dispatch({type:Constants.ACTION_INIT_SELECTED_ROW_KEYS});
        }).catch(function (error) {
            //使页面处于loading状态
            dispatch(Constants.LOADED)
            fetchUtil.showError(error.message);
        })
    }
}

/**
* 添加记录
* @param ${tableLowercaseField} 添加记录
* @param pagination     重新加载数据所需查询条件
* @returns {Function}
*/
export function add(${tableLowercaseField},pagination){
    return dispatch => {
        //使页面处于loading状态
        dispatch(Constants.LOADING)
        fetch(Constants.URL_+'/${tableLowercaseField}/add',
        {
            method: 'post',
            headers: fetchUtil.getHeader(),
            body:JSON.stringify(${tableLowercaseField})
        })
        .then(fetchUtil.checkStatus)
        .then(fetchUtil.parseJSON)
        .then(function (data) {
            //使页面处于loading状态
            dispatch(Constants.LOADED)
            //显示成功
            fetchUtil.showSuccess();
            //重新加载数据
            dispatch(listPg(pagination));
            //重置选中的key
            //关闭弹窗
            dispatch({type:Constants.ACTION_HIDE_MODAL,index:0});
            //初始化新增表单
            dispatch({type:${tableName}_INIT_FROM});
        }).catch(function (error) {
            //使页面处于loading状态
            dispatch(Constants.LOADED)
            //显示异常
            fetchUtil.showError(error.message);
        })
    }
}

/**
* 更新记录
* @param ${tableLowercaseField} 更新记录
* @param pagination     重新加载数据所需查询条件
* @returns {Function}
*/
export function update(${tableLowercaseField},pagination){
    return dispatch => {
        //使页面处于loading状态
        dispatch(Constants.LOADING)
        fetch(Constants.URL_+'/${tableLowercaseField}/update',
        {
            method: 'put',
            headers: fetchUtil.getHeader(),
            body:JSON.stringify(${tableLowercaseField})
        })
        .then(fetchUtil.checkStatus)
        .then(fetchUtil.parseJSON)
        .then(function (data) {
            //使页面处于loading状态
            dispatch(Constants.LOADED)
            //显示成功
            fetchUtil.showSuccess();
            //重新加载数据
            dispatch(listPg(pagination));
            //关闭弹窗
            dispatch({type:Constants.ACTION_HIDE_MODAL,index:1});
            //初始化新增表单
            dispatch(fetchUtil.receivePosts(${tableName}_INIT_FROM));
        }).catch(function (error) {
            //使页面处于loading状态
            dispatch(Constants.LOADED)
            //显示异常
            fetchUtil.showError(error.message);
        })
    }
}

/**
* 根据主键集合删除数据
* @param primaryKeys 主键数组
* @param pagination     重新加载数据所需查询条件
* @returns {Function}
*/
export function deleteByPks(primaryKeys,pagination){
    return dispatch => {
        //使页面处于loading状态
        dispatch(Constants.LOADING)
        fetch(Constants.URL_+'/${tableLowercaseField}/delete',
        {
            method: 'post',
            headers: fetchUtil.getHeader(),
            body:JSON.stringify(primaryKeys)
        })
        .then(fetchUtil.checkStatus)
        .then(fetchUtil.parseJSON)
        .then(function (data) {
            //使页面处于loading状态
            dispatch(Constants.LOADED)
            //重新加载数据
            dispatch(listPg(pagination));
            //显示成功
            fetchUtil.showSuccess();
        }).catch(function (error) {
            //使页面处于loading状态
            dispatch(Constants.LOADED)
            //显示异常
            fetchUtil.showError(error.message);
        })
    }
}

/**
* 初始化form
* @returns {{type: string}}
*/
export function initForm(){
    return {type:${tableName}_INIT_FROM}
}

<?xml version="1.0" encoding="UTF-8"?> 
<!-- 
 **
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
 * ************     ***********     *********************************************
 *
 **
 -->
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${mapperPackage}.${result.getFirstCharacterUppercase(result.getTableName())}Mapper">
	<#assign parameterType="${result.getFirstCharacterUppercase(result.getTableName())}">
	<#assign tableLowercaseField="${result.getFirstCharacterLowercase(result.getTableName())}">
	<#assign tableName="${result.getTableName()}">
	<resultMap id="${parameterType}ResultMapper" type="${parameterType}">
    <#foreach prop in result.getColumns()>
		<result column="${prop.columnName}" property="${result.getFirstCharacterLowercase(prop.columnName)}"/>
	</#foreach>
	</resultMap>
	
	<#assign tmp="">
	<sql id="commonColumns">
	<#foreach prop in result.getColumns()>
		${tmp} ${prop.columnName}
		<#assign tmp=",">
	</#foreach>
	</sql>

	<#assign tmp="">
	<sql id="commonColumnsNotPK">
	<#foreach prop in result.getColumns()>
		<#if !prop.pKey>
		${tmp} ${prop.columnName}
		<#assign tmp=",">
		</#if>
	</#foreach>
	</sql>
	
	<#assign tmp="">
	<sql id="commonProcessDateColumns">
	<#foreach prop in result.getColumns()>
		<#if "DATE" == prop.jdbcTypeName || "TIME" == prop.jdbcTypeName || "TIMESTAMP" == prop.jdbcTypeName>
		${tmp} date_format(${prop.columnName}, '%Y-%m-%d %H:%i:%s') ${prop.columnName}
		<#else>
		${tmp} ${prop.columnName}
		</#if>
		<#assign tmp=",">
	</#foreach>
	</sql>
	
	<sql id="commonCondition">
		<#assign tmp="">
		<#foreach prop in result.getColumns()>
		<if test="${result.getFirstCharacterLowercase(prop.columnName)}!= null and ${result.getFirstCharacterLowercase(prop.columnName)}!= ''"> 
		<#if "DATE" == prop.jdbcTypeName || "TIME" == prop.jdbcTypeName || "TIMESTAMP" == prop.jdbcTypeName>
			AND ${prop.columnName} = str_to_date(${"#"}{${result.getFirstCharacterLowercase(prop.columnName)}},'%Y-%m-%d %H:%i:%s')
		<#else>
			AND ${prop.columnName} = ${"#"}{${result.getFirstCharacterLowercase(prop.columnName)}}
		</#if>
		</if>
		</#foreach>
	</sql>

	<sql id="commonConditionByPrefix">
		<if test="${tableLowercaseField} != null">
		<#foreach prop in result.getColumns()>
            <if test="${tableLowercaseField}.${result.getFirstCharacterLowercase(prop.columnName)}!= null and ${tableLowercaseField}.${result.getFirstCharacterLowercase(prop.columnName)}!= ''">
			<#if "DATE" == prop.jdbcTypeName || "TIME" == prop.jdbcTypeName || "TIMESTAMP" == prop.jdbcTypeName>
				AND ${prop.columnName} = str_to_date(${"#"}{${tableLowercaseField}.${result.getFirstCharacterLowercase(prop.columnName)}},'%Y-%m-%d %H:%i:%s')
			<#else>
				AND ${prop.columnName} = ${"#"}{${tableLowercaseField}.${result.getFirstCharacterLowercase(prop.columnName)}}
			</#if>
            </if>
		</#foreach>
        </if>
    </sql>

	<sql id="orderByClause">
		<if test="orderBy != null">
			<foreach collection="orderBy" index="key" item="value"
					 open=" order by " separator="," close=" ">
				<include refid="orderBy" />
			</foreach>
		</if>
	</sql>

	<sql id="orderBy">
		<choose>
		<#foreach prop in result.getColumns()>
        	<when test="key == '${result.getFirstCharacterLowercase(prop.columnName)}'">
				${prop.columnName} ${"$"}{value}
            </when>
		</#foreach>
		</choose>
	</sql>

	<insert id="save" useGeneratedKeys="true" keyProperty="${result.getFirstCharacterLowercase(result.getKey())}" parameterType="${parameterType}">
		<![CDATA[ INSERT INTO ${result.getTablePrefix()}${tableName} ( ]]>
		<include refid="commonColumnsNotPK"/>
		<![CDATA[
			) VALUES ( 
		<#assign tmp="">
		<#foreach prop in result.getColumns()>
			<#if !prop.pKey>
			<#if "DATE" == prop.jdbcTypeName || "TIME" == prop.jdbcTypeName || "TIMESTAMP" == prop.jdbcTypeName>
			${tmp} str_to_date(${"#"}{${result.getFirstCharacterLowercase(prop.columnName)}},'%Y-%m-%d %H:%i:%s')
			<#else>
			${tmp} ${"#"}{${result.getFirstCharacterLowercase(prop.columnName)}}
			</#if>
			<#assign tmp=",">
			</#if>
		</#foreach>
  ) ]]>
	</insert>
	<update id="update" parameterType="${parameterType}">
		<![CDATA[ UPDATE ${result.getTablePrefix()}${tableName} SET 
		<#assign tmp="">
		<#foreach prop in result.getColumns()>
			<#if "DATE" == prop.jdbcTypeName || "TIME" == prop.jdbcTypeName || "TIMESTAMP" == prop.jdbcTypeName>
			${tmp} ${prop.columnName} = str_to_date(${"#"}{${result.getFirstCharacterLowercase(prop.columnName)}},'%Y-%m-%d %H:%i:%s')
			<#else>
			${tmp} ${prop.columnName} = ${"#"}{${result.getFirstCharacterLowercase(prop.columnName)}}
			</#if>
			<#assign tmp=",">
		</#foreach>
		WHERE ${result.getKey()} = ${"#"}{${result.getFirstCharacterLowercase(result.getKey())}}  ]]>
	</update>
	<insert id="saveOrUpdate" parameterType="${parameterType}">
		<![CDATA[ INSERT INTO ${result.getTablePrefix()}${tableName} ( ]]>
		<include refid="commonColumns"/>
		<![CDATA[
		) VALUES (
		<#assign tmp="">
		<#foreach prop in result.getColumns()>
			<#if "DATE" == prop.jdbcTypeName || "TIME" == prop.jdbcTypeName || "TIMESTAMP" == prop.jdbcTypeName>
			${tmp} str_to_date(${"#"}{${result.getFirstCharacterLowercase(prop.columnName)}},'%Y-%m-%d %H:%i:%s')
			<#else>
			${tmp} ${"#"}{${result.getFirstCharacterLowercase(prop.columnName)}}
			</#if>
			<#assign tmp=",">
		</#foreach>
		) ON DUPLICATE KEY UPDATE
		<#assign tmp="">
		<#foreach prop in result.getColumns()>
			${tmp} ${prop.columnName} = VALUES(${prop.columnName})
			<#assign tmp=",">
		</#foreach>
		]]>
	</insert>
	<insert id="batchSaveOrUpdate" parameterType="List">
		<![CDATA[ INSERT INTO ${result.getTablePrefix()}${tableName} ( ]]>
		<include refid="commonColumns"/>
		<![CDATA[ ) VALUES ]]>
        <foreach collection="list" item="item" index="index" separator=",">
			(
	<#assign tmp="">
	<#foreach prop in result.getColumns()>
		<#if "DATE" == prop.jdbcTypeName || "TIME" == prop.jdbcTypeName || "TIMESTAMP" == prop.jdbcTypeName>
			${tmp} str_to_date(${"#"}{item.${result.getFirstCharacterLowercase(prop.columnName)}},'%Y-%m-%d %H:%i:%s')
		<#else>
			${tmp} ${"#"}{item.${result.getFirstCharacterLowercase(prop.columnName)}}
		</#if>
		<#assign tmp=",">
	</#foreach>
        	)
        </foreach>
        <![CDATA[ ON DUPLICATE KEY UPDATE
	<#assign tmp="">
	<#foreach prop in result.getColumns()>
		${tmp} ${prop.columnName} = VALUES(${prop.columnName})
		<#assign tmp=",">
	</#foreach>
		]]>
	</insert>
	<delete id="deleteByPK" parameterType="${result.getKeyType()}">
		<![CDATA[ DELETE FROM ${result.getTablePrefix()}${tableName} WHERE ${result.getKey()} = ${"#"}{${result.getFirstCharacterLowercase(result.getKey())}}  ]]>
	</delete>
	<delete id="deleteByPKeys" parameterType="map">
		DELETE FROM ${result.getTablePrefix()}${tableName} WHERE
		<foreach collection="primaryKeys" index="index" item="id"
			open=" ${result.getKey()} IN(" separator="," close=") ">
			${"#"}{id}
		</foreach>
	</delete>
	<delete id="deleteByProperty" parameterType="${parameterType}">
		DELETE FROM ${result.getTablePrefix()}${tableName} WHERE 1 = 1
		<include refid="commonCondition"/>
	</delete>
	<select id="getByPK" parameterType="${result.getKeyType()}" resultMap="${parameterType}ResultMapper">
		<![CDATA[ SELECT ]]>
			 <include refid="commonProcessDateColumns"/>
		FROM ${result.getTablePrefix()}${tableName} WHERE ${result.getKey()} = ${"#"}{${result.getFirstCharacterLowercase(result.getKey())}}  
	</select>
	<select id="list" resultMap="${parameterType}ResultMapper">
		<![CDATA[ SELECT ]]>
			 <include refid="commonProcessDateColumns"/>
 		FROM ${result.getTablePrefix()}${tableName}
	</select>
	<select id="listByProperty" parameterType="${parameterType}" resultMap="${parameterType}ResultMapper">
		<![CDATA[ SELECT ]]>
			<include refid="commonProcessDateColumns"/>
		FROM ${result.getTablePrefix()}${tableName} WHERE 1=1 
		<include refid="commonCondition"/>
	</select>
	<select id="listPaginationByProperty" parameterType="${parameterType}" resultMap="${parameterType}ResultMapper">
		SELECT 
		<include refid="commonProcessDateColumns"/>
		FROM ${result.getTablePrefix()}${tableName} WHERE 1=1
    	<include refid="commonConditionByPrefix"/>
    	<include refid="orderByClause" />
	</select>
	<select id="findByCount" parameterType="${parameterType}" resultType="int">
		SELECT count(1) AS totalcount FROM ${result.getTablePrefix()}${tableName} WHERE 1=1 
		<include refid="commonCondition"/>
	</select>
</mapper>
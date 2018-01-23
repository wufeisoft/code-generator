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

<#assign tableField="${result.getFirstCharacterUppercase(result.getTableName())}">
import React from 'react';
import ReactDOM from 'react-dom';
import { Form, Input, Button ,Row,Col} from 'antd';
import * as CommonTypeAction from '../../actions/CommonTypeAction'
import { bindActionCreators } from 'redux';
import * as patternUtil from '../../utils/patternUtil'

const FormItem = Form.Item;

class Update${tableField} extends React.Component {
    constructor(props) {
        super(props);
        this.handleReset = this.handleReset.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
    }

    /**
     * 提交表单
     * @param e
     */
    handleSubmit(e) {
        e.preventDefault();
        this.props.form.validateFields((errors, values) => {
            if (!!errors) {
                return;
            }
            this.props.handleUpdate(values);
        });
    }

    /**
     * 重置表单数据
     * @param e
     */
    handleReset(e) {
        e.preventDefault();
        this.props.form.resetFields();
    }

    /**
    * 渲染组件
    * @returns {XML}
    */
    render() {
        const formItemLayout = {
            labelCol: {span: 6},
            wrapperCol: {span: 14},
        };
        const {singleResult} = this.props;

        const { getFieldProps } = this.props.form;

        //设置表单内容的name,验证规则,默认值
<#foreach prop in result.getColumns()>
    <#if !prop.pKey>
        <#assign cls="">
        <#assign param="${prop.remarks}">
        <#assign required="">
        <#if "DATE" == prop.jdbcTypeName || "TIME" == prop.jdbcTypeName || "TIMESTAMP" == prop.jdbcTypeName>
            <#assign cls="type: 'date', ">
        <#elseif "java.lang.Long" == prop.columnType || "java.lang.Integer" == prop.columnType>
            <#assign required="required: true, ">
            <#assign cls="pattern:patternUtil.numberPattern(0), ">
        <#elseif "java.math.BigDecimal" == prop.columnType>
            <#assign required="required: true, ">
            <#assign cls="pattern:patternUtil.numberPattern(${prop.scale}), ">
        </#if>
        <#if !prop.nullable>
            <#assign required="required: true, ">
        </#if>
        <#if param == "">
            <#assign param="${result.getFirstCharacterLowercase(prop.columnName)}">
        </#if>
        const ${result.getFirstCharacterLowercase(prop.columnName)} = getFieldProps('${result.getFirstCharacterLowercase(prop.columnName)}', {
            rules: [
                {${required}${cls}message: '请输入${param}'}
            ],
            initialValue:singleResult.${result.getFirstCharacterLowercase(prop.columnName)},
        });
    </#if>
</#foreach>

        return (
            <div>
                <Form horizontal onSubmit={this.handleSubmit} form={this.props.form}>
            <#foreach prop in result.getColumns()>
                <#if !prop.pKey>
                    <#assign cls="Input">
                    <#assign param="${prop.remarks}">
                    <#assign required="">
                    <#if "DATE" == prop.jdbcTypeName || "TIME" == prop.jdbcTypeName || "TIMESTAMP" == prop.jdbcTypeName>
                        <#assign cls="DatePicker">
                    <#elseif "java.lang.Long" == prop.columnType || "java.lang.Integer" == prop.columnType>
                        <#assign cls="Input">
                    <#elseif "java.math.BigDecimal" == prop.columnType>
                        <#assign cls="Input">
                    </#if>
                    <#if param == "">
                        <#assign param="${result.getFirstCharacterLowercase(prop.columnName)}">
                    </#if>
                    <FormItem
                            {...formItemLayout}
                            label="${param}："
                    >
                        <${cls} placeholder="请输入${param}" {...${result.getFirstCharacterLowercase(prop.columnName)}}/>
                    </FormItem>
                <#else>
                    <FormItem>
                        <Input type="hidden"  {...getFieldProps('${result.getFirstCharacterLowercase(prop.columnName)}', {initialValue:singleResult.${result.getFirstCharacterLowercase(prop.columnName)}})}/>
                    </FormItem>
                </#if>
            </#foreach>
                    <Row >
                        <Col span="16" offset="8">
                        <Button type="primary" htmlType="submit">确定</Button>
                        &nbsp;&nbsp;&nbsp;
                        <Button type="ghost" onClick={this.handleReset}>重置</Button>
                        </Col>
                    </Row>
                </Form>
            </div>
        )
    }
}
//约束子组件接受的prop类型
const propTypes = {
    handleUpdate: React.PropTypes.func.isRequired,
    singleResult: React.PropTypes.object.isRequired,
    initForm: React.PropTypes.object.isRequired,
};
Update${tableField}.propTypes = propTypes;

//初始化form表单
function mapPropsToFields(props) {
    return props.initForm
}

Update${tableField} = Form.create({mapPropsToFields})(Update${tableField})
export default Update${tableField};

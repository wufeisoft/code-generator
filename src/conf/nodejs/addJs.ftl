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
var ${tableField}Add = function () {
    var addRecord = function() {
        var form1 = $('#${tableName?lower_case}_add_form');
        var error1 = $('.alert-danger', form1);
        var success1 = $('.alert-success', form1);

        form1.validate({
            errorElement: 'span', //default input error message container
            errorClass: 'help-block help-block-error', // default input error message class
            focusInvalid: false, // do not focus the last invalid input
            ignore: "", // validate all fields including form hidden input
            messages: {
                payment: {
                    maxlength: jQuery.validator.format("Max {0} items allowed for selection"),
                    minlength: jQuery.validator.format("At least {0} items must be selected")
                },
                'checkboxes1[]': {
                    required: 'Please check some options',
                    minlength: jQuery.validator.format("At least {0} items must be selected"),
                },
                'checkboxes2[]': {
                    required: 'Please check some options',
                    minlength: jQuery.validator.format("At least {0} items must be selected"),
                }
            },
            rules: {
        <#foreach prop in result.getColumns()>
            <#if !prop.pKey>
                <#assign type="">
                <#assign param="${prop.remarks}">
                <#assign required="">
                <#if "DATE" == prop.jdbcTypeName || "TIME" == prop.jdbcTypeName || "TIMESTAMP" == prop.jdbcTypeName>
                <#elseif "java.lang.Long" == prop.columnType || "java.lang.Integer" == prop.columnType>
                    <#assign type="digits:true">
                <#elseif "java.math.BigDecimal" == prop.columnType>
                    <#assign type="number: true">
                    <#assign cls="pattern:patternUtil.numberPattern(${prop.scale}), ">
                </#if>
                <#if !prop.nullable>
                    <#assign required="required: true">
                </#if>
                <#if param == "">
                    <#assign param="${result.getFirstCharacterLowercase(prop.columnName)}">
                </#if>
                <#if required != "" || type != "">
                ${result.getFirstCharacterLowercase(prop.columnName)}: {
                    ${required}${(required != "" && type != "")?string(',','')}
                    ${type}
                },
                </#if>
            </#if>
        </#foreach>
            },

            invalidHandler: function(event, validator) { //display error alert on form submit
                success1.hide();
                error1.show();
                App.scrollTo(error1, -200);
            },

            errorPlacement: function(error, element) {
                if (element.is(':checkbox')) {
                    error.insertAfter(element.closest(".md-checkbox-list, .md-checkbox-inline, .checkbox-list, .checkbox-inline"));
                } else if (element.is(':radio')) {
                    error.insertAfter(element.closest(".md-radio-list, .md-radio-inline, .radio-list,.radio-inline"));
                } else {
                    error.insertAfter(element); // for other inputs, just perform default behavior
                }
            },

            highlight: function(element) { // hightlight error inputs
                $(element)
                    .closest('.form-group').addClass('has-error'); // set error class to the control group
            },

            unhighlight: function(element) { // revert the change done by hightlight
                $(element)
                    .closest('.form-group').removeClass('has-error'); // set error class to the control group
            },

            success: function(label) {
                label
                    .closest('.form-group').removeClass('has-error'); // set success class to the control group
            },

            submitHandler: function(form) {
                <#--success1.show();-->
                error1.hide();
                App.blockUI({
                    target: '#${tableName?lower_case}_add_form',
                    overlayColor: 'none',
                    cenrerY: true
                });
                $.post('/${tableField}Add',form1.serializeArray(),function(data){
                    App.unblockUI('#${tableName?lower_case}_add_form');
                    $("#ajax-modal").modal('hide');
                    ${tableField}Manager.refresh();
                }).error(function (err) {
                    App.unblockUI('#${tableName?lower_case}_add_form');
                    swal({
                        title: i18n.t('swal_title_error'),
                        text: i18n.t(err.responseText),
                        confirmButtonText: '<i class="fa fa-check"></i> Ok',
                        confirmButtonClass: 'btn btn-circle btn-success',
                        buttonsStyling: false
                    }).done();
                })
            }
        });

    };
    return {

        //main function to initiate the module
        init: function () {
            addRecord();
        }

    };

}();

jQuery(document).ready(function() {
    // main();
    ${tableField}Add.init();
});
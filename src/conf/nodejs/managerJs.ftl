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
var ${tableField}Manager = function () {
    var grid = new Datatable();
    var handleRecords = function () {
        grid.init({
            src: $("#${tableName?lower_case}_tb_container"),
            checkboxAllElement: $('#${tableName?lower_case}_chk_all'),
            filterElement: $('#${tableName?lower_case}_filter'),
            onSuccess: function (grid, response) {
                // grid:        grid object
                // response:    json object of server side ajax response
                // execute some code after table records loaded
            },
            onError: function (grid) {
                // execute some code on network or other general error
            },
            onDataLoad: function(grid) {
                // execute some code on ajax data load
            },
            dataTable: { // here you can define a typical datatable settings from http://datatables.net/usage/options

                // Uncomment below line("dom" parameter) to fix the dropdown overflow issue in the datatable cells. The default datatable layout
                // setup uses scrollable div(table-scrollable) with overflow:auto to enable vertical scroll(see: assets/global/scripts/datatable.js).
                // So when dropdowns used the scrollable div should be removed.
                //"dom": "<'row'<'col-md-8 col-sm-12'pli><'col-md-4 col-sm-12'<'table-group-actions pull-right'>>r>t<'row'<'col-md-8 col-sm-12'pli><'col-md-4 col-sm-12'>>",

                "bStateSave": false, // save datatable state(pagination, sort, etc) in cookie.

                "lengthMenu": [
                    [15, 20, 50, 100, 150],
                    [15, 20, 50, 100, 150] // change per page values here
                ],
                "pageLength": 15, // default record count per page
                "scrollY": "500px",
                "scrollX": true,
                "columns": [
                    { "data": "${result.getFirstCharacterLowercase(result.getKey())}" ,
                      "render": function ( data, type, full, meta ) {
                            return '<label class="mt-checkbox mt-checkbox-single mt-checkbox-outline"><input type="checkbox" class="checkboxes" value="'+ data + '"/><span></span></label>';
                      }
                    },
            <#foreach prop in result.getColumns()>
                <#if !prop.pKey>
                <#assign param="">
                <#assign tmp="">
                <#if prop.nullable>
                    <#assign param=", \"sDefaultContent\": \"\"">
                </#if>
                <#if prop_has_next>
                    <#assign tmp=",">
                </#if>
                    { "data": "${result.getFirstCharacterLowercase(prop.columnName)}"${param} }${tmp}
                </#if>
            </#foreach>
                ],
                "ajax": {
                    "url": "/${tableField}List", // ajax source
                },
                "order": [
                    [1, "asc"]
                ]// set first column as a default sort by asc
            }
        });

        $('#${tableName?lower_case}__add__').click(function () {
            App.blockUI({
                message: 'Loading...',
                target: grid.gettableContainer(),
                overlayColor: 'none',
                cenrerY: true,
                boxed: true
            });
            var $modal = $('#ajax-modal');
            $modal.load('/${tableField}AddView', '', function(){
                $modal.modal();
                App.unblockUI(grid.gettableContainer());
            });
        });

        $('#${tableName?lower_case}__delete__').click(function () {
            if(grid.getSelectedRowsCount() === 0) {
                swal({
                    title: i18n.t('swal_title_warning'),
                    text: i18n.t('warning_select_record'),
                    confirmButtonText: '<i class="fa fa-check"></i> Ok',
                    confirmButtonClass: 'btn btn-circle btn-success',
                    buttonsStyling: false
                }).done();

                return
            }

            swal({
                title: i18n.t('confirm_title_delete_records'),
                text: i18n.t('confirm_txt_delete_records'),
                type: 'warning',
                showCancelButton: true,
                confirmButtonText: '<i class="fa fa-trash"></i> Delete',
                confirmButtonClass: 'btn btn-circle btn-success',
                cancelButtonText: '<i class="fa fa-close"></i> No',
                cancelButtonClass: 'btn btn-sm btn-danger',
                buttonsStyling: false
            }).then(function(isConfirm) {
                if (isConfirm) {
                    App.blockUI({
                        message: 'Loading...',
                        target: grid.gettableContainer(),
                        overlayColor: 'none',
                        cenrerY: true,
                        boxed: true
                    });

                    $.ajax({url: "/${tableField}Delete",
                        type: 'post',
                        data: {params : grid.getSelectedRows()},
                        dataType: 'json',
                        success: function (result) {
                            grid.getDataTable().ajax.reload();
                            swal({
                                title: i18n.t('confirm_title_success'),
                                text: i18n.t('confirm_txt_delete_success'),
                                confirmButtonText: '<i class="fa fa-check"></i> Ok',
                                confirmButtonClass: 'btn btn-circle btn-success',
                                buttonsStyling: false
                            }).done();
                        },
                        error: function (err) {
                            swal({
                                title: i18n.t('swal_title_warning'),
                                text: i18n.t(err.responseText),
                                confirmButtonText: '<i class="fa fa-check"></i> Ok',
                                confirmButtonClass: 'btn btn-circle btn-success',
                                buttonsStyling: false
                            }).done();

                            App.unblockUI(grid.gettableContainer());
                        }
                    });
                }
            }).done();
        });

        $('#${tableName?lower_case}_update_').click(function(){
            if(grid.getSelectedRowsCount() === 0) {
                swal({
                    title: i18n.t('swal_title_warning'),
                    text: i18n.t('warning_select_record'),
                    confirmButtonText: '<i class="fa fa-check"></i> Ok',
                    confirmButtonClass: 'btn btn-circle btn-success',
                    buttonsStyling: false
                }).done();

                return false;
            }else if(grid.getSelectedRowsCount() > 1){
                swal({
                    title: i18n.t('swal_title_warning'),
                    text: i18n.t('warning_could_select_one'),
                    confirmButtonText: '<i class="fa fa-check"></i> Ok',
                    confirmButtonClass: 'btn btn-circle btn-success',
                    buttonsStyling: false
                }).done();

                return false;
            }
            App.blockUI({
                message: 'Loading...',
                target: grid.gettableContainer(),
                overlayColor: 'none',
                cenrerY: true,
                boxed: true
            });
            var $modal = $('#ajax-modal');
            $modal.load('/${tableField}Get/'+grid.getSelectedRows(), '', function(){
                $modal.modal();
                App.unblockUI(grid.gettableContainer());
            });
        });

        $('#${tableName?lower_case}_refresh_').click(function () {
            grid.getDataTable().ajax.reload();
        });

    };

    var refresh = function () {
        grid.getDataTable().ajax.reload();
    };

    return {

        //main function to initiate the module
        init: function () {
            handleRecords();
        },
        refresh: function () {
            refresh();
        }

    };

}();

jQuery(document).ready(function() {
    ${tableField}Manager.init();

    $("#${tableName?lower_case}__find__").click(function(){
        $("#${tableName?lower_case}_filter").toggle(500);
    });

    $('.date-picker').datepicker({
        rtl: App.isRTL(),
        autoclose: true
    });
});
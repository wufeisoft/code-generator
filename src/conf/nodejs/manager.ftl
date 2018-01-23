<#assign tableName="${result.getTableName()}">
<#assign tableField="${result.getFirstCharacterUppercase(result.getTableName())}">
<#assign tableLowercaseField="${result.getFirstCharacterLowercase(result.getTableName())}">
<div class="row">
    <div class="col-md-12">
        <div class="portlet light portlet-fit portlet-datatable ">
            <div class="portlet-title">
                <div class="caption">
                    <i class="icon-settings font-dark"></i>
                    <span class="caption-subject font-dark sbold uppercase">{{ __('locales.txt.list.${tableLowercaseField}') }}</span>
                </div>
                <div class="actions">
                    <div class="btn-group btn-group-devided" data-toggle="buttons">

                        <button class="btn btn-outline btn-circle red btn-sm blue" data-toggle="modal"  id="${tableName?lower_case}__add__">
                            <i class="fa fa-plus"></i> {{ __('locales.btn.add') }}
                        </button>

                        <button class="btn btn-outline btn-circle green btn-sm purple" data-toggle="modal" id="${tableName?lower_case}_update_">
                            <i class="fa fa-edit"></i> {{ __('locales.btn.edit') }}
                        </button>

                        <a href="javascript:;" class="btn btn-outline btn-circle dark btn-sm black" id="${tableName?lower_case}__delete__">
                            <i class="fa fa-trash-o"></i>{{ __('locales.btn.delete') }}</a>
                        <button class="btn btn-outline btn-circle green btn-sm yellow" data-toggle="modal" id="${tableName?lower_case}_refresh_">
                            <i class="fa fa-refresh"></i> {{ __('locales.btn.refresh') }}
                        </button>
                        <a href="javascript:;" class="btn btn-outline btn-circle dark btn-sm blue" id="${tableName?lower_case}__find__">
                            <i class="fa fa-filter"></i>{{ __('locales.btn.filter') }}</a>
                    </div>
                </div>

            </div>

            <div class="filter search-filter" id="${tableName?lower_case}_filter">
<#foreach prop in result.getColumns()>
    <#if !prop.pKey>
        <#assign param="">
        <#assign required="">
                <div class="input-width">
                    <label class="col-md-4 control-label col-md-right">{{__('locales.placeholder.${result.getFirstCharacterLowercase(prop.columnName)}')}}</label>
                    <div class="col-md-8">
        <#if "DATE" == prop.jdbcTypeName || "TIME" == prop.jdbcTypeName || "TIMESTAMP" == prop.jdbcTypeName>
                        <div class="input-group date date-picker" data-date-format="yyyy-dd-mm">
                            <input type="text" class="form-control form-filter input-sm date-input date-input-width" readonly name="${result.getFirstCharacterLowercase(prop.columnName)}" placeholder="{{__('locales.placeholder.${result.getFirstCharacterLowercase(prop.columnName)}')}}">
                            <span class="input-group-btn input-group-btn-date">
                                        <button class="btn btn-sm default date-btn" type="button">
                                            <i class="fa fa-calendar"></i>
                                        </button>
                                    </span>
                        </div>
        <#elseif "java.lang.Long" == prop.columnType || "java.lang.Integer" == prop.columnType>
                        <input type="number" class="form-control form-filter input-sm" name="${result.getFirstCharacterLowercase(prop.columnName)}" placeholder="{{__('locales.placeholder.${result.getFirstCharacterLowercase(prop.columnName)}')}}"/>
        <#elseif "java.math.BigDecimal" == prop.columnType>
                        <input type="number" class="form-control form-filter input-sm" name="${result.getFirstCharacterLowercase(prop.columnName)}" placeholder="{{__('locales.placeholder.${result.getFirstCharacterLowercase(prop.columnName)}')}}"/>
            <#assign param=" data-options=\"precision:${prop.scale}\" ">
        <#else>
                        <input type="text" class="form-control form-filter input-sm" name="${result.getFirstCharacterLowercase(prop.columnName)}" placeholder="{{__('locales.placeholder.${result.getFirstCharacterLowercase(prop.columnName)}')}}"/>
        </#if>
                    </div>
                </div>
    </#if>
</#foreach>
                <div class="margin-bottom-5 subbtn">
                    <button class="btn btn-sm green btn-outline filter-submit margin-bottom">
                        <i class="fa fa-search"></i>{{ __('locales.btn.search') }}
                    </button>
                    <button class="btn btn-sm red btn-outline filter-cancel">
                        <i class="fa fa-times"></i>{{ __('locales.btn.reset') }}
                    </button>
                </div>
            </div>

            <div class="portlet-body">
                <div class="table-container">
                    <table class="table table-striped table-bordered table-hover table-checkable order-column nowrap" id="${tableName?lower_case}_tb_container">
                        <thead>
                        <tr>
                            <th class="table-checkbox">
                                <label class="mt-checkbox mt-checkbox-single mt-checkbox-outline">
                                    <input type="checkbox" id="${tableName?lower_case}_chk_all" class="group-checkable" />
                                    <span></span>
                                </label>
                            </th>
                    <#foreach prop in result.getColumns()>
                        <#if !prop.pKey>
                            <th> {{__('locales.th.${result.getFirstCharacterLowercase(prop.columnName)}')}} </th>
                        </#if>
                    </#foreach>
                        </tr>
                        </thead>
                        <tbody>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="{{ jsPath }}/pages/scripts/${tableField}Manager.js" type="text/javascript"></script>
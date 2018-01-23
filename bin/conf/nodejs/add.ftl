<#assign tableName="${result.getTableName()}">
<#assign tableField="${result.getFirstCharacterUppercase(result.getTableName())}">
<#assign tableLowercaseField="${result.getFirstCharacterLowercase(result.getTableName())}">
<div class="modal-header" style="background:#32c5d2;color:#fff;">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true"></button>
    <h4 class="modal-title">{{ __('locales.txt.add') }}</h4>
</div>

<div class="portlet light portlet-fit portlet-form " style="padding:0!important; margin-bottom:0!important;">
    <form class="form-horizontal" id="${tableName?lower_case}_add_form" novalidate="novalidate">
    <div class="portlet-body modal-body">
        <div class="form-body" style="padding: 0!important;">
            <div class="alert alert-danger display-hide">
                <button class="close" data-close="alert"></button>{{ __('locales.check.below') }}
            </div>
            <div class="alert alert-success display-hide">
                <button class="close" data-close="alert"></button>{{ __('locales.check.successful') }}
            </div>

            <div class="form-group form-md-line-input">
    <#foreach prop in result.getColumns()>
        <#if !prop.pKey>
            <#assign type="">
            <#assign param="${prop.remarks}">
            <#assign required="">
            <#if "DATE" == prop.jdbcTypeName || "TIME" == prop.jdbcTypeName || "TIMESTAMP" == prop.jdbcTypeName>
                <div class="add-up-div">
                    <label class="col-md-3 control-label">{{ __('locales.txt.${result.getFirstCharacterLowercase(prop.columnName)}') }}
                        <#if !prop.nullable>
                            <span class="required">*</span>
                        </#if>
                    </label>
                    <div class="col-md-9" style="width:50%;">
                        <div class="input-group input-medium date form_datetime" data-date-format="yyyy-mm-dd hh:ii:ss">
                            <input type="text" name="${result.getFirstCharacterLowercase(prop.columnName)}" class="form-control add-update-date-input cursor-input" readonly>
                            <span class="input-group-btn" style="display: inherit;">
                        <button class="btn default date-set" type="button">
                            <i class="fa fa-calendar"></i>
                        </button>
                    </span>
                        </div>
                    </div>
                </div>
            <#else>
                <div class="add-up-div">
                    <label class="col-md-3 control-label">{{ __('locales.txt.${result.getFirstCharacterLowercase(prop.columnName)}') }}
                        <#if !prop.nullable>
                            <span class="required">*</span>
                        </#if>
                    </label>
                    <div class="col-md-9">
                        <input type="text" class="form-control" placeholder="" name="${result.getFirstCharacterLowercase(prop.columnName)}">
                        <div class="form-control-focus"> </div>
                        <#if !prop.nullable>
                            <span class="help-block">{{ __('locales.check.${result.getFirstCharacterLowercase(prop.columnName)}') }}</span>
                        </#if>
                    </div>
                </div>
            </#if>
        </#if>
    </#foreach>
        </div>
        </div>
    </div>
    <div class="modal-footer" style="background: #fff;">
        <div class="row">
            <div class="col-md-offset-3 col-md-9 submit-btn">
                <button type="submit" class="btn green"><i class="fa fa-check"/>{{ __('locales.btn.add') }}</button>
                <button type="reset" class="btn default"><i class="fa fa-close"/>{{ __('locales.btn.reset') }}</button>
            </div>
        </div>
    </div>
    </form>
</div>

<script type="text/javascript">
    $(function(){
        $('.form_datetime').datetimepicker({
            rtl: App.isRTL(),
            autoclose: true
        });
        $('.form_datetime').datetimepicker("setDate", new Date());
    });
</script>

<script src="{{ jsPath }}/pages/scripts/${tableField}Add.js" type="text/javascript"></script>
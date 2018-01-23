package org.code.generator.config;

import static org.code.generator.util.StringUtility.stringHasValue;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.Properties;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.code.generator.db.*;
import org.code.generator.db.types.*;
import org.code.generator.dom.Attribute;
import org.code.generator.dom.XmlElement;
import org.code.generator.freemarker.FreeMarkerHanlder;
import org.code.generator.util.StringUtility;

import com.shangkang.tools.UtilHelper;

import freemarker.template.SimpleDate;
import freemarker.template.TemplateDateModel;

public class Context extends PropertyHolder {
    private String id;

    private JDBCConnectionConfiguration jdbcConnectionConfiguration;

    private JavaTypeResolverConfiguration javaTypeResolverConfiguration;
    
    private TableConfiguration tableConfiguration;
    
    private List<PluginConfiguration> pluginConfigurations;
    
    private List<CommonPluginConfiguration> commonPluginConfigurations;

    private String targetRuntime;
    
    private Logger logger = Logger.getLogger(getClass().getName());

    /**
     * Constructs a Context object.
     * 
     */
    public Context() {
        super();
        
        commonPluginConfigurations = new ArrayList<CommonPluginConfiguration>();
        pluginConfigurations = new ArrayList<PluginConfiguration>();
    }

    public TableConfiguration getTableConfiguration()
	{
		return tableConfiguration;
	}

	public void setTableConfiguration(TableConfiguration tableConfiguration)
	{
		this.tableConfiguration = tableConfiguration;
	}


	public JDBCConnectionConfiguration getJdbcConnectionConfiguration() {
        return jdbcConnectionConfiguration;
    }

    public JavaTypeResolverConfiguration getJavaTypeResolverConfiguration()
	{
		return javaTypeResolverConfiguration;
	}

	public void setJavaTypeResolverConfiguration(
			JavaTypeResolverConfiguration javaTypeResolverConfiguration)
	{
		this.javaTypeResolverConfiguration = javaTypeResolverConfiguration;
	}

	public List<PluginConfiguration> getPluginConfigurations()
	{
		return pluginConfigurations;
	}

	public void setPluginConfigurations(
			List<PluginConfiguration> pluginConfigurations)
	{
		this.pluginConfigurations = pluginConfigurations;
	}
	
	/**
	 * @return the commonPluginConfigurations
	 */
	public List<CommonPluginConfiguration> getCommonPluginConfigurations()
	{
		return commonPluginConfigurations;
	}

	/**
	 * @param commonPluginConfigurations the commonPluginConfigurations to set
	 */
	public void setCommonPluginConfigurations(
			List<CommonPluginConfiguration> commonPluginConfigurations)
	{
		this.commonPluginConfigurations = commonPluginConfigurations;
	}

	public void addPluginConfiguration(
			PluginConfiguration pluginConfiguration) {
		pluginConfigurations.add(pluginConfiguration);
    }
	
	public void addCommonPluginConfiguration(
			CommonPluginConfiguration pluginConfiguration) {
		commonPluginConfigurations.add(pluginConfiguration);
    }

	/**
     * This method does a simple validate, it makes sure that all required
     * fields have been filled in. It does not do any more complex operations
     * such as validating that database tables exist or validating that named
     * columns exist
     */
    public void validate(List<String> errors) {
        if (!stringHasValue(id)) {
            errors.add("ValidationError.16"); //$NON-NLS-1$
        }

        if (jdbcConnectionConfiguration == null) {
            errors.add("ValidationError.10"); //$NON-NLS-1$
        } 

        if (tableConfiguration == null) {
            errors.add("ValidationError.3"); //$NON-NLS-1$
        }

        if(UtilHelper.isEmpty(pluginConfigurations))
        {
        	errors.add("Plugin Configurations is null.");
        }

    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setJdbcConnectionConfiguration(
            JDBCConnectionConfiguration jdbcConnectionConfiguration) {
        this.jdbcConnectionConfiguration = jdbcConnectionConfiguration;
    }

    /**
     * Builds an XmlElement representation of this context. Note that the XML
     * may not necessarily validate if the context is invalid. Call the
     * <code>validate</code> method to check validity of this context.
     * 
     * @return the XML representation of this context
     */
    public XmlElement toXmlElement() {
        XmlElement xmlElement = new XmlElement("context"); //$NON-NLS-1$

        if (stringHasValue(targetRuntime)) {
            xmlElement.addAttribute(new Attribute(
                    "targetRuntime", targetRuntime)); //$NON-NLS-1$
        }

        addPropertyXmlElements(xmlElement);

        if (jdbcConnectionConfiguration != null) {
            xmlElement.addElement(jdbcConnectionConfiguration.toXmlElement());
        }

        if (tableConfiguration != null) {
            xmlElement.addElement(tableConfiguration.toXmlElement());
        }

        if (javaTypeResolverConfiguration != null) {
            xmlElement.addElement(javaTypeResolverConfiguration.toXmlElement());
        }
        
        if(!UtilHelper.isEmpty(commonPluginConfigurations))
        {
        	for(CommonPluginConfiguration pluginConfiguration : commonPluginConfigurations)
        	{
        		xmlElement.addElement(pluginConfiguration.toXmlElement());
        	}
        }
        
        if(!UtilHelper.isEmpty(pluginConfigurations))
        {
        	for(PluginConfiguration pluginConfiguration : pluginConfigurations)
        	{
        		xmlElement.addElement(pluginConfiguration.toXmlElement());
        	}
        }
        
        return xmlElement;
    }
    
    private Connection getConnection() throws SQLException {
        Connection connection = ConnectionFactory.getInstance().getConnection(
                jdbcConnectionConfiguration);

        return connection;
    }

    private void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                // ignore
                ;
            }
        }
    }
    
    private void closeResultSet(ResultSet resultSet) {
        if (resultSet != null) {
            try {
            	resultSet.close();
            } catch (SQLException e) {
                // ignore
                ;
            }
        }
    }
    
    public void execute() throws Exception
    {
    	Connection con = null;
    	DatabaseMetaData dbMeta = null;
    	
    	try{
	    	con = getConnection();
	    	
	    	dbMeta = con.getMetaData();  
	    	
	    	String tableTypes = tableConfiguration.getTableType();
	    	
	    	if(!stringHasValue(tableTypes))
	    		tableTypes = "TABLE";
	    	
	    	tableTypes.toUpperCase();
	    	
	    	String[] tablesType = null;
	    	
	    	if(!tableTypes.contains(","))
	    		tablesType = new String[]{tableTypes};
	    	else	
	    		tablesType = tableTypes.split(",");
	    	
	    	String schema = tableConfiguration.getSchema();
	    	
	    	if(stringHasValue(schema))
	    		schema = schema.toUpperCase();
	    	
	    	List<Table> tableList = new ArrayList<Table>();
	    	
	    	if(tableConfiguration.isAllTable())//所有表或对象
	    	{
	    		doGetTablesInfor(dbMeta, tablesType, schema, null, tableList);
	    	}else
	    	{
	    		String tablesName = tableConfiguration.getTablesName();
	    		String[] tableArray = null;
	    		
	    		if(stringHasValue(tablesName))
	    		{
	    			if(tablesName.contains(","))
	    			{
	    				tableArray = tablesName.split(",");
	    			}else
	    			{
	    				tableArray = new String[]{tablesName};
	    			}
	    			
	    			for(String tableNm : tableArray)
	    			{
	    				doGetTablesInfor(dbMeta, tablesType, schema, tableNm.toUpperCase(), tableList);
	    			}
	    		}
	    	}
	    	
	    	if(!UtilHelper.isEmpty(commonPluginConfigurations) && !UtilHelper.isEmpty(tableList))
			{
				for(CommonPluginConfiguration commonPluginConfiguration : commonPluginConfigurations)
				{
					String templatePath = commonPluginConfiguration.getTemplatePath(); 
			        String templateName = commonPluginConfiguration.getTemplateName();
			        String targetPackage = commonPluginConfiguration.getTargetPackage();
			        
			        FreeMarkerHanlder fmHanlder = new FreeMarkerHanlder(templatePath, templateName);
			        
			        fmHanlder.initTemplate();
			        
			        fmHanlder.initContext();

			        fmHanlder.getContext().put("date",
							new SimpleDate(new Date(), TemplateDateModel.DATETIME));
			        fmHanlder.getContext().put("user", "wufei");
			        fmHanlder.getContext().put("package", targetPackage);
			        fmHanlder.getContext().put("result", tableList);
			        
			        Properties properties = commonPluginConfiguration.getProperties();
			        
			        if (properties != null && !properties.isEmpty())
					{
						for (@SuppressWarnings("rawtypes")
						Enumeration e = properties.propertyNames(); e.hasMoreElements();)
						{
							String key = (String) e.nextElement();

							fmHanlder.getContext().put(key, properties.getProperty(key));
						}
					}
			        
			        this.generateFile(fmHanlder, commonPluginConfiguration, targetPackage, "struts");
				}
			}
	    	
    	}finally
    	{
    		closeConnection(con);
    	}
    	
    }

	/**
	 * @param dbMeta
	 * @param tablesType
	 * @param schema
	 * @param tableNm
	 * @throws SQLException
	 * @throws ClassNotFoundException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	private void doGetTablesInfor(DatabaseMetaData dbMeta, String[] tablesType,
			String schema, String tableNm, List<Table> tableList)
			throws Exception
	{
		ResultSet tables = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		
		try
		{
			tables = dbMeta.getTables(null, schema, tableNm, tablesType);
			
			ColumnTypeResolver typeResolver = null;
			
			String typeResolverImpl = javaTypeResolverConfiguration.getTypeResolverImpl();
			
			if(StringUtility.stringHasValue(typeResolverImpl))
			{
				typeResolver = (ColumnTypeResolver) ObjectFactory.externalClassForName(typeResolverImpl).newInstance();
			}
			else
				typeResolver = new JavaTypeResolver();

			ITableInfo iTableInfo = TableInfoFactory.getITableInfo(jdbcConnectionConfiguration.getDriverClass());
			DefaultValueTranslatorFactory.initIDefaultValueTranslator(jdbcConnectionConfiguration.getDriverClass());

			while(tables.next())
			{
				Table table = new Table();
				
				String tableName = iTableInfo.getTableName(tables);
				//去除系统表，暂时处理方法
				if(tableName.contains("$"))
					continue;
				
				if(StringUtility.stringHasValue(tableConfiguration.getTablePrefix()))
					table.setTableName(tableName.replaceFirst(tableConfiguration.getTablePrefix(), ""));
				else
					table.setTableName(tableName);
				
				table.setTablePrefix(tableConfiguration.getTablePrefix());
				
				table.setTableRemarks(iTableInfo.getTableRemarks(tables));
				
				tableList.add(table);
				
				rs = dbMeta.getPrimaryKeys(null, schema, tableName.toUpperCase()); //主键
				
				while(rs.next())  
			    {  
					TableColumn tableColumn = new TableColumn();
					
					tableColumn.setColumnName(iTableInfo.getColumnName(rs));
					tableColumn.setpKey(true);
					
					table.getKeyColumns().add(tableColumn);
			    } 
				
				rs2 = dbMeta.getColumns(null, schema, tableName.toUpperCase(), null); 
				
				while(rs2.next())  
			    {  
					String colName = iTableInfo.getColumnName(rs2);
					TableColumn tableColumn = new TableColumn();
					
					List<TableColumn> keyColumns = table.getKeyColumns();
					
					for(TableColumn keyColumn : keyColumns)
					{
						if(keyColumn.getColumnName().equals(colName))
						{
							tableColumn.setpKey(true);
							break;
						}
					}
					
					tableColumn.setColumnName(colName);
					tableColumn.setJdbcType(iTableInfo.getJdbcType(rs2));
					tableColumn.setLength(iTableInfo.getLength(rs2));
					tableColumn.setScale(iTableInfo.getScale(rs2));
					tableColumn.setRemarks(iTableInfo.getRemarks(rs2));
					tableColumn.setDefaultValue(DefaultValueTranslatorFactory.getDefaultValue(tableColumn, iTableInfo.getDefaultValue(rs2)));
					tableColumn.setUserDefaultValue(DefaultValueTranslatorFactory.getDefaultValue(tableColumn, null));

					tableColumn.setColumnType(typeResolver.calculateJavaType(tableColumn));
					tableColumn.setJdbcTypeName(JdbcTypeNameTranslator.getJdbcTypeName(iTableInfo.getJdbcType(rs2)));
					
					tableColumn.setNullable(iTableInfo.getNullable(rs2));
					
					table.getColumns().add(tableColumn);
			    } 
				
				if(!UtilHelper.isEmpty(pluginConfigurations))
				{
					for(PluginConfiguration pluginConfiguration : pluginConfigurations)
					{
						String templatePath = pluginConfiguration.getTemplatePath(); 
				        String templateName = pluginConfiguration.getTemplateName();
				        String targetPackage = pluginConfiguration.getTargetPackage();

						Pattern pattern = Pattern.compile("#\\{(\\w+)\\}");
						Matcher matcher = pattern.matcher(targetPackage);

						while(matcher.find()){
							Field privateField = table.getClass().getDeclaredField(matcher.group(1));
							privateField.setAccessible(true);

							targetPackage = targetPackage.replace(matcher.group(), table.getFirstCharacterUppercase((String) privateField.get(table)));
						}

				        if(!StringUtility.stringHasValue(table.getKeyType()))
				        	throw new Exception(tableName + "主键(" + table.getKey() +")类型不存在。");
				        
				        if(pluginConfiguration.getJavaTypeResolverConfiguration() != null 
				        		&& StringUtility.stringHasValue(pluginConfiguration.getJavaTypeResolverConfiguration().getTypeResolverImpl()))
				        {
				        	ColumnTypeResolver columnTypeResolver = (ColumnTypeResolver) ObjectFactory.externalClassForName(
				        			pluginConfiguration.getJavaTypeResolverConfiguration().getTypeResolverImpl()).newInstance();
				        	
				        	for(TableColumn column : table.getColumns())
				        	{
				        		column.setColumnType(columnTypeResolver.calculateJavaType(column));
				        	}
				        }
				        
				        FreeMarkerHanlder fmHanlder = new FreeMarkerHanlder(templatePath, templateName);
				        
				        fmHanlder.initTemplate();
				        
				        fmHanlder.initContext();

				        fmHanlder.getContext().put("date",
								new SimpleDate(new Date(), TemplateDateModel.DATETIME));
				        fmHanlder.getContext().put("user", "wufei");
				        fmHanlder.getContext().put("package", targetPackage);
				        fmHanlder.getContext().put("result", table);
				        
				        Properties properties = pluginConfiguration.getProperties();
				        
				        if (properties != null && !properties.isEmpty())
						{
							for (@SuppressWarnings("rawtypes")
							Enumeration e = properties.propertyNames(); e.hasMoreElements();)
							{
								String key = (String) e.nextElement();

								fmHanlder.getContext().put(key, properties.getProperty(key));
							}
						}
				        
				        this.generateFile(fmHanlder, pluginConfiguration, targetPackage, table.getTableName());
					}
				}
		        
			}
			
		}finally
		{
			closeResultSet(rs);
			closeResultSet(rs2);
			closeResultSet(tables);
		}
	}
	
	private void generateFile(FreeMarkerHanlder fmHanlder, CommonPluginConfiguration pluginConfiguration, 
			String targetPackage, String tableName)
	{
		String fileSuffix = pluginConfiguration.getFileSuffix();
        String fileExtension = pluginConfiguration.getFileExtension();
        String fileTargetProject = pluginConfiguration.getFileTargetProject();
        boolean override = pluginConfiguration.isOverride();
        
		FileWriter fileWriter = null;
		String tempResult = fmHanlder.generateContext();
		StringBuffer destinationPath = new StringBuffer();
		StringBuffer destinationName = new StringBuffer();

		if (fileSuffix == null || ("").equals(fileSuffix.trim()))
		{
			fileSuffix = "";
		}

		destinationPath.append(fileTargetProject).append("/").append(
				targetPackage.replace(".", "/")).append("/");
		
		tableName = StringUtility.getCamelCaseString(tableName, true);
		
		destinationName.append(tableName).append(fileSuffix).append(".")
				.append(fileExtension);

		File file = new File(destinationPath.toString());
		String fileName = null;
		try
		{
			if (!file.exists())
				file.mkdirs();
			
			fileName = destinationPath.append(destinationName).toString();

			file = new File(fileName);

			if(file.exists() && !override)
				return;
			
			if (file.exists())
				file.delete();

			file.createNewFile();

			fileWriter = new FileWriter(file);
			fileWriter.write(tempResult);
			
			logger.info("已生成文件：" + fileName + "。");
			
		} catch (IOException e)
		{
			logger.warning("IOException :" + fileName);
			e.printStackTrace();
		} finally
		{
			if (fileWriter != null)
			{
				try
				{
					fileWriter.flush();
					fileWriter.close();
				} catch (IOException e)
				{
					e.printStackTrace();
				}
			}

			file = null;
		}
	}

    @Override
    public void addProperty(String name, String value) {
        super.addProperty(name, value);
    }

    public String getTargetRuntime() {
        return targetRuntime;
    }

    public void setTargetRuntime(String targetRuntime) {
        this.targetRuntime = targetRuntime;
    }

	public static void main(String strs[]){

		String s = "wrwr.#{12qwe" +
				"qe}wrwrwrw#{dsfsf}er";

		Pattern p = Pattern.compile("#\\{(\\w+)\\}");
		Matcher m = p.matcher(s);

		System.out.println(s.replaceAll("\\s*|\t|\r|\n", ""));

		while(m.find()){
			System.out.println(s = s.replace(m.group(), m.group(1)));
		}
	}
}

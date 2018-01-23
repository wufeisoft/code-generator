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
package ${package};

<#assign tableField="${result.getFirstCharacterUppercase(result.getTableName())}">
<#assign tableLowercaseField="${result.getFirstCharacterLowercase(result.getTableName())}">
import java.util.List;
import java.util.Map;

import ${boPackage}.${tableField};
import com.shangkang.core.mapper.GenericIBatisMapper;
import com.shangkang.core.bo.Pagination;
import com.shangkang.core.exception.DataAccessFailureException;
import org.apache.ibatis.annotations.Param;

public interface ${tableField}Mapper extends GenericIBatisMapper<${tableField}, ${result.getKeyType()}> {

    public List<${tableField}> listPaginationByProperty(Pagination<${tableField}> pagination, @Param("${tableLowercaseField}")${tableField} ${tableLowercaseField}, @Param("orderBy") Map<String, String> orderBy) throws DataAccessFailureException;
}

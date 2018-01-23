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
import Request from '../helper/index'
import config from '../config'

const BASE_URL = config.baseUrl;
const ${tableName} = {};

${tableName}.listPg = async function (authorization, params) {
    return await  Request.request(BASE_URL + '${tableLowercaseField}/listPg', Request.method.POST, authorization, params);
};

${tableName}.delete${tableField} = async function (auth, params) {
    return await Request.request(BASE_URL + '${tableLowercaseField}/delete', Request.method.POST, auth, params);
};

${tableName}.add${tableField} = async function (auth, params) {
    return await Request.request(BASE_URL + '${tableLowercaseField}/add', Request.method.POST, auth, params);
};

${tableName}.get${tableField} = async function (auth, params) {
    return await Request.request(BASE_URL + '${tableLowercaseField}/getByPK?key='+params, Request.method.GET, auth);
};

${tableName}.update${tableField} = async function (auth, params) {
    return await Request.request(BASE_URL + '${tableLowercaseField}/update', Request.method.PUT, auth, params);
};

export default ${tableName};
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
import Router from 'koa-router'
import Api from '../models/${tableField}'

const ${tableField} = new Router();

${tableField}.get('/${tableField}Manager', async ctx => {
    await ctx.render('${tableField}Manager');
});

${tableField}.post('/${tableField}List', async ctx => {
    let list = await Api.listPg(ctx.cookies.get('token'), ctx.request.body);

    ctx.body = list;
});

${tableField}.post('/${tableField}Delete', async ctx => {
    let result = await Api.delete${tableField}(ctx.cookies.get('token'), ctx.request.body.params);
    ctx.body = result;
});

${tableField}.post('/${tableField}Add', async ctx => {
    let result = await Api.add${tableField}(ctx.cookies.get('token'), ctx.request.body);
    ctx.body = result;
});

${tableField}.get('/${tableField}Get/:key', async ctx => {
    let result = await Api.get${tableField}(ctx.cookies.get('token'), ctx.params.key);
    await ctx.render('${tableField}Edit',{result:result});
});

${tableField}.post('/${tableField}Edit', async ctx => {
    let result = await Api.update${tableField}(ctx.cookies.get('token'), ctx.request.body);
    ctx.body = result;
});

${tableField}.get('/${tableField}AddView', async ctx => {
    await ctx.render('${tableField}Add');
});

${tableField}.get('/${tableField}EditView', async ctx => {
    await ctx.render('${tableField}Edit');
});

module.exports = ${tableField};
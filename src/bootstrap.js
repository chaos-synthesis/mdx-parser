var MdxStatement = require('./ts/MdxStatement').MdxStatement;

var mdx = 'SELECT ' +
    '{ [Measures].[Store Sales] } ON COLUMNS, ' +
    '{ [Date].[2002], [Date].[2003] } ON ROWS ' +
    'FROM Sales ' +
    'WHERE ( [Store].[USA].[CA] )';

var mdxStm = MdxStatement.parse(mdx);
//var res = JSON.stringify(App.parse(mdx));
//console.log(res);
//
//document.getElementById('main').innerText = res;


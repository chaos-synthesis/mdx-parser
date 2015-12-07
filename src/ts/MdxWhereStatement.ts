import stm = require('./MdxStatement');

export default class MdxWhereStatement implements stm.MdxParseable {

    parse(mdx:string):MdxWhereStatement {
        return new MdxWhereStatement();
    }

    mdx():string {
        return '';
    }
}

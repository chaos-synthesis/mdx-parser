import stm = require('./MdxStatement');

export default class MdxFromStatement implements stm.MdxParseable {

    parse(mdx:string):MdxFromStatement {
        return new MdxFromStatement();
    }

    mdx():string {
        return '';
    }
}

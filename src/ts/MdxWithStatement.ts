import stm = require('./MdxStatement');

export default class MdxWithStatement implements stm.MdxParseable {

    parse(mdx:string):MdxWithStatement {
        return new MdxWithStatement();
    }

    mdx():string {
        return '';
    }
}

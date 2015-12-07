declare var require;
var parser = require('../parsers/axis');
import stm = require('./MdxStatement');

export default class MdxEntity implements stm.MdxParseable {

    static parse(mdx:string):MdxEntity {
        return parser.parse(mdx);
    }

    mdx():string {
        return '';
    }
}

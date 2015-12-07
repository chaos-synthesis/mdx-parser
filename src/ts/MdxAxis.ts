declare var require;
var parser = require('../parsers/axis');
import stm = require('./MdxStatement');



export default class MdxAxis implements stm.MdxParseable {


    static parse(mdx:string): MdxAxis {
        var axes = parser.parse(mdx);
        axes.forEach((axis) => {
            axis
        });
    }

    mdx():string {
        return '';
    }
}

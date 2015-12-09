declare var require;
var parser = require('../parsers/statement');

import MdxWithStatement from './MdxWithStatement';
import MdxAxisSpec from './MdxAxisSpec';
import MdxFromStatement from './MdxFromStatement';
import MdxWhereStatement from './MdxWhereStatement';

export declare class MdxParseable {
    static parse(mdx: string): MdxParseable;
    mdx(): string;
}

export class MdxStatement implements MdxParseable {
    withStatement: MdxWithStatement;
    axes: MdxAxisSpec[];
    fromStatement: MdxFromStatement;
    havingStatement: any;
    whereStatement: MdxWhereStatement;

    static parse(mdx:string):MdxStatement {
        var parseResult = parser.parse(mdx);
        var axis = MdxAxisSpec.parse(parseResult[0].axis);
        console.log(JSON.stringify(axis));
        return new MdxStatement();
    }

    mdx():string {
        return '';
    }
}

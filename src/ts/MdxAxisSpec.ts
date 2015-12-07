declare var require;
var parser = require('../parsers/axis');
import stm = require('./MdxStatement');
import MdxEntity from './MdxEntity';

export enum MdxAxisType {
    ROWS, COLUMNS
}

export default class MdxAxisSpec implements stm.MdxParseable {
    type: MdxAxisType;
    entites: MdxEntity[];

    static parse(mdx:string): MdxAxisSpec[] {
        var axis = parser.parse(mdx);
        axis.forEach((ax) => {
            const entities = MdxEntity.parse(ax.entites);
        });

        return axis;
    }

    mdx():string {
        return '';
    }
}

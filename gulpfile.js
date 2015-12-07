'use strict';

var gulp        = require('gulp'),
    gutil       = require('gulp-util'),
    tsify       = require('tsify'),
    browserify  = require('browserify'),
    source      = require('vinyl-source-stream'),
    sourcemaps  = require('gulp-sourcemaps'),
    del         = require('del'),
    tsd         = require('gulp-tsd'),
    to5ify      = require('6to5ify'),
    uglify      = require('gulp-uglify'),
    buffer      = require('vinyl-buffer'),
    jison       = require('gulp-jison'),
    foreach     = require('gulp-foreach'),
    path        = require('path');


gulp.task('tsd', function (callback) {
    tsd({
        command: 'reinstall',
        config: './tsd.json'
    }, callback);
});

gulp.task('through', function () {
    return gulp
        .src(['src/index.html'])
        .pipe(gulp.dest('dist' ) );
});


gulp.task('jison', function () {
    return gulp.src('./src/parsers/*.jison')
        .pipe(foreach(function(stream, file){
            return stream
                .pipe(jison({ moduleType: 'commonjs', moduleName: path.parse(file.path).name+'Parser' }));
        }))
        //.pipe(jison({ moduleType: 'commonjs', moduleName: 'mdxparsers' }))
        .pipe(gulp.dest('./src/parsers/'));
});

gulp.task('bundle', ['through'], function () {

    browserify({
        entries: 'src/bootstrap.js',
        extensions: ['.ts', '.js'],
        debug: true
    })
        .plugin(tsify, {"module": "commonjs",
            "target": "ES5",
            "noImplicitAny": false,
            "experimentalDecorators": true,
            "removeComments": true
        })
        //.transform(to5ify)
        .bundle()
        .on('error', gutil.log.bind(gutil, 'Browserify Error'))
        .pipe(source('bundle.js'))
        .pipe(buffer())
        .pipe(sourcemaps.init({loadMaps: true})) // loads map from browserify file
        //.pipe(uglify())
        .pipe(sourcemaps.write('./'), {includeContent: false, sourceRoot: '/dist'}) // writes .map file
        .pipe(gulp.dest('dist'));

    //var b = browserify('.tmp/bootstrap.js');
    //return b.bundle()
    //    .pipe(source('bundle.js'))
    //    .pipe(gulp.dest('dist'));
});

gulp.task('clean', function (done) {
    del(['.tmp'], done.bind(this));
});

gulp.task('watch', function () {
    gulp.watch('src/**/*.ts', ['compile']);
});

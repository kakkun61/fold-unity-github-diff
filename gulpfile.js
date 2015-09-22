'use strict';

var gulp = require('gulp');
var purescript = require('gulp-purescript');

var sources = [
  'src/**/*.purs',
  'bower_components/purescript-*/src/**/*.purs',
];

var foreigns = [
  'src/**/*.js',
  'bower_components/purescript-*/src/**/*.js'
];

gulp.task('make', function () {
  return purescript.psc({ src: sources, ffi: foreigns });
});

gulp.task('bundle', ['make'], function () {
  return purescript.pscBundle({
      src: 'output/**/*.js',
      output: 'dist/script.js',
      module: 'Main',
      main: 'Main'
  });
});

gulp.task('chrome', function () {
  return gulp.src('src/manifest.json')
             .pipe(gulp.dest('dist'));
});

gulp.task('dotpsci', function () {
  return purescript.psci({ src: sources, ffi: foreigns })
    .pipe(gulp.dest('.'));
});

gulp.task('default', ['bundle', 'chrome', 'dotpsci']);

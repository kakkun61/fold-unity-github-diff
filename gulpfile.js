'use strict';

var gulp = require('gulp');
var purescript = require('gulp-purescript');
var newer = require('gulp-newer')

var sources = [
  'src/**/*.purs',
  'bower_components/purescript-*/src/**/*.purs',
];

var foreigns = [
  'src/**/*.js',
  'bower_components/purescript-*/src/**/*.js'
];

var destination = 'dest';

gulp.task('make', function () {
  return purescript.psc({ src: sources, ffi: foreigns });
});

gulp.task('bundle', ['make'], function () {
  return purescript.pscBundle({
      src: 'output/**/*.js',
      output: destination + '/script.js',
      module: 'Main',
      main: 'Main'
  });
});

gulp.task('chrome', function () {
  return gulp.src(['src/manifest.json', 'src/**/*.html'])
             .pipe(newer(destination))
             .pipe(gulp.dest(destination));
});

gulp.task('dotpsci', function () {
  return purescript.psci({ src: sources, ffi: foreigns })
    .pipe(gulp.dest('.'));
});

gulp.task('default', ['bundle', 'chrome', 'dotpsci']);

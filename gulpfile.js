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

gulp.task('bundleContentScripts', ['make'], function () {
  return purescript.pscBundle({
      src: 'output/**/*.js',
      output: destination + '/content_scripts.js',
      module: 'DiffFolder.ContentScripts',
      main: 'DiffFolder.ContentScripts'
  });
});

gulp.task('bundleOptions', ['make'], function () {
  return purescript.pscBundle({
      src: 'output/**/*.js',
      output: destination + '/options.js',
      module: 'DiffFolder.Options'
  });
});

gulp.task('bundle', ['bundleContentScripts', 'bundleOptions']);

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

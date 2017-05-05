'use strict';

const gulp = require('gulp');
const config = require('./package.json').config;
const plugins = require('gulp-load-plugins')();

let templatesOnly = true;

gulp.task('sass:app', () => {
  return gulp.src(config.sass.source.app)
    .pipe(plugins.sass(config.sass.options.app).on('error', plugins.sass.logError))
    .pipe(gulp.dest(config.sass.output.dir))
    .pipe(plugins.livereload());
});

gulp.task('sass:vendor', () => {
  templatesOnly = false;
  return gulp.src(config.sass.source.vendor)
    .pipe(plugins.sass(config.sass.options.vendor).on('error', plugins.sass.logError))
    .pipe(plugins.autoprefixer({
      browsers: ['last 3 versions']
    }))
    .pipe(gulp.dest(config.sass.output.dir))
    .pipe(plugins.livereload());
});

gulp.task('fonts', () => {
  return gulp.src(config.fonts.source)
    .pipe(gulp.dest(config.fonts.output.dir));
});

gulp.task('images', () => {
  return gulp.src(config.images.source)
    .pipe(plugins.imagemin())
    .pipe(gulp.dest(config.images.output.dir));
});

gulp.task('templates', () => {
    let source = gulp.src(config.templates.source)
        .pipe(gulp.dest(config.templates.output.dir));

    if (templatesOnly === true) {
      source.pipe(plugins.livereload());
    } else {
      templatesOnly = true;
    }

    return source;
});

gulp.task('templates:noop', () => {
    return gulp.src(config.templates.source)
        .pipe(gulp.dest(config.templates.output.dir));
});

gulp.task('clean', () => {
  return gulp.src(config.clean)
    .pipe(plugins.clean({force: true}));
});

gulp.task('watch', (callback) => {
  plugins.livereload.listen();

  gulp.watch(config.sass.watch.app, ['sass:app', 'templates:noop']);
  gulp.watch(config.sass.watch.vendor, ['sass:vendor', 'templates:noop']);
  gulp.watch(config.images.source, ['images']);
  gulp.watch(config.templates.watch, ['templates']);
  gulp.watch('./web/app/*', ['templates']);
});

gulp.task('default', (callback) => {
  plugins.runSequence('images', 'templates', callback);
});

gulp.task('build', (callback) => {
  plugins.runSequence(['sass:app', 'sass:vendor'], 'fonts', 'images', 'templates', callback);
});

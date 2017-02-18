'use strict';

const gulp = require('gulp');
const config = require('./package.json').config;
const plugins = require('gulp-load-plugins')();
const browserify = require('browserify');
const babelify = require('babelify');
const watchify = require('watchify');
const buffer = require('vinyl-buffer');
const source = require('vinyl-source-stream');

const bundler = watchify(browserify('./src/js/app.js').transform(babelify, {presets: ['es2015']}));

function bundle() {
  return bundler.bundle()
    .on('error', plugins.util.log)
    .pipe(source('app.js'))
    .pipe(buffer())
    .pipe(gulp.dest('./web/dist/'))
    .pipe(plugins.livereload());
}

gulp.task('js:build', function () {
  const bundler = browserify('./src/js/app.js').transform(babelify, {presets: ['es2015']});

  return bundler.bundle()
    .on('error', plugins.util.log)
    .pipe(source('app.js'))
    .pipe(buffer())
    .pipe(plugins.uglify())
    .pipe(gulp.dest('./web/dist/'));
});

gulp.task('js', () => {
  bundle();
  bundler.on('update', bundle);
  bundler.on('log', plugins.util.log);
});

gulp.task('sass:app', () => {
  return gulp.src(config.sass.source.app)
    .pipe(plugins.sass(config.sass.options.app).on('error', plugins.sass.logError))
    .pipe(gulp.dest(config.sass.output.dir))
    .pipe(plugins.livereload());
});

gulp.task('sass:vendor', () => {
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
    return gulp.src(config.templates.source)
        .pipe(gulp.dest(config.templates.output.dir))
        .pipe(plugins.livereload());
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

  bundle();
  gulp.watch(config.js.watch, bundle);
  gulp.watch(config.sass.watch.app, ['sass:app', 'templates:noop']);
  gulp.watch(config.sass.watch.vendor, ['sass:vendor', 'templates:noop']);
  gulp.watch(config.templates.watch, ['templates']);
  gulp.watch(config.images.source, ['images']);
});

gulp.task('default', (callback) => {
  plugins.runSequence(['js', 'sass:app'], 'images', 'templates', callback);
});

gulp.task('build', (callback) => {
  plugins.runSequence(['js:build'], ['sass:app', 'sass:vendor'], 'fonts', 'images', 'templates', callback);
});

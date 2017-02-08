'use strict';

const gulp = require('gulp');
const config = require('./package.json').config;
const plugins = require('gulp-load-plugins')();

gulp.task('js:app', () => {
  return gulp.src(config.js.source.app)
    .pipe(plugins.concat(config.js.output.app))
    // .pipe(plugins.rev())
    // .pipe(gulp.dest(config.js.output.dir)) 
    // .pipe(plugins.rev.manifest(config.rev.manifest, config.rev.options))
    .pipe(gulp.dest(config.js.output.dir))
    .pipe(plugins.livereload());
});

gulp.task('js:vendor', () => {
  return gulp.src(config.js.source.vendor)
    .pipe(plugins.concat(config.js.output.vendor))
    .pipe(plugins.minify({mangle: true, ext: {src: '.debug.js', min: '.js'}}))
    // .pipe(plugins.rev()) 
    // .pipe(gulp.dest(config.js.output.dir)) 
    // .pipe(plugins.rev.manifest(config.rev.manifest, config.rev.options))
    .pipe(gulp.dest(config.js.output.dir))
    .pipe(plugins.livereload());
});

gulp.task('sass:app', () => {
  return gulp.src(config.sass.source.app)
    .pipe(plugins.sass(config.sass.options.app).on('error', plugins.sass.logError))
    // .pipe(plugins.rev())
    // .pipe(gulp.dest(config.sass.output.dir))
    // .pipe(plugins.rev.manifest(config.rev.manifest, config.rev.options))
    .pipe(gulp.dest(config.sass.output.dir))
    .pipe(plugins.livereload());
});

gulp.task('sass:vendor', () => {
  return gulp.src(config.sass.source.vendor)
    .pipe(plugins.sass(config.sass.options.vendor).on('error', plugins.sass.logError))
    .pipe(plugins.autoprefixer({
      browsers: ['last 3 versions']
    }))
    // .pipe(plugins.rev()) 
    // .pipe(gulp.dest(config.sass.output.dir))
    // .pipe(plugins.rev.manifest(config.rev.manifest, config.rev.options))
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
    // const revs = require(config.rev.manifest); 

    // console.log(revs);
    return gulp.src(config.templates.source)
        // .pipe(plugins.injectString.replace('@inject:' + config.js.output.vendor, revs[config.js.output.vendor]))
        // .pipe(plugins.injectString.replace('@inject:' + config.js.output.app, revs[config.js.output.app]))
        // .pipe(plugins.injectString.replace('@inject:' + config.sass.output.vendor, revs[config.sass.output.vendor]))
        // .pipe(plugins.injectString.replace('@inject:' + config.sass.output.app, revs[config.sass.output.app]))
        .pipe(gulp.dest(config.templates.output.dir))
        .pipe(plugins.livereload());
});

gulp.task('clean', () => {
  return gulp.src(config.clean)
    .pipe(plugins.clean({force: true}));
});

gulp.task('watch', (callback) => {
  plugins.livereload.listen();

  gulp.watch(config.js.watch, ['js:app', 'templates']);
  gulp.watch(config.sass.watch, ['sass:app', 'templates']);
  gulp.watch(config.templates.watch, ['templates']);
  gulp.watch(config.images.source, ['images']);
});

gulp.task('default', (callback) => {
  plugins.runSequence(['js:app', 'sass:app'], 'images', 'templates', callback);
});

gulp.task('build', (callback) => {
  plugins.runSequence(['js:app', 'js:vendor'], ['sass:app', 'sass:vendor'], 'fonts', 'images', 'templates', callback);
});

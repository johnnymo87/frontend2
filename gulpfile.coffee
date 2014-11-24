"use strict"
gulp = require("gulp")
del = require("del")
path = require("path")

# Load plugins
$ = require("gulp-load-plugins")()
browserify = require("gulp-browserify")
rename = require("gulp-rename")
source = require("vinyl-source-stream")

# Styles
gulp.task "styles", ->
  gulp.src("app/styles/main.scss").pipe($.rubySass(
    style: "expanded"
    precision: 10
    loadPath: ["app/bower_components"]
  )).pipe($.autoprefixer("last 1 version")).pipe(gulp.dest("dist/styles")).pipe $.size()


# CoffeeScript
gulp.task "coffee", ->
  gulp.src([
    "app/scripts/**/*.coffee"
    "!app/scripts/**/*.js"
  ],
    base: "app/scripts"
  ).pipe($.coffee(bare: true).on("error", $.util.log)).pipe gulp.dest("app/scripts")


# Scripts
gulp.task "scripts", ->
  gulp.src("./app/scripts/app.coffee",
    read: false
  ).pipe(browserify(
    transform: ["coffeeify"]
    extensions: [".coffee"]
  )).pipe(rename("app.js")).pipe gulp.dest("dist/scripts")
  return

gulp.task "jade", ->
  gulp.src("app/template/*.jade").pipe($.jade(pretty: true)).pipe gulp.dest("dist")


# HTML
gulp.task "html", ->
  gulp.src("app/*.html").pipe($.useref()).pipe(gulp.dest("dist")).pipe $.size()


# Images
gulp.task "images", ->
  gulp.src("app/images/**/*").pipe($.cache($.imagemin(
    optimizationLevel: 3
    progressive: true
    interlaced: true
  ))).pipe(gulp.dest("dist/images")).pipe $.size()

gulp.task "jest", ->
  nodeModules = path.resolve("./node_modules")
  gulp.src("app/scripts/**/__tests__").pipe $.jest(
    scriptPreprocessor: nodeModules + "/gulp-jest/preprocessor.js"
    unmockedModulePathPatterns: [nodeModules + "/react"]
  )


# Clean
gulp.task "clean", (cb) ->
  del [
    "dist/styles"
    "dist/scripts"
    "dist/images"
  ], cb
  return


# Bundle
gulp.task "bundle", [
  "styles"
  "scripts"
  "bower"
], ->
  gulp.src("./app/*.html").pipe($.useref.assets()).pipe($.useref.restore()).pipe($.useref()).pipe gulp.dest("dist")


# Build
gulp.task "build", [
  "html"
  "bundle"
  "images"
]

# Default task
gulp.task "default", [
  "clean"
  "build"
  "jest"
]

# Webserver
gulp.task "serve", ->
  gulp.src("dist").pipe $.webserver(
    livereload: true
    port: 9000
  )
  return


# Bower helper
gulp.task "bower", ->
  gulp.src("app/bower_components/**/*.js",
    base: "app/bower_components"
  ).pipe gulp.dest("dist/bower_components/")
  return

gulp.task "json", ->
  gulp.src("app/scripts/json/**/*.json",
    base: "app/scripts"
  ).pipe gulp.dest("dist/scripts/")
  return


# Watch
gulp.task "watch", [
  "html"
  "bundle"
  "serve"
], ->
  
  # Watch .json files
  gulp.watch "app/scripts/**/*.json", ["json"]
  
  # Watch .html files
  gulp.watch "app/*.html", ["html"]
  
  # Watch .scss files
  gulp.watch "app/styles/**/*.scss", ["styles"]
  
  # Watch .jade files
  gulp.watch "app/template/**/*.jade", [
    "jade"
    "html"
  ]
  
  # Watch .coffeescript files
  gulp.watch "app/scripts/**/*.coffee", [
    "coffee"
    "scripts"
    "jest"
  ]
  
  # Watch .js files
  gulp.watch "app/scripts/**/*.js", [
    "scripts"
    "jest"
  ]
  
  # Watch image files
  gulp.watch "app/images/**/*", ["images"]
  return


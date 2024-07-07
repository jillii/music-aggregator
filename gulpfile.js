/* file: gulpfile.js */
var gulp = require('gulp');
var sass = require('gulp-sass')(require('sass'));
const minify = require('gulp-minify');
// var concat = require('gulp-concat');

gulp.task('sass', function(){
  return gulp.src('app/assets/sass/main.scss')
    .pipe(sass()) // Using gulp-sass
    .pipe(gulp.dest('app/assets/stylesheets/'))
    .pipe(minify({
      ext: '.css',
      mangle: false,
      noSource: true
    }))
});

// gulp.task('compress', function() {
//    return gulp.src('js/*.js')
//     .pipe(concat('main.js'))
//     .pipe(minify({
//       ext: '.js',
//       mangle: false,
//       noSource: true
//      }))
//     .pipe(gulp.dest('dist/scripts'));
// });

gulp.task('watch', function() {
  gulp.watch('app/assets/sass/main.scss', gulp.series('sass'));
  // gulp.watch('js/*.js', gulp.series('compress'));
});

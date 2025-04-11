/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'class',
  content: [
    './app/views/**/*.{erb,haml,html,slim}',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
    './config/initializers/**/*.rb',
    './lib/components/**/*.{rb,erb,haml,html,slim}'
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
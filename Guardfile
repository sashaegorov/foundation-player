# Separate CoffeeScript compilation settings
# Settings for Foundation Player script:
coffee_options_src = {
  input: 'src', output: 'dist',
  patterns: [%r{^src/(.+\.(?:coffee|coffee\.md|litcoffee))$}],
  all_on_start: true
}
# Settings for specs:
coffee_options_spec = {
  input: 'spec/javascripts/', output: 'spec/javascripts/',
  patterns: [%r{^spec/javascripts/(.+\.(?:coffee|coffee\.md|litcoffee))$}],
  all_on_start: true,
  bare: true # Don't wrap specs' in function
}

group :all_the_stuff, halt_on_fail: true do
  # Compile player's CoffeeScript file
  guard 'coffeescript', coffee_options_src do
    coffee_options_src[:patterns].each { |pattern| watch(pattern) }
  end

  # Compile specs' CoffeeScript files
  guard 'coffeescript', coffee_options_spec do
    coffee_options_spec[:patterns].each { |pattern| watch(pattern) }
  end

  # Strip testing API i.e. JavaScript code between lines:
  # /*__TEST_ONLY_SECTION_STARTS__ */ and /*__TEST_ONLY_SECTION_ENDS__ */
  # and write it to file without `.dev` suffix
  guard :shell do
    watch(%r{^dist/.*\.dev\.js}) do |m|
      out = m[0].sub '.dev.js', '.js'
      `sed '/__TEST_ONLY_SECTION_STARTS__/,/__TEST_ONLY_SECTION_ENDS__/d' #{m[0]} > #{out}`
    end
  end

  # Uglify main JavaScript file
  guard 'uglify',
        input: 'dist/foundation-player.js',
        output: 'dist/foundation-player.min.js'

  # Compile HAML
  guard :haml, notifications: true do
    watch(/^.+(\.haml)$/)
  end

  # Compile SCSS
  guard :compass, project_path: '.', compile_on_start: true do
    watch(/.*\.scss$/)
  end

  # Update browser
  guard 'livereload' do
    watch(%r{^spec/javascripts/(.*)\.js})
    watch(%r{^spec/javascripts/(.*)\.html})
    watch(%r{^dist/(.*)\.dev\.js})
    watch(%r{^dist/(.*)\.css})
    watch(/^index\.html/)
  end
end

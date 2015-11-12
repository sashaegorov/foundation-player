# Separate CoffeeScript compilation settings
# Settings for Foundation Player script:
coffee_options_src = {
  input: 'src', output: 'src',
  patterns: [%r{^src/(.+\.dev\.(?:coffee|coffee\.md|litcoffee))$}]
}
# Settings for specs:
coffee_options_spec = {
  input: 'spec/javascripts/', output: 'spec/javascripts/',
  patterns: [%r{^spec/javascripts/(.+\.(?:coffee|coffee\.md|litcoffee))$}],
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
  # /*__TEST_API_STARTS__ */ and /*__TEST_API_ENDS__ */
  # and write it to file without `.dev` suffix
  guard :shell do
    watch(%r{^src/.*\.dev\.js}) do |m|
      out = m[0].sub '.dev.js', '.js'
      `sed '/__TEST_API_STARTS__/,/__TEST_API_ENDS__/d' #{m[0]} > #{out}`
    end
  end

  # Uglify main JavaScript file
  guard 'uglify',
        input: 'src/foundation-player.js',
        output: 'src/foundation-player.min.js'

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
    watch(%r{^spec/javascripts/.*/(.*)\.js})
    watch(%r{^spec/javascripts/(.*)\.js})
    watch(%r{^src/(.*)\.js})
    watch(%r{^src/(.*)\.css})
    watch(/^index\.html/)
  end
end

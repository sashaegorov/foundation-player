# Require any additional compass plugins here.
add_import_path File.join(
  $LOAD_PATH.find{ |v| v =~ /rails-assets-foundation-sites/ },
  '..', 'app', 'assets', 'stylesheets')

# Set this to the root of your project when deployed:
http_path = '/'
css_dir = 'dist'
sass_dir = 'src'

output_style = :nested

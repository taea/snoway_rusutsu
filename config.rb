###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

# Slim settings
# Set slim-lang output style
Slim::Engine.set_default_options :pretty => true
# Set Shortcut
Slim::Engine.set_default_options :shortcut => {
  '#' => {:tag => 'div', :attr => 'id'},
  '.' => {:tag => 'div', :attr => 'class'},
  '&' => {:tag => 'input', :attr => 'type'}
}

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end

# livereload
activate :livereload

# Using Frontmatter in Partials 
helpers do
  def snippet(component, overrides = nil)

    def colorize(text, color_code)
      "\e[#{color_code}m#{text}\e[0m"
    end

    def red(text); colorize(text, 31); end
    def green(text); colorize(text, 32); end


    basepath = File.expand_path File.dirname(__FILE__)
    exists = File.exists?(basepath << "/source/partials/components/" << component << ".html.haml")

    if exists
      # Read the partial, get the YAML, extend that hash with any overrides passed in
      yaml_regex = /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
      content = File.read(basepath)
      content = content.sub(yaml_regex, "")
      data = YAML.load($1)

      # Extend the hash so that any overrides are used instead of the defaults
      if overrides != nil
        overrides.each_key do |key|
          data[key] = overrides[key]
        end
      end
    else
      puts red('[ERROR:]') + " Partial #{component} not found!"
      return '<span style="color: red; font-weight: bold;">Error: Partial \'' + component + '\' not found!</span>'
    end

    ##
    # At this point, we have our data and know it exists
    # Just load that partial baby
    ##
    partial "/partials/components/" << component.sub("_", ""), :locals => data

  end
end

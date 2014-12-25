begin
  require "pry"
rescue LoadError
end

require 'svg_hearts_you/configuration'
require 'svg_hearts_you/module'
require 'svg_hearts_you/helpers'

# Add Helper methods as class methods on SvgHeartsYou
# SvgHeartsYou.extend(SvgHeartsYou::Helpers)

# Bind to Rails, Middleman, Jeykll, Sinatra... if availible
# ActionView::Base.send :include, SvgHeartsYou::Helpers if defined?(Rails)

require 'svg_hearts_you/railtie' if defined?(Rails)
require 'svg_hearts_you/middleman_extension' if defined?(Middleman)

# if defined?(Rails)
#   class Railtie < ::Rails::Railtie
#     initializer 'bh.add_helpers' do
#       ActionView::Base.send :include, SvgHeartsYou::Helpers
#     end
#   end
#   Railtie
# end

# if defined?(Middleman)
#   # Middleman.helpers SvgHeartsYou::Helpers
# end

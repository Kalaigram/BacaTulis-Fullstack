ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

# Windows workaround: cssbundling-rails detects JS tools with `command -v`,
# which is not available in cmd/PowerShell. The CSS bundle is built manually
# via `npm run build:css` (or `npm run watch:css` during development).
ENV["SKIP_CSS_BUILD"] = "1" if RUBY_PLATFORM.match?(/mingw|mswin/)

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.

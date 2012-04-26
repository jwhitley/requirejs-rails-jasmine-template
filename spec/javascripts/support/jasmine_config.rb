module Jasmine
  class Config
    # Retrieve the spec files via Sprockets
    def spec_files
      spec_files = []
      env = Rails.application.assets
      env.each_logical_path do |lp|
        spec_files << lp if lp =~ %r{^spec/.*\.js$}
      end
      spec_files
    end
  end
end

module Jasmine
  class RunAdapter
    def run(focused_suite = nil)
      jasmine_files = @jasmine_files
      css_files = @jasmine_stylesheets + (@config.css_files || [])
      js_files = @config.js_files(focused_suite)
      body = ERB.new(File.read(File.join(File.dirname(__FILE__), "run.html.erb"))).result(binding)
      [
        200,
        { 'Content-Type' => 'text/html', 'Pragma' => 'no-cache' },
        [body]
      ]
    end
  end
end

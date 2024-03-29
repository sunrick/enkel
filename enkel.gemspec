# frozen_string_literal: true

require_relative "lib/enkel/version"

Gem::Specification.new do |spec|
  spec.name = "enkel"
  spec.version = Enkel::VERSION
  spec.authors = ["Rickard Sunden"]
  spec.email = ["rickardsunden@gmail.com"]

  spec.summary = "Write smaller and simpler code."
  spec.description = ""
  spec.homepage = "https://sunrick.github.io/enkel/"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://sunrick.github.io/enkel/"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files =
    Dir.chdir(__dir__) do
      `git ls-files -z`.split("\x0")
        .reject do |f|
          (File.expand_path(f) == __FILE__) ||
            f.start_with?(
              *%w[bin/ test/ spec/ features/ .git .circleci appveyor]
            )
        end
    end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk", "~> 2.6.8"

  spec.add_development_dependency "pry", "~> 0.14.2"
  spec.add_development_dependency "prettier_print"
  spec.add_development_dependency "syntax_tree"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end

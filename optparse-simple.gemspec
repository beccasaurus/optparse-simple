# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{optparse-simple}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["remi"]
  s.date = %q{2009-04-02}
  s.description = %q{a partial reimplementation of OptionParser}
  s.email = %q{remi@remitaylor.com}
  s.files = ["Rakefile", "VERSION.yml", "README.rdoc", "lib/optparse-simple.rb", "spec/option_spec.rb", "spec/spec_helper.rb", "spec/optparse_simple_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/remi/optparse-simple}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{a partial reimplementation of OptionParser}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<remi-indifferent-variable-hash>, [">= 0"])
    else
      s.add_dependency(%q<remi-indifferent-variable-hash>, [">= 0"])
    end
  else
    s.add_dependency(%q<remi-indifferent-variable-hash>, [">= 0"])
  end
end

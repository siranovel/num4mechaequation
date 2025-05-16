Gem::Specification.new do |s|
  s.name        = 'num4mechaequ'
  s.version     = '0.2.1'
  s.date        = '2025-05-15'
  s.summary     = "num for mechanics equation!"
  s.description = "numerical solution for mechanics equation."
  s.authors     = ["siranovel"]
  s.email       = "siranovel@gmail.com"
  s.homepage    = "http://github.com/siranovel/num4mechaequation"
  s.metadata    = {
      'changelog_uri'     => s.homepage + '/blob/main/CHANGELOG.md',
      'documentation_uri' => "https://rubydoc.info/gems/#{s.name}/#{s.version}",
      'homepage_uri'      => s.homepage,
      'wiki_uri'          => 'https://github.com/siranovel/mydocs/tree/main/num4phyequation/num4mechaequation',
  }
  s.license     = "MIT"
  s.required_ruby_version = ">= 3.0"
  s.files       = ["LICENSE", "Gemfile", "CHANGELOG.md"]
  s.files       += Dir.glob("{lib,ext}/**/*")
  s.add_dependency 'num4simdiff', '~> 0.3', '>= 0.3.1'
end

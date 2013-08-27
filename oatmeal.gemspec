Gem::Specification.new do |s|
  s.name        = 'oatmeal'
  s.version     = '1.0.0'
  s.platform    = 'universal-dotnet'
  s.authors     = ['Ian Dees']
  s.email       = ['undees@gmail.com']
  s.homepage    = 'http://github.com/undees/oatmeal'
  s.summary     = 'Just barely enough Iron in your Serial'
  s.description = 'Provides a tiny subset of the serialport gem for IronRuby'

  s.required_rubygems_version = '>= 1.3.5'

  s.files        = Dir.glob('lib/**/*') + %w(LICENSE.txt README.rst)
  s.require_path = 'lib'
end

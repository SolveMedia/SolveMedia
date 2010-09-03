require 'rake'
require 'rake/rdoctask'

desc 'Generate documentation for the solvemedia plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SolveMedia'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "solvemedia"
    gem.summary = "Simplifies the use of Solve Media puzzles within rails applications"
    gem.description = "Simplifies the use of Solve Media puzzles within rails applications"
    gem.email = "plugin@solvemedia.com"
    gem.homepage = "http://portal.solvemedia.com/portal/help/pub/ruby"
    gem.authors = ["Eddie Siegel"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

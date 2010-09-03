class SolvemediaConfigGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "solvemedia_config.yml", "config/solvemedia_config.yml"
    end
  end
end

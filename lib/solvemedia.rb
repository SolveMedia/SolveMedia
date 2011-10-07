# SolveMedia
require 'view_methods'
require 'controller_methods'

module SolveMedia
  CONFIG_FILE = "#{Rails.root.to_s}/config/solvemedia_config.yml"
  CONFIG = YAML.load_file(CONFIG_FILE) if File.exist?(CONFIG_FILE)
  VERIFY_SERVER = 'http://verify.solvemedia.com'
  API_SERVER = 'http://api.solvemedia.com'
  API_SECURE_SERVER = 'https://api-secure.solvemedia.com'
  SIGNUP_URL = 'http://portal.solvemedia.com/portal/public/signup'
  
  class AdCopyError < StandardError
  end
  
  def self.check_for_keys!
    if !File.exist?(CONFIG_FILE) || CONFIG.nil? || CONFIG['C_KEY'].nil? || CONFIG['V_KEY'].nil? || CONFIG['H_KEY'].nil?
      raise AdCopyError, "Solve Media API keys not found. Keys can be obtained at #{SIGNUP_URL}"
    end
  end
end

class ActionView::Base
  include SolveMedia::ViewMethods
end

class ActionController::Base
  include SolveMedia::ControllerMethods
end

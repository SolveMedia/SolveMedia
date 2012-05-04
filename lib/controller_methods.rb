module SolveMedia
require 'net/http'
  
  # Methods within this module will be included in ActionController::Base 
  module ControllerMethods
    
    # Sends a POST request to the Solve Media server in order to verify the user's input.
    # Returns +true+ if the user's input is valid, +false+ otherwise
    #
    # Options:
    # <tt>:validate_response</tt>::  Whether or not the Solve Media authenticator should be used to validate the server's response. If this is set to +true+ and the validation fails, an AdCopyError is raised.
    # <tt>:timeout</tt>::  The amount of time in seconds before the request should timeout. If the request times out, a Timeout::Error is raised.
    # <tt>:model</tt>::  An ActiveRecord model. If verification fails, an error will be added to this model.
    # <tt>:error_message</tt>::  A custom error message (to be used in conjunction with <tt>:model</tt>) to be used if verification fails.
    def verify_solvemedia_puzzle(options = {})
      SolveMedia::check_for_keys!
      options = { :validate_response  => true,
                  :timeout            => 5,
                  :model              => nil,
                  :error_message      => nil,
                  :config             => SolveMedia::CONFIG
                }.merge(options)
      
      #Send POST to SolveMedia
      response = nil
      Timeout::timeout(options[:timeout]) do
        response = Net::HTTP.post_form URI.parse("#{SolveMedia::VERIFY_SERVER}/papi/verify"), {
          "privatekey"  =>  options[:config]['V_KEY'],
          "challenge"   =>  params[:adcopy_challenge],
          "response"    =>  params[:adcopy_response],
          "remoteip"    =>  (options[:remote_ip] || request.remote_ip)
        }
      end
      answer, error, authenticator = response.body.split("\n")
      
      #validate the response
      if options[:validate_response] && authenticator != Digest::SHA1.hexdigest("#{answer}#{params[:adcopy_challenge]}#{options[:config]['H_KEY']}")
        raise AdCopyError, "SolveMedia Error: Unable to Validate Response" 
      end
      
      if answer.downcase == "true"
        return true
      else
        #Add error to the model
        if options[:model]
          options[:model].valid?
          options[:model].errors.add(:base, options[:error_message] || "Solve Media Puzzle: #{error}")
        end
        
        return false
      end
    end
  end
end

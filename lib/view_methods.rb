module SolveMedia
  
  # Methods within this module will be included in ActionView::Base 
  module ViewMethods
    
    # Returns the HTML for a Solve Media puzzle
    #
    # Options:
    # <tt>tabindex</tt>::  The tab index of the text field within the puzzle (defaults to <tt>nil</tt>)
    # <tt>theme</tt>::  The theme applied to the puzzle (defaults to <tt>'purple'</tt>)
    # <tt>lang</tt>::  The language of the puzzle (defaults to <tt>'en'</tt>)
    def solvemedia_puzzle(options = {})
      SolveMedia::check_for_keys!
      options = { :tabindex => nil,
                  :theme    => 'purple',
                  :lang     => 'en',
                  :size     => '300x150',
                  :config   => SolveMedia::CONFIG,
                  :use_SSL  => false
                  }.merge(options)
      
      if options[:use_SSL]
        server = SolveMedia::API_SECURE_SERVER
      else
        server = SolveMedia::API_SERVER
      end
      
      if options[:ajax]
        aopts = {:theme => options[:theme], :lang => options[:lang], :size => options[:size]}
        aopts[:tabindex] = options[:tabindex] if options[:tabindex]

        output = javascript_include_tag("#{server}/papi/challenge.ajax")
        js = <<-EOF          
          function loadSolveMediaCaptcha(){
            if(window.ACPuzzle) { 
              ACPuzzle.create(#{options[:config]['C_KEY'].to_json}, #{options[:ajax_div].to_json}, #{aopts.to_json});
            } else {
              setTimeout(loadSolveMediaCaptcha, 50);
            }
          }
          loadSolveMediaCaptcha();
        EOF

        output << javascript_tag(js)
        output = output.html_safe if output.respond_to?('html_safe')
        return output
      else
        output = ""
      
        output << %{<script type="text/javascript">\n}
        output << "	var ACPuzzleOptions = {\n"
        output << %{			tabindex:   #{options[:tabindex]},\n} unless options[:tabindex].nil?
        output << %{			theme:	    '#{options[:theme]}',\n}
        output << %{			lang:	    '#{options[:lang]}',\n}
        output << %{			size:	    '#{options[:size]}'\n}
        output << "	};\n"
        output << %{</script>\n}
      
        output << %{<script type="text/javascript"}
        output << %{   src="#{server}/papi/challenge.script?k=#{options[:config]['C_KEY']}">}
        output << %{</script>}

        output << %{<noscript>}
        output << %{   <iframe src="#{server}/papi/challenge.noscript?k=#{options[:config]['C_KEY']}"}
        output << %{	 height="300" width="500" frameborder="0"></iframe><br/>}
        output << %{   <textarea name="adcopy_challenge" rows="3" cols="40">}
        output << %{   </textarea>}
        output << %{   <input type="hidden" name="adcopy_response"}
        output << %{	 value="manual_challenge"/>}
        output << %{</noscript>}
        output = output.html_safe if output.respond_to?('html_safe')
        return output

      end
    end
  end
end

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
                  :config   => SolveMedia::CONFIG
                  }.merge(options)
      
      output = ""
      
      output << %{<script type="text/javascript">\n}
      output << "	var ACPuzzleOptions = {\n"
      output << %{			tabindex:   #{options[:tabindex]},\n} unless options[:tabindex].nil?
      output << %{			theme:	    '#{options[:theme]}',\n}
      output << %{			lang:	    '#{options[:lang]},'\n}
      output << %{			size:	    '#{options[:size]}'\n}
      output << "	};\n"
      output << %{</script>\n}
      
      output << %{<script type="text/javascript"}
      output << %{   src="#{SolveMedia::API_SERVER}/papi/challenge.script?k=#{options[:config][:c_key]}">}
      output << %{</script>}

      output << %{<noscript>}
      output << %{   <iframe src="#{SolveMedia::API_SERVER}/papi/challenge.noscript?k=#{options[:config][:c_key]}"}
      output << %{	 height="300" width="500" frameborder="0"></iframe><br/>}
      output << %{   <textarea name="adcopy_challenge" rows="3" cols="40">}
      output << %{   </textarea>}
      output << %{   <input type="hidden" name="adcopy_response"}
      output << %{	 value="manual_challenge"/>}
      output << %{</noscript>}
      return output
    end
  end
end

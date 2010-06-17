require 'rubygems'
require File.dirname(__FILE__)+'/johndoe/aiml'
require File.dirname(__FILE__)+'/johndoe/responser'
require File.dirname(__FILE__)+'/johndoe/markov'

module JohnDoe
  class ChatBot
    def initialize(filename = File.dirname(__FILE__) + "/../default.yml" , quotes_filename = "quotes")
      unless File.exists? quotes_filename
        f = File.new(quotes_filename,"w")
        f.close
      end
      @loader = JohnDoe::Aiml.new
      @loader.load(filename)
      @responser = JohnDoe::Responser.new(@loader,quotes_filename)
    end
    def get_response(s)
      @responser.response s
    end
  end
end


require 'rubygems'
require File.dirname(__FILE__)+'/johndoe/aiml'
require File.dirname(__FILE__)+'/johndoe/responser'

module JohnDoe
  class ChatBot
    def initialize(filename)
      @loader = JohnDoe::Aiml.new
      @loader.load(filename)
      @responser = JohnDoe::Responser.new(@loader)
    end
    def get_response(s)
      @responser.response s
    end
  end
end


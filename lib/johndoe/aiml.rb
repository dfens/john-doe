require 'yaml'
module JohnDoe

  class Aiml
    attr_accessor :rules,:patterns,:responses, :default, :knowledge, :emotions
    def initialize
      @rules = []
      @patterns = {}
      @responses = []
      @default = []
      @knowledge = []
      @emotions = {}
    end

    def load(filename)
      data= YAML::load_file(filename)
      collect_data data
      @default = data['default']
      @knowledge = data['knowledge']
      normalise_default
    end

    protected

    def collect_data(data)
      data.keys.each do |category|
        next if category == "default" || category == "knowledge"
        collection = data[category]
        responses = collection['responses'].collect{|k,v| v}
        @responses.push(responses)
        emotions = (collection["emotion"].split("|") rescue ["none"])
        puts emotions.inspect
        collection['patterns'].each{|k,v| @patterns[normalise_pattern(v)] = { :resp => (@responses.size - 1), :emotions => emotions}}
      end
    end

    def normalise_default
      @default.keys.each do |key|
        @default[key]= @default[key].map{|k,v| v}
      end
    end
    def normalise_pattern(pattern)
      pattern.gsub("*",".*").gsub("$","([^\n\?!.$]*)")
    end

  end

end

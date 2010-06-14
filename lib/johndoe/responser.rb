
module JohnDoe
  class Response
    attr_accessor :text, :emotion
    def initialize(t,e)
      @text = t
      @emotion = e[rand(e.size)]
    end
  end
  class Responser
    def initialize(data)
      @data = data
    end

    def response(sentence)
      @data.patterns.each do |k,v|
        if (/^#{k}/i =~ sentence)
          return Response.new(sub_v(random_quote(@data.responses[v[:resp]], /^#{k}/i.match(sentence).captures)),v[:emotions])
        end
      end
      return Response.new(sub_v(random_quote(@data.default["dontunderstand"])),["none"])
    end

    #substitute variables
    def sub_v(s)
      while (nil != (match = /(([a-z]+:)([a-z]+)+)/.match s))
        s.gsub!(match[0],get_data(match[0]))
      end
      return s
    end

    #get_data bot:name
    def get_data(path)
      root = @data.knowledge
      path.split(":").each {|v|root = root[v]}
      return root
    end

    def random_quote(s, subjects = [])
      return subject_replace(s[rand(s.size)], subjects)
    end

    def subject_replace(s,subjects = [])
      return s if subjects.empty?
      return s.gsub("$",describe_who(subjects[0]))
    end

    def describe_who(s)
      s.gsub(/([^a-z])me([^a-z]|$)/,"\\1###\\2").gsub(/([^a-z])you([^a-z]|$)/,"\\1me\\2").gsub("###","you")
    end
  end
end

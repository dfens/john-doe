
module JohnDoe
  class Responser
    def initialize(data)
      @data = data
    end

    def response(sentence)
      @data.patterns.each do |k,v|
        if (/^#{k}/i =~ sentence)
          
          return sub_v random_quote(@data.responses[v], /^#{k}/i.match(sentence).captures)
        end
      end

      return sub_v random_quote(@data.default["dontunderstand"])
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
      puts subjects.inspect
      return s if subjects.empty?
      return s.gsub("$",subjects[0])
    end
  end
end


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
      max_priority = -1
      best_v = nil
      best_k = nil

      @data.patterns.each do |k,v|
        if (/^#{k}/i =~ sentence)
          puts k
          next if v[:priority] <= max_priority
          max_priority = v[:priority]
          best_v = v
          best_k = k
        end
      end
      unless best_v.nil?
        return Response.new(sub_v(random_quote(@data.responses[best_v[:resp]], /^#{best_k}/i.match(sentence).captures)),best_v[:emotions])
      else
        return Response.new(sub_v(random_quote(@data.default["dontunderstand"])),["none"])
      end
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
      s = s.gsub(/([^a-z])am\s+i([^a-z]|$)/,"\\1#AMI#\\2").gsub(/([^a-z])i\s+am([^a-z]|$)/,"\\1#IAM#\\2").gsub(/([^a-z])you\s+are([^a-z]|$)/,"\\1#AREYOU#\\2").gsub(/([^a-z])are\s+you([^a-z]|$)/,"\\1#AREYOU#\\2").gsub(/([^a-z])me([^a-z]|$)/,"\\1#ME#\\2").gsub(/([^a-z])you([^a-z]|$)/,"\\1#YOU#\\2")
      s.gsub("#AMI#","you are").gsub("#IAM#","you are").gsub("#AREYOU#","I am").gsub("#ME#","you").gsub("#YOU#","me")
    end
  end
end

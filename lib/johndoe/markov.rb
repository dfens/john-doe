module JohnDoe
  class Markov

    def initialize
      @map = {}
    end

    def load(filename)
      file = File.new(filename, "r")
      while (line = file.gets)
        process_line line.downcase
      end
      file.close
      count_probability
    end

    #assume that model is linear so using linear prob
    def count_probability
      sum = 0
      p_sum = 0
      @map.each{|k,v| sum+=v[:count]}
      @map.each do |k,v|
        v[:p] = p_sum + v[:count]/sum.to_f 
        p_sum = v[:p]

      end
      @map.each do |k,v|
        word_sum = 0
        v.each do |word_key,word_val|
          next unless word_key.class == String
          word_sum += word_val
        end
        v[:word_sum] = word_sum  
      end
    end

    def process_line(line)
      line.squeeze!(" ")
      words = line.split(" ")
      for i in 0..words.length-2
        word1 = words[i]
        word2 = words[i+1]
        word3 = words[i+2]
        add(word1,word2,word3)
      end
    end

    def add(w1,w2,w3)
      w12 = w1+" "+w2
      if @map[w12].nil?
        @map[w12] = {:count => 1} 
      else
        @map[w12][:count]+=1
      end
      if @map[w12][w3].nil?
        @map[w12][w3] = 1
      else
        @map[w12][w3]+=1
      end

    end

    def generate_random
      r = rand
      str = ""
      @map.each  do |k,v|
        if r < v[:p]
          str = k
          break
        end
      end
      return gen_from_two(str)

    end

    def gen_from_two(str)
      begin
        while true
          found_nil = false
          two_last = two_last_words(str) rescue "I'm still learning"
          return str if @map[two_last].nil? || @map[two_last][:word_sum] == 0
          r = rand(@map[two_last][:word_sum])
          @map[two_last].each do |k,v|
            next if k.class == Symbol
            r -= v
            if r < 0
              found_nil == v.nil?
              str = str + " " + k
              break
            end
          end
        end
      end
      rescue nil
    end

    def two_last_words(s)
      m = /(.* )?([^\s]+) ([^\s]+)$/.match s
      return m[2] + " " + m[3] rescue nil
    end

    def response(str)
      str.squeeze(" ").split(" ").sort {|x,y| y.size <=> x.size}.each do |s|
        collection = []
        @map.each do |k,v|
          if k.include? s
            collection << k 
          end
        end
        return gen_from_two(@map.keys[rand(@map.keys.size)]) if collection.empty?
        return gen_from_two collection[rand(rand(collection.size))] rescue nil
      end
      return nil
    end

  end

end

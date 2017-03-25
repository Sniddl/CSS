def touch(path)
  dir = File.dirname(path)
  unless File.directory?(dir)
    FileUtils.mkdir_p(dir)
  end
end

def betweenr(pos1, pos2)
  return /#{Regexp.escape(pos1)}(.*?)$/m if pos2 == "newline"
  return /#{Regexp.escape(pos1)}(.*?)#{Regexp.escape(pos2)}/m
end


class String
  def between(pos1, pos2)
    return self.scan(/#{Regexp.escape(pos1)}(.*?)$/m) if pos2 == "newline"
    return self[/#{Regexp.escape(pos1)}(.*?)#{Regexp.escape(pos2)}/m, 1]
  end
end

class Array
  def to_hash(splitter)
    h = {}
    self.each do |me|

      split = me[0].split(splitter).map(&:strip).take(2)
      if split[1].end_with? ";"
        split[1] = split[1][0..-2]
      end
      h[split[0]] = split[1]
    end
    return h
  end
end

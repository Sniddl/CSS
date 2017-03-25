#!/usr/bin/env ruby

root = ARGV[0]
f    = ARGV[1]
require 'fileutils'
require "#{root}/src/methods"
require 'json'

env = File.read("#{root}/settings.json")
env = JSON.parse(env)






files = Dir.glob("#{root}#{env["path"]}**/*.#{env["extention"]}")

files.each_with_index do |file, index|
  contents = File.read(file)
  new_path = "#{root}#{env["export_path"]}#{file.sub("#{root}", "")}".sub("#{env["extention"]}", "") + "#{env["new_extention"]}"

  # create dir if needed.
  touch(new_path)

  # open and create file

  # cmd = "php -r '$c=new #{root}\\sniddl\\css\\SniddlCSS; echo $c->scan(\"#{file}\");'"
  cmd = "php -r 'namespace sniddl\\css;include \"#{root}/src/SniddlCSS.php\"; $c=new SniddlCSS; $c->scan(\"#{file}\") ;'"
  getPHP = %x( #{cmd} )
  system "clear" or system "cls"
  vars = JSON.parse(getPHP)

  # new_path = new_path


  new_file = File.new(new_path, "w")
  # vars = contents.between("$", "newline").to_hash("=")

  new_contents = contents
                .gsub(betweenr('<?php', "?>")){
                  ""
                }
                .gsub(betweenr('#{', "}")){
                  vars["#{$&[2..-2]}"]
                }
  # new_file.write(new_contents.gsub('<?php', '').gsub('?>', ''))

  if env["minify"]
    new_contents = new_contents.gsub(betweenr('$', "newline")){ "" }
    new_file.write(new_contents.gsub('/*', '').gsub('*/', '').split.join(" "))
  elsif env["keep_variables"]
    new_contents = new_contents.gsub(betweenr('$', "newline")){ "/* #{$&} */" }
    new_file.write(new_contents.gsub(/^$\n/, '').strip)
  else
    new_contents = new_contents.gsub(betweenr('$', "newline")){ "" }
    new_file.write(new_contents.strip)
  end

  new_file.close


end

puts "==============================="
puts "Success: #{files.count} files"
puts "==============================="
files.each_with_index do |file, index|
  puts "#{index+1}.\t#{file}"
end
puts "==============================="

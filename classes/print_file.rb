def print_file(file)
  if !file.nil?
    File.open(file, 'r') do | f |
      while line = f.gets
        puts line
      end
    end
  end
end

def print_file(file)
  if !file.nil?
    if File.exist?(file)
      File.open(file, 'r') do | f |
        while line = f.gets
          puts line
        end
      end
    else
      puts "File not exists:\n#{file}"
    end
  end
end

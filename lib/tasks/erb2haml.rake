desc "Creates haml files for each of the erb files found under views (skips existing)"
task :erb2haml do
  from_path = File.join(File.dirname(__FILE__), '..', '..', 'app', 'views')
  Dir["#{from_path}/**/*.erb"].each do |file|
    puts file
    # for each .erb file in the path, convert it & output to a .haml file
    output_file = file.gsub(/\.erb$/, '.haml')
    unless File.exist?(output_file)
      `rm #{file}` if `bundle exec html2haml -ex #{file} #{output_file}`
    end
  end
end
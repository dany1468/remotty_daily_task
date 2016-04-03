require 'erb'
require 'fileutils'
require 'open3'

PLISTS = ['ohayo', 'shinchokudo', 'otsukare']

working_dir = Dir::pwd
home_dir = ENV['HOME']
user_name = Open3.capture2('id -un').first.strip

dist_dir = File.join('plist', 'dist')
FileUtils.rm_rf(dist_dir)
Dir.mkdir(dist_dir)

PLISTS.each do |plist_key|
  output_file = "remotty_daily_task_#{plist_key}.plist"

  erb = ERB.new(File.read(File.join('plist', "#{output_file}.template")))

  File.write(File.join(dist_dir, output_file), erb.result(binding))
end


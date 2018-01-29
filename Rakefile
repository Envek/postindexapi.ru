require './postindexapi.rb'
require 'sinatra/activerecord/rake'
require 'open-uri'
require 'nokogiri'
require 'fileutils'

namespace :post_index do

  desc 'Update used post indices database to latest'
  task :update do
    # Get info about post indices database
    url_prefix = 'http://vinfo.russianpost.ru/database'
    doc  = Nokogiri::HTML(open("#{url_prefix}/ops.html"))
    file = doc.at_css('a[name=newdbdata]+table tr:last-child td:nth-child(4) a').attr :href
    FileUtils.mkdir_p "#{settings.root}/tmp/post_indices"
    dir = Pathname.new("#{settings.root}/tmp/post_indices")
    filepath = Pathname.new("#{dir}/#{file}")
    filepath_success = Pathname.new("#{dir}/#{file}.success")
    if filepath.exist? and filepath_success.exist?
      puts 'Already up-to-date.'
    else
      # Download, unzip, rename and convert post indices file
      sh "wget --continue #{url_prefix}/#{file} -O #{filepath}"
      sh "unzip -o #{filepath} -d #{dir}"
      dbf_filename = filepath.to_s.gsub /\.zip$/, '.dbf'
      sh "cp -f #{dbf_filename} #{dir}/post_indices.dbf"
      sh "pgdbf -u #{dir}/post_indices.dbf | iconv -f CP866 -t utf-8 > #{dir}/post_indices.sql"
      # Import in database
      config = YAML.load_file("#{settings.root}/config/database.yml")[settings.environment.to_s]
      dbh, dbu, dbp, db = config['host'], config['username'], config['password'], config['database']
      sh "PGPASSWORD=#{dbp} psql -U #{dbu} -w -h #{dbh} #{db} < #{dir}/post_indices.sql"
      # Clean up
      FileUtils.rm [dbf_filename, "#{dir}/post_indices.dbf", "#{dir}/post_indices.sql"], force: true
      FileUtils.touch filepath_success
    end
  end

end

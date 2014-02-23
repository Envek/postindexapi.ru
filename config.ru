# encoding: utf-8
Encoding.default_external = Encoding::UTF_8
require 'bundler'
Bundler.require
require './postindexapi'
run Sinatra::Application
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/respond_to'
require 'yajl/json_gem'
Sinatra::Application.register Sinatra::RespondTo
set :haml, :format => :html5
set :public_folder, File.dirname(__FILE__) + '/static'
set :database_file, 'config/database.yml'

class PostIndex < ActiveRecord::Base
  self.primary_key = 'index'
  default_scope -> { order(:index) }
  has_many :subordinates, class_name: 'PostIndex', foreign_key: 'ops_subm'#, inverse_of: :superior
  belongs_to :superior, class_name: 'PostIndex' #, inverse_of: :subordinates
  def to_s; "#{self.index} — #{self.ops_name}" end
end

get %r{/(\d{6})} do |index|
  @index = PostIndex.where(index: index).first
  @index = PostIndex.where(index_old: index).order(:index).first! unless @index
  last_modified @index.act_date
  respond_to do |format|
    format.html { haml :post_index }
    format.json {
      headers \
        'Access-Control-Allow-Origin' => '*',
        'Access-Control-Allow-Methods' => 'GET'
      yajl :post_index, callback: params[:callback]
    }
  end
end

get '/' do
  haml :dashboard
end

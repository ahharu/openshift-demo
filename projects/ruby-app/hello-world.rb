#!/usr/bin/env ruby

require 'sinatra'
require 'redis'

redis = Redis.new(:host => ENV["REDIS_HOST"] || "127.0.0.1" , :port => ENV["REDIS_PORT"] || 6379, :port => ENV["REDIS_PASSWORD"] || nil)

get '/' do
  redis.ping
  "Hello World!"
end
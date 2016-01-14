require './app.rb'
require 'octokit'

if !ENV['OAUTH']
  puts 'REQUIRED - No OAUTH environment variable set. You should set this up via github.'
  exit
end
if !ENV['REPO']
  puts 'REQUIRED - No REPO environment variable set. This should be the name of the repo. e.g. octokit/octokit.rb'
  exit
end

Octokit.auto_paginate = true
$client = Octokit::Client.new(:access_token =>  ENV['OAUTH'])


run App
require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/facebook_api.rb'

PAGE_NAME = 'cowbeiNTHU'.freeze
CONFIG = YAML.safe_load(File.read('../config/secrets.yml'))
CORRECT = YAML.load(File.read('fixtures/results.yml'))
CASSTTE_FILE = 'facebook_api'.freeze

require "aws"
AWS.config(:logger => Rails.logger)
config_path = File.expand_path(File.dirname(__FILE__) + "/config.yml")
AWS.config(YAML.load(File.read(config_path)))
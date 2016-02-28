require 'pp'
require 'date'
require 'when_exe'
require 'when_exe/core/extension'
require 'when_exe/mini_application'
include When
Pry.hooks.add_hook :after_read, :hack_encoding do |str, _|
  str.force_encoding STDIN.external_encoding 
end

require_relative 'entry.rb'

puts "test block 1"
config = load_config('./test_files/test_file_1.conf')
puts config.ftp
puts config.ftp.name
puts config.lastname
puts config.common.paid_users_size_limit
puts config.http.params


puts "test block 2, with overrides"
conf_overrides = load_config('./test_files/test_file_1.conf', [:production, "ubuntu"])
puts conf_overrides.ftp
puts conf_overrides.ftp.name
puts conf_overrides.lastname
puts conf_overrides.common.paid_users_size_limit
puts conf_overrides.http.params

require 'rspec'
require_relative '../lib/config_hash'
require_relative '../lib/config_object'

describe ConfigObject do
  config = ConfigObject.new("./test_files/test_file_1.conf")
  it "returns a symbolized hash on a single method call" do
    ftp_call = config.ftp
    expect(ftp_call.class).to eq(Hash)
    expect(ftp_call[:name]).to eq("hello there, ftp uploading")
    expect(ftp_call[:enabled]).to be(true)
  end

  it "handles the case with no overrides" do
    ftp_name_call = config.ftp.name
    ftp_enabled_call = config.ftp.enabled 
    expect(ftp_name_call).to eq("hello there, ftp uploading")
    expect(ftp_enabled_call).to be (true)
  end

  it "handles the case with one override" do
  end

  it "handles the case with multiple overrides" do

  end
end

require 'rspec'
require_relative '../lib/config_hash'
require_relative '../lib/config_object'
require_relative '../lib/entry'

describe ConfigObject do
  config = ConfigObject.new("./test_files/test_file_1.conf")
  config_overrides = ConfigObject.new("./test_files/test_file_1.conf", [:production, "ubuntu"])

  it "returns a symbolized hash on a single method call" do
    ftp_call = config.ftp
    expect(ftp_call.class).to eq(Hash)
    expect(ftp_call[:path]).to eq("/tmp/")
    expect(ftp_call[:enabled]).to be(false)
    expect(ftp_call[:name]).to eq("hello there, ftp uploading")
  end

  it "handles the case with no overrides" do
    ftp_name_call = config.ftp.name
    ftp_enabled_call = config.ftp.enabled
    expect(ftp_enabled_call).to be (false)
    expect(ftp_name_call).to eq("hello there, ftp uploading")
  end

  it "handles the case with one override" do
  end

  it "handles the case with multiple overrides" do

  end
end

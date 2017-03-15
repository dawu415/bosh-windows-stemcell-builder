#!/usr/bin/env ruby

require 'fileutils'

require_relative '../lib/exec_command'
require_relative '../lib/zip_file'

FileUtils.mkdir_p(File.join("stemcell-builder","build"))
FileUtils.cp_r("windows-stemcell-dependencies", File.join("stemcell-builder","build","windows-stemcell-dependencies"))
FileUtils.cp_r("base-gcp-image", File.join("stemcell-builder","build","base-gcp-image"))
FileUtils.cp_r("version", File.join("stemcell-builder","build","version"))

directory = File.join(__dir__,"..","bosh-psmodules","modules")
output = File.join("stemcell-builder","build","bosh-psmodules.zip")
ZipFile::Generator.new(directory, output).write()

Dir.chdir "stemcell-builder" do
  exec_command("bundle install")
  exec_command("rake package:agent")
  exec_command("rake build:gcp")
  exec_command("mv bosh-windows-stemcell/*.tgz ../bosh-windows-stemcell")
end

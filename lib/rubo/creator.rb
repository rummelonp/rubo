# coding: utf-8

require 'fileutils'

module Rubo
  class Creator
    def initialize(path)
      @path = File.expand_path(path)
      @templates_path = File.expand_path('../../../templates', __FILE__)
      @plugins_path   = File.expand_path('../../../plugins', __FILE__)
    end

    def mkdir(path)
      puts "Creating directory #{path}"
      FileUtils.mkdir_p(path)
    end

    def copy(from, to)
      puts "Copying #{from} -> #{to}"
      FileUtils.cp(from, to)
    end

    def run
      puts "Creating a rubo install at #{@path}"

      mkdir(@path)
      mkdir("#{@path}/bin")
      mkdir("#{@path}/plugins")

      files = %w{Gemfile}
      files.each do |f|
        copy("#{@templates_path}/#{f}", "#{@path}/#{f}")
      end

      bins = %w{bin/rubo}
      bins.each do |f|
        copy("#{@templates_path}/#{f}", "#{@path}/#{f}")
        FileUtils.chmod(0755, "#{@path}/#{f}")
      end

      Dir["#{@plugins_path}/*.rb"].each do |f|
        copy(f, "#{@path}/plugins/#{File.basename(f)}")
      end
    end
  end
end

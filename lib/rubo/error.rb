# coding: utf-8

module Rubo
  # Custom error class for rescuing from all Rubo errors
  class Error < StandardError
  end

  class LoadError < Error
  end
end

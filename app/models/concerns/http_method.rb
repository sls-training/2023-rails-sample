# frozen_string_literal: true

require 'net/https'
require 'uri'

module HttpMethod
  BASE_URL = 'http://localhost:3000/api'

  def get(url_path, params: {}, headers: {})
    uri = URI("#{BASE_URL}#{url_path}")
    uri.query = URI.encode_www_form(params)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.get(uri.to_s, headers)
  end

  def post(url_path, params: {}, headers: {})
    uri = URI("#{BASE_URL}#{url_path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.post(uri.path, params.to_json, headers)
  end
end

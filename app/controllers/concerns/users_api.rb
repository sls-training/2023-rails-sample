# frozen_string_literal: true

require 'net/https'
require 'uri'

module UsersApi
  BASE_URL = 'http://localhost:3000/api'

  private

  def get(url_path, params: {}, headers: {})
    uri = URI("#{BASE_URL}#{url_path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'

    path_with_query = [uri.path, URI.encode_www_form(params)]
                        .compact_blank
                        .join('?')
    http.get(path_with_query, headers)
  end

  def post(url_path, params: {}, headers: {})
    uri = URI("#{BASE_URL}#{url_path}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    http.post(uri.path, params.to_json, headers)
  end
end

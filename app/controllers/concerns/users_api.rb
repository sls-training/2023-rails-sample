# frozen_string_literal: true

require 'net/https'
require 'uri'

module UsersApi
  BASE_URL = 'http://localhost:3000/api'
  EMAIL =  Rails.application.credentials.app.rails_sample_email
  PASSWORD = Rails.application.credentials.app.rails_sample_password

  extend ActiveSupport::Concern

  included do
    before_action :generate_access_token
  end

  def get_users(sort_by: 'name', order_by: 'asc', limit: 50, offset: 0)
    response = get('/users', params: { sort_by:, order_by:, limit:, offset: }, headers: headers_with_token)
    redirect_to_login and return unless response.code == '200'

    JSON.parse(response.body, symbolize_names: true)
  end

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

  def headers_with_token
    { 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{raw_access_token}" }
  end

  def raw_access_token
    @raw_access_token ||= create_token(EMAIL, PASSWORD)
  end

  def access_token
    @_access_token ||= AccessToken.from_token(raw_access_token) if raw_access_token.present?
  end

  def generate_access_token
    redirect_to_login if raw_access_token.nil?

    begin
      access_token
    rescue JWT::DecodeError
      redirect_to_login
    end
  end

  def redirect_to_login
    redirect_to login_url, flash: { danger: 'ログインし直してください' }
  end

  def create_token(email, password)
    response = post('/token', params: { email:, password: }, headers: { 'Content-Type' => 'application/json' })
    JSON.parse(response.body, symbolize_names: true)[:access_token]
  end
end

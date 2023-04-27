class AddAuthenticateToken < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :authenticate_token, :string
  end
end

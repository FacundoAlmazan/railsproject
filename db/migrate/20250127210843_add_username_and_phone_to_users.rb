class AddUsernameAndPhoneToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :username, :string
    add_column :users, :phone, :string
  end
end

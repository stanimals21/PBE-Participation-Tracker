# frozen_string_literal: true

class AddPasswordFieldToCustomers < ActiveRecord::Migration[6.0]
  def change
    remove_column 'customers', 'password', :string
    add_column 'customers', 'password_digest', :string, null: false
  end
end
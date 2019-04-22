# frozen_string_literal: true

class CreateUsersWorksJoin < ActiveRecord::Migration[5.2]
  def change
    create_table :users_works do |t|
      t.belongs_to :users, index: :true
      t.belongs_to :works, index: :true
    end
  end
end

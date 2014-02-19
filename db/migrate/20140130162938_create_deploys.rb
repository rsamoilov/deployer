class CreateDeploys < ActiveRecord::Migration
  def change
    create_table :deploys do |t|
      t.string :uid, null: false
      t.string :service, null: false
      t.string :state, null: false

      t.timestamps
    end

    add_index :deploys, :uid
  end
end

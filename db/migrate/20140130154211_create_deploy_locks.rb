class CreateDeployLocks < ActiveRecord::Migration
  def change
    create_table :deploy_locks do |t|
      t.string :service, null: false
      t.boolean :locked
    end
  end
end

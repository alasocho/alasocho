class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.string :location
      t.string :city
      t.boolean :public
      t.boolean :allow_invites
      t.string :state
      t.integer :attendee_quota
      t.integer :host_id

      t.timestamps
    end
  end
end

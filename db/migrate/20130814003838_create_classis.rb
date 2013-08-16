class CreateClassis < ActiveRecord::Migration
  def change
    create_table :classis do |t|
      t.date :dateof
      t.time :timeof
      t.references :group

      t.timestamps
    end
  end
end

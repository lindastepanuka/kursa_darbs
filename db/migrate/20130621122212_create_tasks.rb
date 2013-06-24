class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :project_id
      t.string :name
      t.string :description
      t.date :due_date
      t.string :state
      t.date :completion_date
      t.integer :priority

      t.timestamps
    end
  end
end

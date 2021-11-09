class CreateMember < ActiveRecord::Migration[5.1]
  def change
    create_table :members do |t|
      t.string :name, null: false
      t.string :personal_website, null: false
      t.string :shortened_url
      t.json :h1
      t.json :h2
      t.json :h3
    end
  end
end

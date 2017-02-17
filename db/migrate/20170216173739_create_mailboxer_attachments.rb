class CreateMailboxerAttachments < ActiveRecord::Migration
  def change
    create_table :mailboxer_attachments do |t|
      t.column :file, :string
      t.references :mailboxer_message, index: true
      t.timestamps
    end
  end
end

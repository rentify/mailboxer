class AddEmailMessageIdToMailboxerAttachment < ActiveRecord::Migration
  def change
    add_column :mailboxer_attachments, :email_message_id, :string
    add_index :mailboxer_attachments, :email_message_id
  end
end

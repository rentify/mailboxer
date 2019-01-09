class AddEmailMessageIdToMailboxerAttachment < ActiveRecord::Migration
  def change
    add_column :mailboxer_notifications, :email_message_id, :string
    add_index :mailboxer_notifications, :email_message_id
  end
end

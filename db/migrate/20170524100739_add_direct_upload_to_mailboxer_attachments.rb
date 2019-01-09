class AddDirectUploadToMailboxerAttachments < ActiveRecord::Migration
  def change
    add_column :mailboxer_attachments, :direct_upload, :boolean, default: false
  end
end

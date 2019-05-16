module Mailboxer
  class Attachment < ActiveRecord::Base
    self.table_name = :mailboxer_attachments
    belongs_to :mailboxer_message, class_name: 'Mailboxer::Message'
    mount_uploader :file, -> { Mailboxer.attachment_uploader || ::Mailboxer::AttachmentUploader }.call
  end
end

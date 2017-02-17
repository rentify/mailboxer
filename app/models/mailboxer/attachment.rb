module Mailboxer
  class Attachment < ActiveRecord::Base
    self.table_name = :mailboxer_attachments
    belongs_to :mailboxer_message, class_name: Mailboxer::Message
    mount_uploader :attachment, Mailboxer.attachment_uploader
  end
end

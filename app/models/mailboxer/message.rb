class Mailboxer::Message < Mailboxer::Notification
  attr_accessible :attachment if Mailboxer.protected_attributes?
  self.table_name = :mailboxer_notifications

  has_many :attachments, autosave: true, foreign_key: :mailboxer_message_id
  belongs_to :conversation, :validate => true, :autosave => true
  validates_presence_of :sender

  class_attribute :on_deliver_callback
  protected :on_deliver_callback
  scope :conversation, lambda { |conversation|
    where(:conversation_id => conversation.id)
  }

  class << self
    #Sets the on deliver callback method.
    def on_deliver(callback_method)
      self.on_deliver_callback = callback_method
    end
  end

  def attachment=(files)
    files = [files] unless files.is_a?(Array)

    files.each do |file|
      if file.is_a?(String) && defined?(CarrierWaveDirect::Uploader)
        attachments.new(key: file, direct_upload: true)
      else
        attachments.new(file: file)
      end
    end
  end

  #Delivers a Message. USE NOT RECOMENDED.
  #Use Mailboxer::Models::Message.send_message instead.
  def deliver(reply = false, should_clean = true)
    self.clean if should_clean

    #Receiver receipts
    receiver_receipts = recipients.map do |r|
      receipts.build(receiver: r, mailbox_type: 'inbox', is_read: false)
    end

    #Sender receipt
    sender_receipt =
      receipts.build(receiver: sender, mailbox_type: 'sentbox', is_read: true)

    if valid?
      save!
      Mailboxer::MailDispatcher.new(self, receiver_receipts).call

      conversation.touch if reply

      self.recipients = nil

      on_deliver_callback.call(self) if on_deliver_callback
    end
    sender_receipt
  end
end

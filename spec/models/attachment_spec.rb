require 'spec_helper'

describe Mailboxer::Attachment do
  it { should belong_to(:mailboxer_message) }
end

#
# Unit tests for Conversation model
#

RSpec.describe Conversation do
  it 'has a valid factory' do
    expect(create(:conversation)).to be_valid
  end

  it 'has a valid soft factory' do
    expect(build(:conversation)).to be_valid
  end

  describe 'methods' do
    let!(:conversation) { build(:conversation) }

    it '#mark_as_deleted' do
      conversation.mark_as_deleted(conversation.from)
      expect(conversation.deleted_from).to be_truthy

      conversation.mark_as_deleted(conversation.to)
      expect(conversation.deleted_to).to be_truthy
    end

    it '#deleted_by_both' do
      expect(conversation.deleted_by_both?).to be_falsey
      conversation.mark_as_deleted(conversation.from)
      conversation.mark_as_deleted(conversation.to)
      expect(conversation.deleted_by_both?).to be_truthy
    end
  end
end

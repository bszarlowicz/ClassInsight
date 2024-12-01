class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  after_commit :broadcast_message

  private

  def broadcast_message
    broadcast_append_to(
      "conversation_#{conversation.id}",
      target: "messages",
      partial: "messages/message",
      locals: { message: self }
    )
  end

end
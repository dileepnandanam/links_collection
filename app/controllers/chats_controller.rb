class ChatsController < ApplicationController
  def create
    @user = User.find(chat_params[:reciver_id])
    @chat = Chat.new(chat_params.merge(sender_id: current_user.id))
    
    if @chat.save
      ApplicationCable::ChatNotificationsChannel.broadcast_to(
        @user,
        chat: render_to_string(:partial => 'chat', locals: {chat: reverse(@chat)}, format: :html),
        sender_id: current_user.id,
        ack_url: ''
      )
      render 'create', layout: false
    else
      render text: 'chat has no body', status: 422, content_type: 'text/plain'
    end
  end

  def seen
  	@chat = Chat.find(params[:id])
  	@chat.update(seen: true)
  	render 'seen'
  end

  layout 'network'

  protected

  def reverse(chat)
  	reverse_chat = chat.dup
  	reverse_chat.sender_id = chat.reciver_id
  	reverse_chat.reciver_id = chat.sender_id
  	reverse_chat
  end

  def chat_params
  	params.require(:chat).permit(:text, :reciver_id)
  end
end
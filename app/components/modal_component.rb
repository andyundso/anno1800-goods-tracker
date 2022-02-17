class ModalComponent < ViewComponent::Base
  include Turbo::Streams::Broadcasts
  include Turbo::Streams::StreamName
  include Turbo::FramesHelper

  def initialize(title:)
    @title = title
  end
end

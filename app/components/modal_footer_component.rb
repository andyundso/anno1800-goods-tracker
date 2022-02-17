class ModalFooterComponent < ViewComponent::Base
  def initialize(path: nil, modal: true)
    @path = path
    @modal = modal
  end
end

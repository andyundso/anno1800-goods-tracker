require_relative "seeds/goods"
require_relative "seeds/regions"

# rubocop:disable Style/MixinUsage
include Seeds::Goods
include Seeds::Regions
# rubocop:enable Style/MixinUsage

def seed!(data:, model:)
  data.each do |seed|
    Rails.logger.debug { "Creating #{seed[:name_en]} ..." }

    record = model.i18n.find_by(name: seed[:name_de]) || model.new

    record.name_en = seed[:name_en]
    record.name_de = seed[:name_de]
    record.save!

    next if record.reload.icon.attached?

    url = URI.parse(seed[:url_to_image])
    filename = File.basename(url.path)
    file = url.open

    record.icon.attach(io: file, filename: filename)
    record.save!

    raise unless record.icon.attached?

    file.close
  end
end

seed!(data: GOODS, model: Good)
seed!(data: REGIONS, model: Region)

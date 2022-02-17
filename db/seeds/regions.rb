REGIONS = [
  {
    name_de: "Alte Welt",
    name_en: "Old World",
    url_to_image: "https://static.wikia.nocookie.net/anno1800/images/a/a7/Icon_session_moderate_0.png"
  }, {
    name_de: "Neue Welt",
    name_en: "New World",
    url_to_image: "https://static.wikia.nocookie.net/anno1800/images/a/a2/Icon_session_southamerica_0.png"
  }, {
    name_de: "Kap Trelawney",
    name_en: "Cape Trelawney",
    url_to_image: "https://static.wikia.nocookie.net/anno1800/images/8/8e/Icon_session_sunken_treasure.png"
  }, {
    name_de: "Arktis",
    name_en: "The Arctic",
    url_to_image: "https://static.wikia.nocookie.net/anno1800/images/7/7f/Icon_session_passage_0.png"
  }, {
    name_de: "Enbesa",
    name_en: "Enbesa",
    url_to_image: "https://static.wikia.nocookie.net/anno1800/images/1/1f/Icon_session_land_of_lions_0.png"
  }
]

module Seeds
  class Regions
    def self.seed!
      REGIONS.each do |seed|
        Rails.logger.debug { "Creating #{seed[:name_en]} ..." }

        region = Region.i18n.find_by(name: seed[:name_en]) || Region.new

        region.name_en = seed[:name_en]
        region.name_de = seed[:name_de]
        region.save!

        next unless region.reload.avatar.attached?

        url = URI.parse(seed[:url_to_image])
        filename = File.basename(url.path)
        file = url.open

        region.avatar.attach(io: file, filename: filename)
        region.save!

        raise unless region.avatar.attached?

        file.close
      end
    end
  end
end

class Engine < ApplicationRecord
    has_many :taggings, dependent: :delete_all
    has_many :tags, through: :taggings
    belongs_to :room, optional: true
    belongs_to :company
    has_rich_text :description

    def self.tagged_with(name)
        Tag.find_by!(name: name).engines
    end

    def self.tag_counts
        Tag.select('tags.*, count(taggings.tag_id) as count').joins(:taggings).group('taggings.tag_id')
    end

    def tag_list
        tags.map(&:name).join(', ')
    end

    def tag_list=(names)
        self.tags = names.split(',').map do |n|
          Tag.where(name: n.strip).first_or_create!
        end
    end


    def self.roomed_with(name)
        Room.find_by!(name: name).engines
    end

    def room_list
        rooms.map(&:name).join(', ')
    end

    def room_list=(names)
        self.rooms = names.split(',').map do |n|
          Room.where(name: n.strip).first_or_create!
        end
    end
end

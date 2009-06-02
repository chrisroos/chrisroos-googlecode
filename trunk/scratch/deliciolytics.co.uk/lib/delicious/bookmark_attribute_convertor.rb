module Delicious
  class BookmarkAttributeConvertor
    def self.convert(delicious_bookmark_attributes)
      {
        'username'      => delicious_bookmark_attributes['a'],
        'title'         => delicious_bookmark_attributes['d'],
        'notes'         => delicious_bookmark_attributes['n'],
        'tags'          => delicious_bookmark_attributes['t'],
        'bookmarked_at' => DateTime.parse(delicious_bookmark_attributes['dt'])
      }
    end
  end
end
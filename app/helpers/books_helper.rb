module BooksHelper
    def genre_emoji(genre)
      case genre
      when "Fantasy" then "🐦‍🔥🗡️🏞️"
      when "Scifi" then "🛰️🧬🪐"
      when "Historical Fiction" then "🏺📜"
      when "Mystery" then "🕵️‍♂️🔍"
      when "Thriller" then "🩸💀🔪"
      when "Romance" then "❤️💌"
      when "Horror" then "👻🩸"
      when "Fiction" then "👤📖"
      when "Self-Help" then "💡📝"
      else "📘"
      end
    end
end

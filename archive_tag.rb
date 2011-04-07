module Jekyll
  class RenderArchivesTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      posts = context.registers[:site].posts
      posts.sort!
      @collated_posts = {}
      posts.each do |post|
        @collated_posts[post.date.year] ||= []
        @collated_posts[post.date.year][post.date.month] ||= []
        @collated_posts[post.date.year][post.date.month] << post
      end

      output = ""
      @collated_posts.each do |k,v|
        output += "<div class='archive_year'>#{k}</div>"
        months = v.reverse
        months.each_with_index do |m, idx|
          unless m.nil?
            posts = m.reverse
            output += "<div class='archive_month'>#{Date::MONTHNAMES[posts[0].date.month]}</div>"
            posts.each do |p|
              output += "<ul>"
              output += "<li class='archive_title'>"
              output += "<span class='archive_day'>#{p.date.day.to_s}</span>"
              output += " <a href='#{p.url}'>#{p.data["title"]}</a></li>"
              output += "</ul>"
            end
          end
        end
      end
      return output
    end

  end
end

Liquid::Template.register_tag('render_archives', Jekyll::RenderArchivesTag)

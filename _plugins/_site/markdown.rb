require 'rdiscount'
require 'nokogiri'
require 'albino'

module Jekyll
  class MarkdownConverter < Converter
    safe true

    priority :high

    def matches(ext)
      ext =~ /md/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      html = RDiscount.new(content).to_html
      doc = Nokogiri::HTML(html)
      doc.css('pre > code').each do |code_node|
        code_content = code_node.children[0].content

        lines = code_content.lines.to_a.collect(&:strip)

        code_node.content = Albino.colorize(code_content, 'js')

        #if lines[0].start_with? 'lang:'
        #  lang = lines[0].split(':')[1].to_sym
        #  code = lines[2..-1].join
        #  colorized_html = Albino.colorize(code, lang)
        #  code_node.parent.replace(colorized_html)
        #end
      end

      doc.to_html
    end
  end
end

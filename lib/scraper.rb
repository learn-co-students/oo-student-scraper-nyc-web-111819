require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  def self.scrape_index_page(index_url)
    html = open(index_url)
    page = Nokogiri::HTML(html)
    students = []

    page.css(".student-card").each do |student| 
      students.push({
        name: student.css(".student-name").text,
        location: student.css(".student-location").text,
        profile_url: student.css("a").attribute("href").value
      })
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    page = Nokogiri::HTML(html)
    student = {}
  
    links = page.css(".social-icon-container a").map { |link| link.attribute("href").value}
    links.each do |link| 
      # binding.pry
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end

    student[:profile_quote] = page.css(".profile-quote").text if page.css(".profile-quote")
    student[:bio] = page.css("div.bio-content.content-holder div.description-holder p").text if page.css("div.bio-content.content-holder div.description-holder p")

    student
  end

end

Scraper.scrape_profile_page("https://learn-co-curriculum.github.io/student-scraper-test-page/students/zach-newburgh.html")
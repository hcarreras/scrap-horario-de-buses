class RoutesController < ApplicationController
  def index
    agent = Mechanize.new
    form_page = agent.get("http://horariodebuses.com/ES/pa/index.php?fromClass=#{params[:from]}&toClass=#{params[:to]}")
    timetables_page = form_page.form("form1").click_button

    render inline: timetables_page.search("#inhalt").to_html
  end
end

class RoutesController < ApplicationController
  def index
    agent = Mechanize.new
    form_page = agent.get("http://horariodebuses.com/ES/pa/index.php?fromClass=#{params[:from]}&toClass=#{params[:to]}")
    timetables_page = form_page.form("form1").click_button

    info = timetables_page.search("#inhalt")

    # Each table contains a trip
    tables = info.search("> table")[1].search("> tr > td > table")[1..-1]

    trips = tables.map do |table|
      data = table.search("table")
      from_data = data.search("> tr")[0].search("td")
      to_data = data.search("> tr")[1].search("td")

      departure_date = from_data[3].text
      departure_time = from_data[5].text
      arrival_date = to_data[3].text
      arrival_time = to_data[5].text

      departure_at = DateTime.parse(departure_date + departure_time)
      arrival_at = DateTime.parse(arrival_date + arrival_time)

      Trip.new(
        from: from_data[1].text.strip,
        to: to_data[1].text.strip,
        departure_at: departure_at,
        arrival_at: arrival_at
      )
    end

    render json: trips
  end
end

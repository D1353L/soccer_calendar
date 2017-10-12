class LoadDataFromSportradarService
  include HTTParty

  base_uri 'https://api.sportradar.us/soccer-xt3/eu/en/schedules'
  default_params api_key: '5ugpasdtdz72ybfwqh84dzrt'

  def initialize(params)
    @date = Date.parse(params[:date])
  end

  def self.perform(params)
    new(params).perform
  end

  def perform
    resource = @date < Date.today ? 'results' : 'schedule'
    response = self.class.get "/#{@date}/#{resource}.json"

    return response.parsed_response unless response.success?
    push_to_db(response.parsed_response)
    true
  end

  private

  def push_to_db(parsed_response)
    (
      parsed_response['sport_events'] || parsed_response['results']
    ).each do |event|
      handle_event(event)
    end
  end

  def handle_event(event)
    event_status = event['sport_event_status'] if event['sport_event_status']
    event = event['sport_event'] if event['sport_event']
    match = resolve_match(event['id'], event['scheduled'])

    event['competitors'].each do |competitor|
      team = get_team(competitor)

      if event_status
        goals_count = parse_goals_count(event_status, competitor['qualifier'])
      end
      Score.create(match: match, team: team, goals_count: goals_count)
    end
  end

  def resolve_match(identifier, date_time)
    update_match(get_match(identifier), date_time) ||
      Match.create(date_time: date_time, identifier: identifier)
  end

  def get_match(identifier)
    Match.find_by_identifier(identifier)
  end

  def update_match(match, date_time)
    dt = DateTime.strptime(date_time, '%Y-%m-%dT%H:%M:%S%z')

    if match
      match.scores.destroy_all
      match.update_attributes(date_time: dt) if match.date_time != dt
    end
    match
  end

  def get_team(team_json)
    Team.find_by_name(team_json['name']) ||
      Team.create(name: team_json['name'],
                  country_code: team_json['country_code'])
  end

  def parse_goals_count(event_status_json, qualifier)
    event_status_json["#{qualifier}_score"].to_i
  end
end

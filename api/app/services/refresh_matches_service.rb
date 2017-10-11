class RefreshMatchesService
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
    (parsed_response['sport_events'] ||
      parsed_response['results']).each do |event|
      event = event['sport_event'] if event['sport_event']
      handle_event(event)
    end
  end

  def handle_event(event)
    match = resolve_match(event['id'], event['scheduled'])

    event['competitors'].each do |competitor|
      team = get_team(competitor)
      if event['event_status_json']
        goals = parse_goals_count(event['event_status_json'],
                                  competitor['qualifier'])
      end
      Score.create(match: match, team: team, goals_count: goals)
    end
  end

  def resolve_match(identifier, date_time)
    update_match(get_match(identifier), date_time) ||
      create_match(identifier, date_time)
  end

  def get_match(identifier)
    Match.find_by_identifier(identifier)
  end

  def create_match(identifier, date_time)
    Match.create(date_time: date_time, identifier: identifier)
  end

  def update_match(match, date_time)
    dt = DateTime.strptime(date_time, '%Y-%m-%dT%H:%M:%S%z')

    match.update_attributes(date_time: dt) if match && match.date_time != dt
    match
  end

  def get_team(team_json)
    Team.find_by_name(team_json['name']) ||
      Team.create(name: team_json['name'],
                  country_code: team_json['country_code'])
  end

  def parse_goals_count(event_status_json, qualifier)
    event_status_json["#{qualifier}_score"]
  end
end

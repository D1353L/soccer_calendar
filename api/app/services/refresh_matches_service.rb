class RefreshMatchesService
  include HTTParty

  base_uri 'https://api.sportradar.us/soccer-xt3/eu/en/schedules'
  default_params api_key: '5ugpasdtdz72ybfwqh84dzrt'

  def initialize(params)
    @matches = []
    @date = Date.parse(params[:date])
  end

  def self.perform(params)
    new(params).perform
  end

  def perform
    resource = @date < Date.today ? 'results' : 'schedule'
    response = self.class.get "/#{@date}/#{resource}.json"

    raise response.parsed_response unless response.success?
    push_to_db(response.parsed_response)
    @matches
  end

  private

  def push_to_db(unparsed_json)
    parsed_json = ActiveSupport::JSON.decode(unparsed_json)

    parsed_json['results'].each do |result|
      @matches << match = create_match(result['sport_event']['scheduled'])

      result['competitors'].each do |competitor|
        team = get_team(competitor)
        goals = parse_goals_count(result['event_status_json'],
                                  competitor['qualifier'])
        Score.create(match: match, team: team, goals_count: goals)
      end
    end
  end

  def create_match(date_time)
    Match.create(date_time:
      DateTime.strptime(date_time, '%Y-%m-%dT%H:%M:%S%z'))
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

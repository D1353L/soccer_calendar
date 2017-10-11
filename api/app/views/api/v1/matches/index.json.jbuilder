json.array!(@matches) do |match|
  json.extract! match, :id, :identifier, :date_time
  json.scores do
    json.array!(match.scores) do |score|
      json.team score.team.name
      json.goals_count score.goals_count
    end
  end
end

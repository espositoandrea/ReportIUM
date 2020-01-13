# frozen_string_literal: true

def nps(ratings)
  out = {}

  out[:promoters] = (ratings.count { |x| (x > 8) && (x < 11) } * 100.to_f / ratings.size).round(2)
  out[:neutrals] = (ratings.count { |x| (x > 6) && (x < 9) } * 100.to_f / ratings.size).round(2)
  out[:detractors] = (ratings.count { |x| (x >= 1) && (x < 7) } * 100.to_f / ratings.size).round(2)
  out[:score] = (out[:promoters] - out[:detractors]).round
  out[:number_of_surveys] = ratings.size

  out
end

def sus(ratings, code = nil)
  out = {}
  ratings = ratings.drop 8
  ratings.map!(&:value)
  ratings[10] = (Time.mktime(0) + ratings[10]).strftime('%H:%M')
  ratings[11] = (Time.mktime(0) + ratings[11]).strftime('%H:%M')

  out[:code] = code

  out[:answers] = ratings.slice(0, (ratings.size - 2)).map(&:to_i)
  out[:results] = out[:answers].each_with_index.map { |x, i| i.even? ? (x - 1) : (5 - x) }

  out[:total] = out[:results].sum * 2.5

  out[:beginning] = ratings[10]
  out[:ending] = ratings[11]

  out
end

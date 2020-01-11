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

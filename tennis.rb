class Match

  # Pointless commit for code review

  # Map points to tennis scores
  SCORES = {
    0 => 0,
    1 => 15,
    2 => 30,
    3 => 40
  }

  def initialize()
    @games = {
      player_one: 0,
      player_two: 0
    }

    @scores = {
      player_one: 0,
      player_two: 0
    }
    SCORES.freeze

    # Validators
    @game_validator = lambda { |x, y| return x > 3 && (x - y >= 2) }
    @tie_break_validator = lambda { |x, y| return x > 6  && (x - y >= 2) }
    @deuce_validator = lambda { |x, y| return  x == y && x >= 3 }
    @advantage_validator = lambda { |x, y| return  x >= 3 && y >= 3 && x - y == 1 }
    @set_validator = lambda { |x,  y| return ((x == 7 && y == 6) || (x > 5 && (x - y >= 2))) }
  end

  # PUBLIC METHODS

  def point_won_by(player)
    player == 1 ? @scores[:player_one] += 1 : @scores[:player_two] += 1

    # Reset game to initial values if game is won
    if (is_game_won? || is_set_won?)
      reset_game
    end
  end

  def score
    puts score_to_display
  end

  # PRIVATE METHODS
  private

  def score_to_display
    player_one_score = @scores[:player_one]
    player_two_score = @scores[:player_two]

    if is_tie_break?
      score = "#{player_one_score} - #{player_two_score}"
    else
      score = "#{SCORES[player_one_score]} - #{SCORES[player_two_score]}"

      if is_deuce?
        score = "Deuce"
      elsif is_advantage?(player_one_score, player_two_score)
          score = "Advantage Player One"
      elsif is_advantage?(player_two_score, player_one_score)
        score = "Advantage Player Two"
      end
    end

    return "#{@games[:player_one]} - #{@games[:player_two]}, #{score}"
  end

  def is_game_won?
    is_tie_break? == true ? validate_tie_break : validate_standard_game
  end

  def is_deuce?
    return game_validator(@scores[:player_one], @scores[:player_two], &@deuce_validator)
  end

  def is_advantage?(score_a, score_b)
     return game_validator(score_a, score_b, &@advantage_validator)
  end

  def validate_standard_game
    if game_validator(@scores[:player_one], @scores[:player_two], &@game_validator)
      @games[:player_one] += 1
      return true
    elsif game_validator(@scores[:player_two], @scores[:player_one], &@game_validator)
      @games[:player_two] += 1
      return true
    end

    return false
  end

  def validate_tie_break
    if game_validator(@scores[:player_one], @scores[:player_two], &@tie_break_validator)
      @games[:player_one] += 1
      return true
    elsif game_validator(@scores[:player_two], @scores[:player_one], &@tie_break_validator)
      @games[:player_two] += 1
      return true
    end

    return false
  end

  def game_validator(x, y, &validator)
    return validator.call(x, y)
  end

  def is_set_won?
    # Check if player one or player two won the set
    return (game_validator(@scores[:player_one], @scores[:player_two], &@set_validator) || game_validator(@scores[:player_two], @scores[:player_one], &@set_validator))
  end

  def is_tie_break?
    return @games[:player_one] == 6 && @games[:player_two] == 6 ? true : false
  end

  def reset_game
    @scores[:player_one] = 0
    @scores[:player_two] = 0
  end

end

begin
  match = Match.new

  match.point_won_by(1)
  match.point_won_by(1)
  match.point_won_by(1)

  match.point_won_by(2)
  match.point_won_by(2)
  match.point_won_by(2)
  match.point_won_by(2)

  match.score
end

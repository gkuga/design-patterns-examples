# frozen_string_literal: true

# State (abstract)
class State
  def play(player)  = raise NotImplementedError
  def pause(player) = raise NotImplementedError
  def stop(player)  = raise NotImplementedError
end

# ConcreteState: Stopped
class StoppedState < State
  def play(player)
    puts '▶ start playing'
    player.state = PlayingState.new
  end

  def pause(_player)
    puts '… cannot pause while stopped'
  end

  def stop(_player)
    puts '… already stopped'
  end
end

# ConcreteState: Playing
class PlayingState < State
  def play(_player)
    puts '… already playing'
  end

  def pause(player)
    puts '⏸ pause'
    player.state = PausedState.new
  end

  def stop(player)
    puts '⏹ stop playing'
    player.state = StoppedState.new
  end
end

# ConcreteState: Paused
class PausedState < State
  def play(player)
    puts '▶ resume playing'
    player.state = PlayingState.new
  end

  def pause(_player)
    puts '… already paused'
  end

  def stop(player)
    puts '⏹ stop'
    player.state = StoppedState.new
  end
end

# Context: holds the current state and delegates operations to it.
class Player
  attr_accessor :state

  def initialize
    @state = StoppedState.new
  end

  def play  = @state.play(self)
  def pause = @state.pause(self)
  def stop  = @state.stop(self)
end

if __FILE__ == $PROGRAM_NAME
  player = Player.new
  player.play   # Stopped -> Playing
  player.play   # stays Playing
  player.pause  # Playing -> Paused
  player.play   # Paused  -> Playing
  player.stop   # Playing -> Stopped
  player.pause  # stays Stopped
end

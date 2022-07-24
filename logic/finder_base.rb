class FinderBase
  def initialize(noise_level_threshold)
    @noise_level_threshold = noise_level_threshold
  end

  protected

  attr_reader :noise_level_threshold

  def calculate_noise_level(radar_signal, invader_signal)
    if radar_signal != invader_signal
      1
    else
      0
    end
  end
end


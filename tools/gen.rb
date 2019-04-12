require 'securerandom'
require 'erb'
require 'set'

class Target
  def initialize(rule, name, deps)
    @rule = rule
    @name = name
    @deps = deps
  end

  TEMPLATE = File.read("tools/target.erb")

  def self.renderer
    @erb ||= ERB.new(TEMPLATE, safe_level=nil, trim_mode=?-)
  end

  def render
    self.class.renderer.result(binding)
  end

  class Builder
    attr_reader :name, :rule, :deps

    def initialize
      @deps = []
    end

    def set_rule(rule)
      @rule = rule
      self
    end

    def set_name(name)
      @name = name
      self
    end

    def add_dep(dep)
      @deps << dep
      self
    end

    def build
      Target.new(@rule, @name, @deps)
    end
  end
end

class Package
  def initialize(targets)
    @targets = targets
  end

  TEMPLATE = File.read("tools/package.erb")

  def self.renderer
    @erb ||= ERB.new(TEMPLATE, safe_level=nil, trim_mode=?-)
  end

  def run
    self.class.renderer.run(binding)
  end

  class Builder
    def initialize
      @target_builders = []
    end

    def add_target_builder
      target_builder = Target::Builder.new
      @target_builders << target_builder
      target_builder
    end

    def build
      Package.new(@target_builders.map(&:build))
    end
  end
end

class LinearNoise
  include Enumerable

  def initialize(shift)
    @shift = shift
    @keypoints = Array.new((1 << @shift) + 1, 0)
    generate
  end

  def size
    1 << @shift
  end

  def each(&block)
    @keypoints.each(&block)
  end

  def sum
    @keypoints.inject(0) { |v, point| v += point; v }
  end

  private

  def generate
    @keypoints[0] = rand
    @keypoints[1 << @shift] = rand

    generate_at(1 << (@shift - 1), 1 << (@shift - 1), 1.0)

    @keypoints.pop
  end

  def generate_at(at, length, scale)
    while length > 0
      x = (rand - 0.5) * 2.0 * scale
      v = (@keypoints[at - length] + @keypoints[at + length]).abs / 2.0 + x
      @keypoints[at] = v < 0 ? 0 : v > 1.0 ? 1.0 : v
      if length >= 2
        generate_at(at - length / 2, length / 2, scale / 2)
      end
      length /= 2
      at += length
      scale /= 2
    end
  end
end

shift = ARGV[0].to_i
desired_actions = ARGV[1].to_i

noise = LinearNoise.new(shift)

noise_factor = ((desired_actions - noise.size) / noise.sum)

package_builder = Package::Builder.new

levels = noise.map do |point|
  width = (noise_factor * point).round + 1
  Array.new(width) do
    package_builder.add_target_builder
      .set_rule("remote_ex_rule")
      .set_name(SecureRandom.hex)
  end
end

levels.each_with_index do |level, i|
  next if i == 0
  level.each do |target_builder|
    target_builder.add_dep(":" + levels[i - 1].sample.name)
  end
end

package_builder.build.run

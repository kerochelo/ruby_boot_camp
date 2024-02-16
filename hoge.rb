class Charactor
  attr_accessor :name, :lives, :max_lives, :attack, :defense, :speed
  
  OVER_KILL_DAMEGE = 9999

  def initialize(name, lives = 100, attack = 10, defense = 10, speed = 10)
    @name = name
    @lives = lives
    @max_lives = lives
    @attack = attack
    @defense = defense
    @speed = speed
  end

  def take_damege(damege)
    damege -= @defense
    if damege < 0
      damege = rand(10) == 1 ? 100 : 0
    end
    @lives -= damege
    @lives = 0 if @lives < 0
    damege
  end

  def attack_to(target)
    damege = rand(@attack * 0.8..@attack * 1.5).round
    real_damege = target.take_damege(damege)
    puts "【#{@name} => #{target.name}】 #{target.name} takes #{real_damege} damege (HP:#{target.lives})"
  end

  def recover_health(amount)
    @lives += amount
    @lives = @max_lives if @lives > @max_lives
    puts "#{@name} recovers #{amount} health points (HP:#{@lives})"
  end

  def increase_defense(amount)
    @defense += amount
    puts "#{@name} increases defense by #{amount} points!"
  end

  def destruction(target)
    @lives = 1
    target.take_damege(OVER_KILL_DAMEGE)
    puts "#{@name} uses destruction to #{target}"
  end
end

class Hero < Charactor
  def initialize
    super("Hero", 300, 30, 30, 30)
  end
end

class Heroine < Charactor
  def initialize
    super("Heroine", 250, 10, 30, 50)
  end

  def attack_to(target)
    if rand(3) == 0
      recover_health(20)
    else
      super
    end
  end
end

class Villain < Charactor
  def initialize
    super("Villain", 400, 40, 20, 20)
  end
end

class Servant < Charactor
  def initialize
    super("Servant")
  end

  def attack_to(target)
    if rand(3) == 0
      increase_defense(10)
    else
      super
    end
  end
end
  
class Monster < Charactor
  def initialize
    rand_lives = rand(100..300)
    rand_attack = rand(15..25)
    rand_defense = rand(10..20)
    rand_speed = rand(10..30)
    super("Monster", rand_lives, rand_attack, rand_defense, rand_speed)
  end

  def attack_to(target)
    if rand(100) == 5
      destruction(target)
    else
      super
    end
  end
end
  
class Boss < Charactor
  def initialize
    super("Boss", 500, 50, 20, 20)
  end
end

class Battle
  attr_accessor :characters

  CHARACTERS_CLASSES = [Hero, Heroine, Villain, Servant, Monster, Boss]

  def initialize
    @characters = CHARACTERS_CLASSES.map(&:new)
  end

  def start
    turn = 0
    chara_first, chara_second = @characters.sample(2).sort_by(&:speed)

    sleep 1
    puts "#{chara_first.name} vs #{chara_second.name}"
    sleep 1
    puts "#{chara_first.name} has #{chara_first.lives}."
    puts "#{chara_second.name} has #{chara_second.lives}."
    sleep 1

    while chara_first.lives > 0 && chara_second.lives > 0
      turn += 1
      puts "Turn #{turn}"
      sleep 2
      chara_first.attack_to(chara_second)
      break if chara_second.lives <= 0

      sleep 2
      chara_second.attack_to(chara_first)

      break if turn > 19
    end

    if turn > 19
      run_away_name = chara_first.lives > chara_second.lives ? chara_second.name : chara_first.name
      puts "==================="
      puts "#{run_away_name} run away!"
    else
      winner_name = chara_first.lives > 0 ? chara_first.name : chara_second.name

      puts "==================="
      puts "#{winner_name} wins!"
    end
  end
end

Battle.new.start

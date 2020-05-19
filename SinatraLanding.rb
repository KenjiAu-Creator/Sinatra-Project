require 'sinatra'
require_relative './Caesar/caesar.rb'
require_relative './MasterMind/masterMind.rb'
require 'sinatra/reloader'
require "sinatra/cookies"

enable :sessions

get '/' do
  erb :index
end

get '/caesar' do
  caesarClass = Caesar.new()
  message = params[:encrypt]
  inputShift = params[:shift].to_i
  if !message.nil? && !inputShift.nil?
    encryptMessage = caesarClass.caesar_cipher(message, inputShift)
  end
  erb :caesar, :locals => {:message => encryptMessage}
end

=begin
  The MasterMind code begins here
=end

def store_guess(filename, string)
  File.open(filename, "w+") do |file|
    file.puts(string)
  end
end

def read_guess
  File.read("playerGuess.txt")
end

def reset_guess(filename)
  File.open(filename, "w+") do |file|
    file.puts "{}"
  end
end

def store_code(filename, string)
  File.open(filename, "w+") do |file|
    file.puts(string)
  end
end

def read_code
  File.read("code.txt").split("\n")
end

def updateGuessHash(guess)
  hashString = File.read("playerGuess.txt")
  hash = eval(hashString)
  
  if hash.nil?
    hash = {}
  end

  guessCount = hash.count + 1
  hash[guessCount] = guess
  store_guess("playerGuess.txt", hash)

  return hash
end


def getGuessHash
  hashString = File.read("playerGuess.txt")
  hash = eval(hashString)
end

masterMind = MasterMind.new()

get '/masterMind' do
  @message = cookies[:message]
  one = params[:one]
  two = params[:two]
  three = params[:three]
  four = params[:four]

  @hash = getGuessHash()

  erb :masterMind
end


post "/masterMind" do
  one = params[:one].downcase.capitalize
  two = params[:two].downcase.capitalize
  three = params[:three].downcase.capitalize
  four = params[:four].downcase.capitalize
  playerGuess = [one, two, three, four]
  
  @computerCode = cookies[:computerCode]
  @hintString = cookies[:hintString]

  if @computerCode.nil?
    @computerCode = masterMind.get_random_choice
    cookies[:computerCode] = @computerCode
  else
    @computerCode = @computerCode.split("&")
  end

  if (!playerGuess.include? nil)
    masterMind.code_compare2(playerGuess, @computerCode)
    @hash = updateGuessHash(playerGuess)
    @hint = masterMind.hints?
    gameOver = masterMind.win_condition

    if @hintString.nil?
      @hintString = ""
      @hint.each do |color|
        @hintString.concat(color).concat(",") 
      end
    else
      @hint.each do |color|
        @hintString.concat(color).concat(",")
      end
    end
  
    if getGuessHash().count >= 8
      @computerCode = masterMind.get_random_choice
      cookies[:computerCode] = @computerCode
      reset_guess("playerGuess.txt")
      @message = "Out of guesses! A new code has been set."
      @hintString = ""
    end

    if gameOver == true
      @message = "You broke the code! You win!"
      reset_guess("playerGuess.txt")
      @hintString = ""
      @computerCode = masterMind.get_random_choice
      cookies[:computerCode] = @computerCode
    else
      @message = "Try again!"
    end
  end

  cookies[:message] = @message
  cookies[:hintString] = @hintString

  redirect "/masterMind?one=#{one}&&two=#{two}&&three=#{three}&&four=#{four}"
end

=begin
Testing website for cookies / sessions
=end

get '/foo' do
  @count = cookies[:count].to_i
  if @count >= 9
    @count = 0
    cookies[:count] = @count
  end

  erb :foo
end

post '/foo' do
  testparam = params[:baa]
  @count = cookies[:count].to_i

  if @count.nil?
    @count = 1
  end

  @count += 1
  cookies[:count] = @count
  cookies[:something] = testparam
  redirect "/foo"
end

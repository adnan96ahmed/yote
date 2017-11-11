#/usr/bin/ruby
require "yaml"
class GameManager

	#done
	def initialize(filename=nil)
		if filename.nil?
			loadGame(filename)
		end
		@currentPlayer = 0
		@players = Array.new(2)
		@players[0] = Player.new(:white)
		@players[1] = Player.new(:black)
		@gameBoard = Board.new(5,6)
	end

	#not done
	def loadGame(filename)

	end

	#not done
	def newGame()
		loop do
			
			@gameBoard.drawBoard(@players[0], @players[1])
			
			ret = @players[@currentPlayer].makeMove(@gameBoard)

			ret = checkGameOver()

			if ret == false
				@currentPlayer = (@currentPlayer + 1) % 2
			else
				# puts("Winning player: #{@currentPlayer}")
				# ret
			end

		end
	end

	#not done
	def saveGame()

	end

	#NOT DONE
	def checkGameOver()
		if @players[0].pieces() <= 3 && @players[1].pieces() <= 3
			return true
		end
		# Check if the next player to move (ie. @players[(@currentPlayer
		# + 1) % 2]) has an available move to make. This is done in a
		# few ways. First, to check for an empty place that a piece can be
		# placed into use Board.pieces(:empty), then you must make sure
		# the Player has a piece they may place by using Player.pieces().
		# If both are not 0, then the player may place a piece. To check
		# if the player has any pieces on the board they may move, use
		# the Board.availableMove() function. This will return true or
		# false based on if the Player has a move to make. If both of these
		# conditions outlined are false, then the Player has no moves to make
		# and the game is over
	end

	#done
	def to_s()
		"In GameManager:\n #{@currentPlayer} #{@players[0].to_s} #{@players[1].to_s}\n"
	end

	#NOT DONE
	def forfeit(colour)

	end
end

class Hand

	#done
	def initialize(playerColour)
		@playerColour = playerColour
		@pieceCount = 12
	end

	#done
	def empty()
		return @pieceCount == 0
	end

	#done
	def removePiece()
		result = empty()

		if result == true
			return false
		end

		@pieceCount = @pieceCount - 1
		return true
	end

	#done
	def to_s()
		"In Hand:\n #{@playerColour} #{@pieceCount}\n" 
	end

	#done
	def pieces()
		return @pieceCount
	end


end

class YoteIO

	#NOT done
	def serializeGame(game, filename)

	end

	#NOT done
	def unserializeGame(filename)

	end

	#done
	def getCoordinates(prompt)
		puts prompt
		res = 0
		input = gets.chomp
		if input.eql? 'forfeit'
			return [-1, -1]
		elsif input.eql? 'save'
			return [-2, -2]
		else
			coord_y = Hash.new()
			coord_y["a"] = 0
			coord_y["b"] = 1
			coord_y["c"] = 2
			coord_y["d"] = 3
			coord_y["e"] = 4

			regex1 = /[1-6]+[a-eA-E]/
			regex2 = /[a-eA-E]+[1-6]/

			if prompt.include? "source"
				# p 20
				if regex1.match(input)
					x = Integer(input[0])-1
					y = coord_y[input[1]]
					res = [x, y]
				elsif regex2.match(input)
					x = Integer(input[1])-1
					y = coord_y[input[0]]
					res = [x, y]
				elsif input.empty?
					res = nil
				end
			else
				if regex1.match(input)
					if /^$/.match(input)
						res = nil
					end
					x = Integer(input[0])-1
					y = coord_y[input[1]]
					res = [x, y]

				elsif regex2.match(input)
					if /^$/.match(input)
						res = nil
					end
					x = Integer(input[1])-1
					y = coord_y[input[0]]
					res = [x, y]
				else
					res = nil
				end
			end
			# puts "coordinates  = #{res}"
			return res
		end

	end

	#done
	def printLine(prompt)
		puts prompt
		puts "\n"
	end

end


class Player

	#done
	def initialize(playerColour)
		@playerHand = Hand.new(playerColour)
		@lastMove = nil
		@playerColour = playerColour
	end

	#working on
	def makeMove(gameBoard)
		io = YoteIO.new()

		res1 = nil
		res2 = nil

		loop do
			res1 = io.getCoordinates("Please enter the source coordinate (leave blank if placing a piece)\n")

			if res1 == [-1, -1]
				puts "forfeit"
				return -1
			elsif res1 == [-2, -2]
				puts "save"
				return -2
			end


			res2 = io.getCoordinates("Please enter the destination coordinate\n")

			if res2 == [-1, -1]
				puts "forfeit"
				return -1
			elsif res2 == [-2, -2]
				puts "save"
				return -2
			end

			if res2 == nil
				io.printLine("Character does not fall within range of a to e or numeric 1 to 6")
				next
			end

			move = Move.new(res1, res2, @playerColour, gameBoard)
			testing = move.validate()

			if testing == false
				io.printLine("Move is illegal.")
				next
			else
				break
			end

			if res1.nil?
				if @playerHand.empty() == true
					next
				end
			end

			if @lastMove != nil
				compare = move.compare(@lastMove)
				if compare == true
					next
				end
			end

			execute = move.execute()

		end

	end

	#done
	def pieces(board)
		return @playerHand.pieces() + board.pieces(@playerColour)
	end

	#done
	def storeLastMove(lastMove)
		@lastMove = lastMove
	end


end


#all done, shouldn't need to touch
class Position

	#done
	def initialize(position)
		@position = position
		@piece = :empty
	end

	#done
	def atPosition()
		return @piece
	end

	#done
	def setPosition(value)
		@piece = value
	end

	#done
	def to_s()
		"In Position: #{@position} #{@piece}\n"
	end

end

class Board

	#done
	def initialize(rows, columns)
		@rows = rows
		@columns = columns
		@board = Array.new(rows){|i|Array.new(columns) {|j| Position.new([i,j])}}
	end

	#done --> doesn't work exactly when trying to call:/
	def atPosition(coord)
		return @board[coord[0]][coord[1]].atPosition()
	end
	
	#done
	def drawBoard(player1, player2)
		io = YoteIO.new()
	    x_coor = 0
		output = "  1 2 3 4 5 6"
		y_axis = ['a', 'b', 'c', 'd', 'e']
	    puts(output)
	    for i in 0..4
	        output = y_axis[i].to_s
	        for j in 0..12
	            if j%2 == 1
	            	if atPosition([i,x_coor]) == :white
	                	output << "*"
	                elsif atPosition([i,x_coor]) == :black
	                	output << "^"
	                else
	                	output << "-"
	                end
	                x_coor = x_coor+1
	            else
	                output << "|"
	            end
	        end
	        x_coor = 0
	        puts(output)
	    end
	    puts("Remaining pieces:")
	    output = "Player 1: " + (player1.pieces(self) - self.pieces(player1.instance_variable_get(:@playerColour))).to_s()
	    output << "\nPlayer 2: " + (player2.pieces(self) - self.pieces(player1.instance_variable_get(:@playerColour))).to_s()
	    io.printLine(output)
	end
	
	#done
	def placeAt(coord, colour)
		if colour == :empty or (coord[0].between?(0..@row) and coord[1].between?(0..@column)) or coord == nil?
			return false
		end
		@board[coord[0]][coord[1]].setPosition(colour)
		return true
	end

	#done
	def removeAt(coord)
		if (coord[0].between?(0..@row) and coord[1].between?(0..@column)) or coord == nil?
			return false
		end
		@board[coord[0]][coord[1]].setPosition(:empty)
		return  true
	end

	#NOT DONE --> always 42
	def pieces(colour)
		count = 0
		0.upto(@rows) do |i|
			0.upto(@columns) do |j|
				count = count + 1
			end
		end
		# p colour
		# p count

		# This code here should work if atPosition is working properly and called right
		# count = 0
		# for i in 0..@rows
		# 	for j in 0..@columns
		# 		if atPosition([i,j]) == colour
		# 			count = count + 1
		# 		end
		# 	end
		# end
		# p colour
		# p count
		return count
	end

	#not done?
	def availableMove(colour)
		0.upto(@rows) do |i|
			0.upto(@columns) do |j|
				if @board[i][j].atPosition() == colour
					temp.push(@board[i][j])
					move = Move.new(@board[i][j].atPosition(), 0, colour, @board)
					val = move.isPossibleMove()
					if val == true
						return true
					end
				end
			end
		end
		return false
	end

	def to_s()
		"In Board:\n #{@rows} #{@columns} #{@board}\n" 
	end

end

class Move

	#done
	def initialize(source, destination, playerColour, gameBoard)
		@source = source
		@destination = destination
		@playerColour = playerColour
		@gameBoard = gameBoard
		@move = nil
	end

	#done
	def compare(lastMove)

		if lastMove.findMoveType() == :illegal or lastMove.findMoveType() == :placement or lastMove.findMoveType() == :capture
			return false
		elsif (lastMove.destination != @source)
			return false
		elsif (lastMove.source == @destination)
			return true
		end

	end

	#done
	def validate()
		@move = findMoveType()

		p @move

		if @move == :illegal
			return false
		end

		return true

	end

	#should be done?
	def isPossibleMove()
		x = @source[0]
		y = @source[1]

		# check positive x coordinate for valid moves
		res1 = @gameBoard.atPosition([x+1,y])
		res2 = @gameBoard.atPosition([x+2,y])
		if res1 == :empty or (res1 != :empty and res2 != @playerColour)
			return true
		end

		# check negative x coordinate for valid moves
		res1 = @gameBoard.atPosition([x-1,y])
		res2 = @gameBoard.atPosition([x-2,y])
		if res1 == :empty or (res1 != :empty and res2 != @playerColour)
			return true
		end

		# check positive y coordinate for valid moves
		res1 = @gameBoard.atPosition([x,y+1])
		res2 = @gameBoard.atPosition([x,y+2])
		if res1 == :empty or (res1 != :empty and res2 != @playerColour)
			return true
		end

		# check negative y coordinate for valid moves
		res1 = @gameBoard.atPosition([x,y-1])
		res2 = @gameBoard.atPosition([x,y-2])
		if res1 == :empty or (res1 != :empty and res2 != @playerColour)
			return true
		end

		return false
	end

	#done
	def to_s()
		"In Move: #{@source} #{@destination} #{@playerColour} #{@move} #{@gameBoard.to_s} \n"
	end

	#done
	def findMoveType()
		x = 0
		y = 1

		# check if its a placement move by simply checking if the source corodinate does not exist
		if @source.nil? and @gameBoard.atPosition(@destination) == :empty
			return :placement
		end

		# check if the move is of type move by checking if there is a coordinate difference of 1.
		if ((@source[0] - @destination[0]).abs == 1 and (@source[1] - @destination[1]).abs == 0) or ((@source[1] - @destination[1]).abs == 1 and (@source[0] - @destination[0]).abs == 0)
			if @gameBoard.atPosition(@source) == @playerColour and @gameBoard.atPosition(@destination) == :empty
				return :move
			else
				return :illegal
			end
		end

		# check if the move is a capture by checking if there is a coordinate difference of 2, then checks if you skipped over a piece
		if ((@source[0] - @destination[0]).abs == 2 and (@source[1] - @destination[1]).abs == 0) or ((@source[1] - @destination[1]).abs == 2 and (@source[0] - @destination[0]).abs == 0)
			if @gameBoard.atPosition(@source) == @playerColour and @gameBoard.atPosition(@destination) == :empty
				jumped = [(@destination[x] + @source[x]) / 2, (@destination[y] + @source[y]) / 2]
				result = (@gameBoard.atPosition(@jumped) != :empty && @gameBoard.atPosition(@jumped) != :playerColour)

				if result == true
					return :capture
				else
					return :illegal
				end
			else
				return :illegal
			end
		end

	end

	#not done (finished up to step 5 in document. Read the rest)
	def execute()
		if @move == :illegal
			return -1
		end

		@gameBoard.placeAt(@destination,@playerColour)

		if @move == :placement
			return 0
		end

		if @move == :movement
			@gameBoard.removeAt(@source)
			return 0
		end

		if @move == :capture
			@gameBoard.removeAt(@source)
			jumped = [(@destination[x] + @source[x]) / 2, (@destination[y] + @source[y]) / 2]
			@gameBoard.removeAt(@jumped)
		end
	end

end

source = [1, 2]
dest = [1, 3]

board = Board.new(5, 6)
move = Move.new(source, dest, "black", board)
blah = YoteIO.new()
manage = GameManager.new()

manage.newGame()





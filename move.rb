#/usr/bin/ruby

class GameManager

	def initialize(filename=nil)
		if filename.nil?
			loadGame(filename)
		end
		@currentPlayer = 0
		players = Array.new(2)
		players[1] = :black 
		players[0] = :white
		gameBoard = Board.new([5,6])
	end
	
	def loadGame(filename)

	end
	
	def newGame()
		loop do
			ret = @players[@currentPlayer].makeMove(@gameBoard)

			# @gameBoard.drawBoard()

			ret = checkGameOver()

			if ret == false
				@currentPlayer = (@currentPlayer + 1) % 2
			else
				break 
			end

		end

		#stuff ehre
	end

	def saveGame()

	end

	def checkGameOver()
		0.upto(2) do |i|
			@players[i].pieces()
		end
	end

	def to_s()

	end

	def forfeit(colour)

	end  
end

class Hand

	def initialize(playerColour)
		@playerColour = playerColour
		@pieceCount = 12
	end

	def empty()
		return @pieceCount == 0
	end

	def removePiece()
		result = empty()

		if result == true
			return false
		end

		@pieceCount = @pieceCount - 1
		return true
	end

	def to_s()

	end

	def getCount()
		return @pieceCount
	end


end

class YoteIO

	def initialize()

	end

	def serializeGame(game, filename)

	end

	def unserializeGame(filename)

	end

	def getCoordinates(prompt)
		puts prompt 
		input = gets

		if input == "forfeit"
			return [-1, -1]
		elsif input == "save"
			return [-2, -2]
		else
			coords1 = Hash.new()
			coords1["a"] = 0
			coords1["b"] = 1
			coords1["c"] = 2
			coords1["d"] = 3
			coords1["e"] = 4

			if /[0-5]+[a-eA-E]/.match(input)
				x = input[0]
				y = coords1[input[1]]
			elsif /[a-eA-E]+[0-5]/.match(input)
				x = coords1[input[0]]
				y = input[1]
			else
				printLine("Character does not fall within range of a to e or numeric 0 to 7")
			end

			res = [x, y]

			return res

		end

	end

	def printLine(prompt)
		puts prompt
		puts "\n"
	end

end


class Players

	#done
	def initialize(playerColour)
		@playerHand = Hand.new(playerColour)
		@lastMove = nil
		@playerColour = playerColour
	end

	#working on
	def makeMove(gameBoard)
		io = YoteIO.new()

		io.getCoordinates("Please enter the source coordinate (leave blank if placing a piece)\n")
	end

	#not done
	def pieces()
		#come back to
	end

	#done
	def storeLastMove(lastMove)
		@lastMove = lastMove
	end


end



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

	def initialize(rows, columns)
		@rows = rows
		@columns = columns
		@board = Array.new(rows){|i|Array.new(columns) {|j| Position.new([i,j])}}
	end

	def atPosition(coord)
		return @board[coord[0]][coord[1]].atPosition()
	end

	def board
		return @board
	end

	def placeAt(coord, colour)
		if colour == :empty or (coord[0].between?(0..@row) and coord[1].between?(0..@column)) or coord == nil?
			return false
		end
	end

	def removeAt(coord)
		if (coord[0].between?(0..@row) and coord[1].between?(0..@column)) or coord == nil?

			return false
		end
		@board[coord[0]][coord[1]].setPosition(:empty)
		return  true 
	end



	def pieces(colour)
		count = 0
		0.upto(@rows) do |i|
			0.upto(@columns) do |j|
				count = count + 1
			end
		end
		return count
	end

	#not done
	def availableMove(colour)
		0.upto(@rows) do |i|
			0.upto(@columns) do |j|
				if @board[i][j].atPosition() == colour
					temp.push(@board[i][j])
				end
			end
		end

		#wait for answer

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
		elsif lastMove.destination != @source 
			return false 
		elsif lastMove.source == @destination
			return true 
		end

	end

	#done
	def validate()
		result = findMoveType()

		if result == :illegal
			return false 
		end

		return true

	end

	#should be done 
	def isPossibleMove()
		x = @source[0]
		y = @source[1]

		res1 = @gameBoard.atPosition([x+1,y]) 
		res2 = @gameBoard.atPosition([x+2,y]) 
		if res1 == :empty or (res1 != :empty and res2 != @playerColour)
			return true 
		end

		res1 = @gameBoard.atPosition([x-1,y])
		res2 = @gameBoard.atPosition([x-2,y]) 
		if res1 == :empty or (res1 != :empty and res2 != @playerColour)
			return true 
		end

		res1 = @gameBoard.atPosition([x,y+1])
		res2 = @gameBoard.atPosition([x,y+2]) 
		if res1 == :empty or (res1 != :empty and res2 != @playerColour)
			return true 
		end

		res1 = @gameBoard.atPosition([x,y-1])
		res2 = @gameBoard.atPosition([x,y-2]) 
		if res1 == :empty or (res1 != :empty and res2 != @playerColour)
			return true 
		end

		return false 
	end

	#not done
	def to_s()

	end

	#not done
	def findMoveType()
		x = 0
		y = 1

		jumped = [(@destination[x] + @source[x]) / 2, (@destination[y] + @source[y]) / 2]

		puts jumped 

		result = (@gameBoard.atPosition(jumped) != @playerColour)

		puts result

		if result == true
			@move = :capture
		else
			@move = :illegal
		end

	end

	#not done
	def execute()
		if @move == :illegal
			return -1
		end

		@gameBoard.placeAt(@destination)

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


puts board.board()
puts move.findMoveType()

puts blah.getCoordinates("enter something")


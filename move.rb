#/usr/bin/ruby


class Position
#-------------------------------------------------------------Members
	
	# Colour piece
#-------------------------------------------------------------public funstions
	def initialize(position)
		@position = position
		@piece = :empty
	end
	
	def atPosition()
		return @piece 
	end

	def setPosition(value)
		@piece = value
	end

	def to_s()
		"In Position: #{@position} #{@piece}\n"
	end
# ------------------------------------------------------------Private Funtions    
end

class Board
#-------------------------------------------------------------Members

	# Position board[@rows][@columns]
#-------------------------------------------------------------public funstions
	def initialize(rows, columns)
		@rows = rows
		@columns = columns
		@board = Array.new(rows+1){|i|Array.new(columns+1) {|j| Position.new([i,j])}}


	end

	def atPosition(coord)

	end

	def board
		return @board
	end

	# voiddrawBoard(Player:white,Player:black
	# ColouratPosition(Coordinate:coord)
	# bool removeAt(Coordinate: coord)
	# bool placeAt(Coordinate: coord, Colour: colour)
	# int pieces(Colour)
	# bool availableMove(Colour)
	# string to_s()
# ------------------------------------------------------------Private Funtions
    
end

class Move
#-------------------------------------------------------------Members

#-------------------------------------------------------------public funstions
	def initialize(source, destination, playerColour, gameBoard)
		@source = source
		@destination = destination
		@playerColour = playerColour
		@gameBoard = gameBoard
		@move = 0


	end

	def source
		return @source
	end

	def destination
		return @destination
	end

	def playerColour
		return @playerColour
	end

	def gameBoard
		return @gameBoard
	end

	def boolcompate()

	end

	def validate()

	end

	def isPossibleMove()

	end

	def to_s()

	end

	def findMoveType()
		if @source == nil and @gameBoard.atPosition(@destination) == :empty 
			#and (0..@gameBoard.rows) === @source[0] and (0..@gameBoard.rows) === @destination[0] and (0..@gameBoard.columns) === @source[1] and (0..@gameBoard.columns) === @source[1]
			@move = :placement
		else
			@move = :illegal
		end

	end


	# boolcompare(Move:lastMove)
	# bool validate()
	# int execute()
	# bool isPossibleMove()
	# string to_s()
# ------------------------------------------------------------Private Funtions
	# MoveType findMoveType()
	# 	x = 0, y = 1 # For easier reading
	# 	jumped = [(@destination[x] + @source[x]) / 2, (@destination[y] + @source[y]) / 2]
	# 	result = (@gameBoard.atPosition(@jumped) != :empty &&
 #        @gameBoard.atPosition(@jumped) != :playerColour)
	# 	if result == true @move = :capture
	# 		11
	# 	else
	# 		@move = :illegal
	# 	end

end

source = [1, 2]
bye = [3,4]
no = [5,6]

board = Board.new(4, 5)
move = Move.new(source, bye, "black", board)
puts board.board()
puts move.findMoveType()
puts move.source


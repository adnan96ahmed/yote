#/usr/bin/ruby

class Move
#-------------------------------------------------------------Members

#-------------------------------------------------------------public funstions
	def initialize(source, destination, playerColour, gameBoard)
		@source = source
		@destination = destination
		@playerColour = playerColour
		@gameBoard = gameBoard
	end

	def source
		return @source
	end

	def destination
		return @source
	end

	def playerColour
		return @source
	end

	def gameBoard
		return @source
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

hi = [1, 2]
bye = [3,4]
no = [5,6]
object = Move.new(hi, bye, "black", no)
puts object.source


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

			ret1 = @players[@currentPlayer].makeMove(@gameBoard)

			ret2 = checkGameOver()

			if ret2 == false
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

	#not done
	def checkGameOver()
		0.upto(2) do |i|
			# @players[i].pieces()
		end
		return false
	end

	#not done
	def to_s()
		# "In Position: #{@position} #{@piece}\n"
		# @currentPlayer = 0
		# @player = Array.new(2)

	end

	#not done
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

	#not done
	def serializeGame(game, filename)

	end

	#not done
	def unserializeGame(filename)

	end

	#undone-->alliyya (need to see feedback from other team, otherwise its pretty much done)
	# letters are supposed to refer to the rows
	def getCoordinates(prompt)
		puts prompt
		res = 0
		input = gets.chomp
		if input.eql? 'forfeit'
			return [-1, -1]
		elsif input.eql? 'save'
			return [-2, -2]
		else
			coords1 = Hash.new()
			coords1["a"] = 0
			coords1["b"] = 1
			coords1["c"] = 2
			coords1["d"] = 3
			coords1["e"] = 4
			coords1["f"] = 5

			regex1 = /[0-4]+[a-eA-E]/
			regex2 = /[a-eA-E]+[0-4]/

			if prompt.include? "source"

				if regex1.match(input)
					x = Integer(input[0])
					y = coords1[input[1]]
					res = [x, y]
				elsif regex2.match(input)
					x = Integer(input[1])
					y = coords1[input[0]]
					res = [x, y]
				elsif input.empty?
					res = nil
				end
			else

				if regex1.match(input)
					if /^$/.match(input)
						res = nil
					end
					x = Integer(input[0])
					y = coords1[input[1]]
					res = [x, y]

				elsif regex2.match(input)
					if /^$/.match(input)
						res = nil
					end
					x = Integer(input[1])
					y = coords1[input[0]]
					res = [x, y]
				else
					res = nil
				end
			end
			puts "coordinates  = #{res}"
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
			puts @playerColour.to_s() + "'s turn\n"
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

			if execute == 1
                #loop after capture to ask player to select an opponents piece to remove
                loop do
                    removeSelection = io.getCoordinates("Select a coordinate of an opponent's piece for it to be removed\n")
                    p removeSelection
                    #removeSelection coordinate cannot be empty or the same colour as the player selecting
                    if removeSelection.nil? or gameBoard.atPosition(removeSelection) == :empty or gameBoard.atPosition(removeSelection) == @playerColour
                        puts("An invalid coordinate was selected for removing an opponent's piece")
                        next
                    else
                        gameBoard.removeAt(removeSelection)
                        break
                    end
                end
			elsif execute == 2
				@playerHand.removePiece();
			end
				
			storeLastMove(move)

			return 0

		end

	end

	#done
	def pieces(board)
		return @playerHand.pieces() + board.pieces(@playerColour)
	end
	
	#method not from doc, created to show remaining hand pieces only
	def handPieces(board)
		return @playerHand.pieces()
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

	#done
	def atPosition(coord)
		return @board[coord[0]][coord[1]].atPosition()
	end

	#undone
	def drawBoard(player1, player2)
		io = YoteIO.new()
	    # x --> cols(a-f)
	    # y --> rows(0-4)
		output = "  a b c d e f"
	    puts(output)

	    for i in 0..4
	    	output = (i).to_s
	    	for j in 0..12
	    		if j%2 == 1
		    		if atPosition([i,(j/2).floor]) == :white
		    			output << "*"
		    		elsif atPosition([i,(j/2).floor]) == :black
		    			output << "^"
		    		else
		    			output << "-"
		    		end
		    	else
		    		output << "|"
	    		end
	    	end
	    	puts(output)
	    end

	    puts("Remaining pieces:")
	    puts("p1: \n")
	    p player1.handPieces(self)
	    p self.pieces(player1.instance_variable_get(:@playerColour))
	    puts("p2: \n")
	    p player2.handPieces(self)
	    p self.pieces(player2.instance_variable_get(:@playerColour))
	end

	#done
	def placeAt(coord, colour)
		if colour == :empty or (coord[0] === (0..@rows) and coord[1] === (0..@columns))

			return false
		else
			p colour
			@board[coord[0]][coord[1]].setPosition(colour)
			return true
		end
	end

	#done
	def removeAt(coord)
		if (coord[0] === (0..@rows) and coord[1] === (0..@columns)) or coord.nil?
			return false
		end
		@board[coord[0]][coord[1]].setPosition(:empty)
		return  true
	end

	#done
	def pieces(colour)
		count = 0
		for i in 0..4
			for j in 0..5
				if @board[i][j].atPosition() == colour
					count = count + 1
				end
			end
		end
		return count
	end

	#not done?
	def availableMove(colour)
		0.upto(@rows) do |i|
			0.upto(@columns) do |j|
				if @board[i][j].atPosition() == colour
					temp.push(@board[i][j])
					move = Move.new(@boart[i][j].atPosition(), 0, colour, @board)
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

		if lastMove.instance_variable_get(:@move) == :illegal or lastMove.instance_variable_get(:@move) == :placement or lastMove.instance_variable_get(:@move) == :capture
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

		# check if its a placement move by simply checking if the source coordinate does not exist
		if @source.nil? and @gameBoard.atPosition(@destination) == :empty
			
			return :placement
		end

		# check if the move is of type move by checking if there is a coordinate difference of 1.
		if ((@source[0] - @destination[0]).abs == 1 and (@source[1] - @destination[1]).abs == 0) or ((@source[1] - @destination[1]).abs == 1 and (@source[0] - @destination[0]).abs == 0)
			if @gameBoard.atPosition(@source) == @playerColour and @gameBoard.atPosition(@destination) == :empty
				return :movement
			else
				return :illegal
			end
		end

		# check if the move is a capture by checking if there is a coordinate difference of 2, then checks if you skipped over a piece
		if ((@source[0] - @destination[0]).abs == 2 and (@source[1] - @destination[1]).abs == 0) or ((@source[1] - @destination[1]).abs == 2 and (@source[0] - @destination[0]).abs == 0)
			if @gameBoard.atPosition(@source) == @playerColour and @gameBoard.atPosition(@destination) == :empty
				jumped = [(@destination[x] + @source[x]) / 2, (@destination[y] + @source[y]) / 2]
				result = (@gameBoard.atPosition(jumped) != :empty && @gameBoard.atPosition(jumped) != :playerColour)

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

	def execute()
		if @move == :illegal
			return -1
		end

		@gameBoard.placeAt(@destination, @playerColour)

		if @move == :placement
			return 2#returning distinct number for placement so removePiece() can be called
			#return 0
		end

		if @move == :movement
			@gameBoard.removeAt(@source)
			return 0
		end

		if @move == :capture
			@gameBoard.removeAt(@source)
			jumped = [(@destination[0] + @source[0]) / 2, (@destination[1] + @source[1]) / 2]
			@gameBoard.removeAt(jumped)
			return 1
		end
	end

end


manage = GameManager.new()
manage.newGame()

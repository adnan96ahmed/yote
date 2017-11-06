
print "hello world"


CLASS GameManager{
	#---------------------------------------------------------Members
	Player players[2]
	int currentPlayer
	Board gameBoard
	#---------------------------------------------------------public funstions
	GameManager initialize(filename=nil)
	bool loadGame(string: filename)
	bool newGame()

	loop do
	ret = @players[@currentPlayer].makeMove(@gameBoard)
    # Need to check return and possibly call forfeit() or save(). See
    # Player.makeMove for return value, this part is not included.
    # Draw the board
    @gameBoard.drawBoard()
    ret = checkGameOver()
	if ret == false
	@currentPlayer = (@currentPlayer + 1) % 2
	else break
	end end
# Print which player wins

# ------------------------------------------------------------Private Funtions
	void forfeit(Colour: playerColour)
	bool saveGame()
	bool checkGameOver()
	string to_s()


    
}

CLASS Board{
#-------------------------------------------------------------Members
	int rows
	int columns
	Position board[@rows][@columns]
#-------------------------------------------------------------public funstions
	Board initialize(int: rows, int: columns)
	voiddrawBoard(Player:white,Player:black
	ColouratPosition(Coordinate:coord)
	bool removeAt(Coordinate: coord)
	bool placeAt(Coordinate: coord, Colour: colour)
	int pieces(Colour)
	bool availableMove(Colour)
	string to_s()
# ------------------------------------------------------------Private Funtions
    
}

CLASS Player{
#-------------------------------------------------------------Members
	Hand playerHand
	Move lastMove
	Colour playerColour
#-------------------------------------------------------------public funstions
	Player initialize(Colour: playerColour)
	int makeMove(Board: gameboard)
	int pieces()
	string to_s()
# ------------------------------------------------------------Private Funtions
	void storeLastMove(Move: lastmove)
}

CLASS Hand{
#-------------------------------------------------------------Members
	int pieceCount
	Colour playerColour
#-------------------------------------------------------------public funstions
	Hand initialize(Colour: playerColour)
	bool empty()
	bool removePiece()
	string to_s()
# ------------------------------------------------------------Private Funtions   
}

CLASS YoteIO{
#-------------------------------------------------------------Members
	YoteIO initialize()
	bool serializeGame(GameManager: game, string: filename)
	GameManager unserializeGame(string: filename)
	Coordinate getCoordinates(string: prompt)
	void printLine(string: print)
#-------------------------------------------------------------public funstions
# ------------------------------------------------------------Private Funtions    
}

CLASS Move{
#-------------------------------------------------------------Members
	Coordinate source
	Coordinate destination
	MoveType move
	Colour playerColour
	Board gameBoard
#-------------------------------------------------------------public funstions
	Move initialize(Coordinate: source, Coordinate: destination, Colour: playerColour, Board: gameBoard)
	boolcompare(Move:lastMove)
	bool validate()
	int execute()
	bool isPossibleMove()
	string to_s()
# ------------------------------------------------------------Private Funtions
	MoveType findMoveType() 
		x = 0, y = 1 # For easier reading
		jumped = [(@destination[x] + @source[x]) / 2, (@destination[y] + @source[y]) / 2]
		result = (@gameBoard.atPosition(@jumped) != :empty &&
         @gameBoard.atPosition(@jumped) != :playerColour)
		if result == true @move = :capture
			11
		else
			@move = :illegal 
		end

}

CLASS Position{
#-------------------------------------------------------------Members
	Coordinate position
	Colour piece
#-------------------------------------------------------------public funstions
	Position initialize(Coordinate: position)
	Colour atPosition()
	void setPosition(Colour value)
	string to_s()
# ------------------------------------------------------------Private Funtions    
}

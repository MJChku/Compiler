array board[3][3] = '.'; 

printboard(){
	i = 0;
	while(i<3){ 
		j = 0;
		while(j<3){
			putc_(board[i][j]);
			j = j + 1;
		}
	putc_('\n');
	i = i + 1;		
	}
	
}

refreshboard(){
	i = 0;
	while(i<3){ 
		j = 0;
		while(j<3){
			board[i][j] = '.';
			j = j + 1;
		}
	i = i + 1;		
	}
}

checkupdate(x,y){
	if(board[x][y] == '.'){
		return 1;
	} else{
		return 0;
	}
}

updateboard(x, y, chess){
	board[x][y] = chess;
}

checkboard(chess){
	win = 0;
	x = 0;
	while(x<3){
	if(board[x][0] == chess && board[x][1] == chess && board[x][2] == chess){
		return 1;
	}
         x = x + 1;
	}
	y = 0;
	while(y<3){
	if(board[0][y] == chess && board[1][y] == chess && board[2][y] == chess){
		return 1;
	}
        y = y + 1; 
	}
	if(board[0][0] == chess && board[1][1] == chess && board[2][2] == chess){
		return 1;
	}
	if(board[0][2] == chess && board[1][1] == chess && board[2][0] == chess){
		return 1;
	}
	return 0;
}
checkwin(){
	if(checkboard('o') == 1) {
		puts("player 1 wins!");
		return 1; 
	} else if (checkboard('x') == 1) {
		puts("player 2 wins!");
		return 1; 
	} else{
		return 0;
	}
}

main(){                 //global function "main"
	refreshboard();
	printboard();
	i = 0;
	x = -1;
	y = -1;
	canupdate = 0;
	while(i<9){
		while(canupdate != 1){
			geti(x);
			geti(y);
			canupdate = checkupdate(x,y);
		}
		canupdate = 0;

		if(i%2 == 0){
			puts("player 1 input x and y");
			geti(x);
			geti(y);
			printboard();
			result = checkwin();
			if(result == 1){
				puts("game ends");
				return 0;
			}
		}else{
			puts("player 2 input x and y");
			geti(x);
			geti(y);
			updateboard(x, y, 'x');
			printboard();
			result = checkwin();
			if(result == 1){
				puts("game ends");
				return 0;
			}
		}
		i = i + 1;
	}
	puts("no one wins");
	puts("game ends");
	return 0;
}

main();

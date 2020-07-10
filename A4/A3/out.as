	push	sp
	push	10
	add	
	pop	sp
	push	"input size of tower"
	puts_
	geti
	pop	fp[0]
	push	"A"
	push	"B"
	push	"C"
	push	fp[0]
	call	L000,4
	end
L000:
	push	sp
	push	10
	add	
	pop	sp
	push	fp[-4]
	push	1
	compEQ
	j0	L001
	push	"move"
	puts_
	push	fp[-7]
	puts_
	push	"to"
	puts_
	push	fp[-5]
	puts
	ret
L001:
	push	fp[-7]
	push	fp[-5]
	push	fp[-6]
	push	fp[-4]
	push	1
	sub
	call	L000,4
	push	"move"
	puts_
	push	fp[-7]
	puts_
	push	"to"
	puts_
	push	fp[-5]
	puts
	push	fp[-6]
	push	fp[-7]
	push	fp[-5]
	push	fp[-4]
	push	1
	sub
	call	L000,4
	ret


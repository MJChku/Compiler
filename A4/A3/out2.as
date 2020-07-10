	push	sp
	push	10
	add	
	pop	sp
	push	fp[0]
	call	L000,1
	push	fp[1]
	call	L000,1
	push	fp[0]
	push	fp[1]
	call	L001,2
	j0	L002
	push	"equal"
	puts
	jmp	L003
L002:
	push	"not equal"
	puts
L003:
	end
L001:
	push	sp
	push	10
	add	
	pop	sp
	push	fp[-5]
	push	fp[-4]
	compEQ
	ret


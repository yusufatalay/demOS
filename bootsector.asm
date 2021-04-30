[org 0x7c00]					; Jump origin od mapped bootsector code Loaded Boot Sector starts here

mov bp, 0xffff					; set the stack base (base pointer at top)
mov sp, bp 						; set the top of the stack to base

call set_video_mode

call get_char_input

jmp $							; iloop  so CPU doesn't execute random code

set_video_mode:
	mov al, 0x03				; 80x25 8x8 640x200 16 gray
	mov ah, 0x00
	int 0x10					; BIOS interrupt, this vector provides video services
	ret

get_char_input:
	xor ah, ah   				; wait for char input to make ah = 0 we can get key presses
	int 0x16					; interrupt that provides keyboard services

	cmp al, 0x30				; compares if numeric is 0
	jl get_char_input			; restart the loop if less
	cmp al, 0x7a				; compares if numeric is 9
	jg get_char_input			; restart the loop if greater
	
	mov ah, 0x0e
	int 0x10

	jmp get_char_input			; restart initial sub-routine

times 0x1fe-($-$$) db 0
dw 0xaa55						; Magic bytes for BIOS

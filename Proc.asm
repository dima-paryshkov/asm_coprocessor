.686
.model flat, stdcall
.CODE
	_FUNCSTR@20 PROC
	PUSH EBP
	MOV EBP, ESP

	; Длина строки-источника должна быть больше нуля.
	CMP [EBP]+12, 0
	JBE ERROR

	MOV ESI, [EBP]+8 ; исходная строка
	XOR EDX, EDX ; индекс обрабатываемого элемента
	MOV EAX, [EBP]+12 ; количество символов с исходной строке
	FUNC:
		MOV BL, [ESI] ;очередной элемент
		CMP BL, '0' ; если меньше символа нуля и больше символа 9 то записать исходный символ в строку, иначе заменить на нужный символ
		JB FINCT
		CMP BL, '9'
		JA FINCT
		MOV [[EBP+16]+EDX], [EBP]+24
		FINCT:
			MOV [[EBP+16] + EDX], BL
		ADD EDX, 1 ; +1
		INC ESI		; берём следующий символ
		DEC EAX		; уменьшение на 1 
		CMP EAX, 0	   ; если все сисволы обработаны выйти из цикла, иначе продолжить
		JA FUNC

	POP EBP
	MOV EAX, 1
	RET 20		   ; В стеке остаётся 5 аргументов по 4 байта.

ERROR:
	POP EBP
	MOV EAX, 0
	RET 20

	_FUNCSTR@20 ENDP
END

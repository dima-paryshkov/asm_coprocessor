.386
.MODEL FLAT

.DATA
	X	      DD 2.0    ; Xi, X0 = 2
	V         DD -2.0	  ; 
	EPS       DD ?	  ; Точность вычисления
	CTRADR    DD ?    ; Адрес переменной для количества итераций
	Y         DQ ?    ; Значение ф-ии в точке
	BUF       DQ ?    ; Для хранения Y при вычислениях

.CODE
	_Newton@8 PROC
	PUSH EBP
	MOV EBP, ESP

	MOV EAX, [EBP]+8 ; Извлекаем точность
	MOV EPS, EAX	 

	MOV EAX, [EBP]+12 ; Извлекаем адрес переменной для кол-ва итераций 
	MOV CTRADR, EAX

	XOR EBX, EBX ; Обнуляем счетчик итераций
	FINIT


	main:
		CALL FUNC   ; Y = F(X)
		FLD Y		 ; ST(0) = F(X)
		FLDZ		 ; ST(0) = 0,   ST(1) = F(X)
		FCOMPP		 ; 0 <?> F(X)
		FSTSW AX	 ; Загрузка флагов в AX
		SAHF		 ; Загрузка флагов в EFLAGS
		JNC negative ; Если 0 > F(X), меняем знак F(X)
		JMP positive ; Иначе, не менять знак

	negative:
		FLDZ  ; ST(0) = 0
		FLD Y ; ST(0) = F(X), ST(1) = 0
		FSUBP ; ST(0) = -F(X)

	positive:
		FLD EPS		; ST(0) = EPS, ST(1) = |F(X)|
		FCOMPP		; EPS <?> |F(X)|, затем убираются из стека
		FSTSW AX  	; Загрузка флагов в AX
		SAHF		   ; Загрузка флагов в EFLAGS
		JC cycle	   ; Если EPS < |F(X)|, то нужна большая точность и еще итерация
		JMP exit	   ; Иначе, выход
	cycle: 
		CALL ITER	; X = X - (F(X)*(V - F(X)))/(V * F'(X))
		INC EBX	   ; Увеличиваем количество итераций
	JNE main

	exit:	
		MOV EAX, CTRADR
		MOV [EAX], EBX  ; Сохраняем количество итераций
		FLD X		    ; ST(0) = X - возвращаемое значение 

		POP EBP
		RET
	_Newton@8 ENDP


	ITER PROC
		FLD X ; ST(0) = X
		FLD V
		FLD Y 
		FSUBP ; ST(0) = V - F(X),   	ST(1) = X
		FLD Y
		FMULP ; ST(0) = F(X)*(V - F(X)), ST(1) = X
		CALL DERIVATIVEFUNC
		FDIVP ; ST(0) =  (F(X)*(V - F(X)))/(V * F'(X)) ,   ST(1) = X
		FSUBP  ; ST(0) = X - (F(X)*(V - F(X)))/(V * F'(X))

		FSTP X
		RET
	ITER ENDP



	; Y = arctg(X) = F(X)
	FUNC PROC
		FLD X	   ; ST(0) = X
		FLD1	   ; ST(0) = 1,			ST(1) = X
		FPATAN     ; ST(0) = ARCT(X)
		FSTP Y  
		RET
	FUNC ENDP


	DERIVATIVEFUNC PROC
		FLD V
		FLD Y
		FLD Y
		FMULP
		FLD1
		FADDP 
		FDIVP ; ST(0) = V * F'(X),  ST(1) = F(X)*(V - F(X)) ,   ST(2) = X
		RET
	DERIVATIVEFUNC ENDP
END

# Эквивалентное представление переменных в программе на C
# В main:
# rbp[-36] -- `argc`
# rbp[-48] -- `argv`
# rbp[-32] -- `int i`
# rbp[-24] -- `input`
# rbp[-28] -- `int n`
# rbp[-16] -- `char *nums`
# rbp[-8] -- `output`
# Формальные параметры в findNums:
# rbp[-24] -- `input`
# rbp[-28] -- `int i`
# rbp[-32] -- `int n`
# rbp[-40] -- `char *nums`
# rbp[-8] -- `char *str`
# rbp[-12] -- `int j`

	.intel_syntax noprefix          # 
	.text                           # Начало секции
	.section	.rodata             # .rodata
.LC0:                               # Метка `.LC0:`…
	.string	"r"                     # .LC0: "r"
.LC1:
	.string	"input.txt"             # .LC1: "input.txt"
.LC2:
	.string	"w"                     # .LC2: "w"
.LC3:
	.string	"output.txt"            # .LC3: "output.txt"
	.text                           # секция с кодом
	.globl	main                    # Объявляем и экспортируем вовне символ `main`
main:
.LFB6:
	.cfi_startproc
	push	rbp                     # / Сохраняем rbp на стек
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp                    # | Вместо rbp записали rsp (rbp := rsp)
	.cfi_def_cfa_register 6
	sub	rsp, 48                     # \ Сдвигаем rbp на 48 байта
	mov	DWORD PTR -36[rbp], edi     # rbp[-36] := edi — это первый аргумент, `argc` (rdi)
	mov	QWORD PTR -48[rbp], rsi     # rbp[-48] := rsi — это второй аргумент, `argv` (rsi)
	mov	DWORD PTR -32[rbp], 0       # rbp[-32] := 0 -- `int i = 0`
	lea	rsi, .LC0[rip]              # rsi := "r"
	lea	rdi, .LC1[rip]              # rdi := "input.txt"
	call	fopen@PLT               # fopen(rdi, rsi);
	mov	QWORD PTR -24[rbp], rax     # `input` := fopen(...)
	mov	rdi, QWORD PTR -24[rbp]
	mov	edx, 2                      
	mov	esi, 0
	call	fseek@PLT               # fseek(input, 0L, SEEK_END);
	mov	rdi, QWORD PTR -24[rbp]     # rdi := `input`
	call	ftell@PLT               # ftell(rdi)
	mov	DWORD PTR -28[rbp], eax     # `int n` := ftell(rdi)
	mov	rdi, QWORD PTR -24[rbp]     # rax := `input`
	mov	edx, 0
	mov	esi, 0
	call	fseek@PLT               # fseek(input, 0L, SEEK_SET)
	mov	eax, DWORD PTR -28[rbp]     # eax := `n`
	add	eax, eax                    # / eax := n * 2
	sub	eax, 1                      # \ eax := n * 2 + 1
	mov	rdi, rax
	call	malloc@PLT              # malloc(n * 2 - 1)
	mov	QWORD PTR -16[rbp], rax     # char *nums = (char *) malloc(n * 2 - 1)
	mov	rcx, QWORD PTR -16[rbp]     # Параметр findNums rcx := `char *nums`
	mov	edx, DWORD PTR -28[rbp]     # Параметр findNums edx := `int n`
	mov	esi, DWORD PTR -32[rbp]     # Параметр findNums esi := `int i`
	mov	rdi, QWORD PTR -24[rbp]     # Параметр findNums rax := `input`              
	call	findNums                # Вызов findNums(input, i, n, nums)
	mov	rdi, QWORD PTR -24[rbp]     # rax := `input`
	call	fclose@PLT              # fclose(input)
	lea	rsi, .LC2[rip]              # rax := "w"
	lea	rdi, .LC3[rip]              # rsi := "output.txt"
	call	fopen@PLT               # fopen("output.txt", "w")
	mov	QWORD PTR -8[rbp], rax      # `output` := fopen("output.txt", "w")
	mov	rsi, QWORD PTR -8[rbp]      # rdx := `output`
	mov	rdi, QWORD PTR -16[rbp]     # rax := `nums`
	call	fputs@PLT               # fputs(nums, output)
	mov	rdi, QWORD PTR -8[rbp]      # rax := `output`             
	call	fclose@PLT              # fclose(output)
	mov	eax, 0                      # return 0
	leave                   # / Эпилог (1/2)
	.cfi_def_cfa 7, 8
	ret                     # \ Эпилог (2/2)
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.section	.rodata     # .rodata
.LC4:
	.string	"%c"            # .LC4: "%c"
	.text                               # секция с кодом
	.globl	findNums                    # Объявляем и экспортируем вовне символ `findNums`
findNums:       # функция findNums
.LFB7:
	.cfi_startproc
	push	rbp                     # / Сохраняем rbp на стек
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp                    # | rbp := rsp
	.cfi_def_cfa_register 6
	sub	rsp, 48                     # \ Сдвигаем rbp на 48 байт
	mov	QWORD PTR -24[rbp], rdi     # Параметр findNums rbp[-24] := `input`
	mov	DWORD PTR -28[rbp], esi     # Параметр findNums rbp[-28] := `int i`
	mov	DWORD PTR -32[rbp], edx     # Параметр findNums rbp[-32] := `int n`
	mov	QWORD PTR -40[rbp], rcx     # Параметр findNums rbp[-40] := `char *nums`
	mov	eax, DWORD PTR -32[rbp]     # eax := `n`
	cdqe
	mov	rdi, rax
	call	malloc@PLT              # malloc(n)
	mov	QWORD PTR -8[rbp], rax      # `char *str` := rax
	mov	DWORD PTR -12[rbp], 0       # `int j` := 0
	jmp	.L4                         # Переход к метке L4 
.L8:
	mov	eax, DWORD PTR -28[rbp]     # eax := `int i`
	movsx	rdx, eax                # rdx := eax
	mov	rax, QWORD PTR -8[rbp]      # rax := `char *str`
	add	rdx, rax                    # rdx += rax
	mov	rdi, QWORD PTR -24[rbp]     # rax := `input`
	lea	rsi, .LC4[rip]              # rcx := "%c"
	mov	eax, 0                      # eax := 0
	call	__isoc99_fscanf@PLT     # fscanf(input, "%c", &str[i]);
	mov	eax, DWORD PTR -28[rbp]     # eax := `int i`
	movsx	rdx, eax                
	mov	rax, QWORD PTR -8[rbp]      # rax := `char *str`
	add	rax, rdx                    # rax += rdx
	movzx	eax, BYTE PTR [rax]     # str[i]
	cmp	al, 47                      # str[i] сравниваем с 47
	jle	.L5                         # если str[i] <= 47, переход к метке L5
	mov	eax, DWORD PTR -28[rbp]     # eax := int i
	movsx	rdx, eax
	mov	rax, QWORD PTR -8[rbp]      # rax := `char *str`
	add	rax, rdx                    # 
	movzx	eax, BYTE PTR [rax]     # str[i]
	cmp	al, 57                      # str[i] сравниваем с 57
	jg	.L5                         # если str[i] > 57, переход к метке L5
	mov	eax, DWORD PTR -28[rbp]     # eax := `int i`
	cdqe
	lea	rdx, -1[rax]                # rdx := rax[-1]
	mov	rax, QWORD PTR -8[rbp]      # rax := `char *str`
	add	rax, rdx                    # rax += rdx                    
	movzx	eax, BYTE PTR [rax]     # str[i-1]
	cmp	al, 47                      # str[i-1] сравниваем с 47
	jle	.L6                         # если str[i-1] <= 47, переход к метке L6
	mov	eax, DWORD PTR -28[rbp]     # eax := `int i`
	cdqe
	lea	rdx, -1[rax]                # rdx := rax[-1]
	mov	rax, QWORD PTR -8[rbp]      # rax := `char *str`
	add	rax, rdx                    # rax += rdx
	movzx	eax, BYTE PTR [rax]     # eax := str[i-1]
	cmp	al, 57                      # str[i-1] сравниваем с 57
	jle	.L7                         # если str[i-1] > 57, переход к метке L5
.L6:
	cmp	DWORD PTR -12[rbp], 0       # j сравниваем с 0
	je	.L7                         # если j==0, переход к метке L5
	mov	eax, DWORD PTR -12[rbp]     # eax := j
	movsx	rdx, eax
	mov	rax, QWORD PTR -40[rbp]     # rax := nums
	add	rax, rdx                    # rax += rdx
	mov	BYTE PTR [rax], 43          # nums[j] = '+'
	add	DWORD PTR -12[rbp], 1       # ++j
.L7:
	mov	eax, DWORD PTR -28[rbp]     # eax := i
	movsx	rdx, eax
	mov	rax, QWORD PTR -8[rbp]      # rax := str
	add	rax, rdx                    
	mov	edx, DWORD PTR -12[rbp]     # edx := j
	movsx	rcx, edx                
	mov	rdx, QWORD PTR -40[rbp]     # rdx := nums
	add	rdx, rcx
	movzx	eax, BYTE PTR [rax]     # nums[j] = str[i]
	mov	BYTE PTR [rdx], al          # nums[j] = str[i]
	add	DWORD PTR -12[rbp], 1       # ++j
.L5:
	add	DWORD PTR -28[rbp], 1       # ++i
.L4:
	mov	eax, DWORD PTR -28[rbp]     # eax := `i`
	cmp	eax, DWORD PTR -32[rbp]     # сравниваем i и n
	jne	.L8                         # если i != n, переход к метке L8
	leave                           # Выход из программы
	.cfi_def_cfa 7, 8
	ret                             # Выход из программы
	.cfi_endproc
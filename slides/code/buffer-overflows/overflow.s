	.file	"overflow.c"
	.intel_syntax noprefix
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%s"
	.text
	.globl	do_something_with
	.type	do_something_with, @function
do_something_with:
.LFB23:
	.cfi_startproc
	sub	rsp, 8
	.cfi_def_cfa_offset 16
	mov	rdx, rdi
	mov	esi, OFFSET FLAT:.LC0
	mov	edi, 1
	mov	eax, 0
	call	__printf_chk
	add	rsp, 8
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE23:
	.size	do_something_with, .-do_something_with
	.globl	vulnerable
	.type	vulnerable, @function
vulnerable:
.LFB24:
	.cfi_startproc
	sub	rsp, 120
	.cfi_def_cfa_offset 128
	mov	rsi, rsp
	mov	edi, OFFSET FLAT:.LC0
	mov	eax, 0
	call	__isoc99_scanf
	mov	rdi, rsp
	call	do_something_with
	add	rsp, 120
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE24:
	.size	vulnerable, .-vulnerable
	.globl	main
	.type	main, @function
main:
.LFB25:
	.cfi_startproc
	sub	rsp, 8
	.cfi_def_cfa_offset 16
	mov	eax, 0
	call	vulnerable
	mov	eax, 0
	add	rsp, 8
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE25:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.5) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits

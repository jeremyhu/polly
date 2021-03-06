; RUN: opt %loadPolly -polly-scops -analyze \
; RUN: < %s | FileCheck %s

; CHECK: Stmt_loop_1
; CHECK:    Domain :=
; CHECK:      [N] -> { Stmt_loop_1[i0] : 
; CHECK-DAG:     i0 >= 0
; CHECK-DAG:   and
; CHECK-DAG:     i0 <= 101
; CHECK-DAG:   and
; CHECK-DAG:     N <= 100
; CHECK-DAG:     };
; CHECK: Stmt_loop_2
; CHECK:    Domain :=
; CHECK:      [N] -> { Stmt_loop_2[i0] :
; CHECK-DAG:     i0 >= 0
; CHECK-DAG:   and
; CHECK-DAG:     i0 <= 301
; CHECK-DAG:   and
; CHECK-DAG:     N <= 100
; CHECK-DAG:     };

define void @foo(float* %A, i64 %N) {
entry:
  br label %branch

branch:
  %cond = icmp sle i64 %N, 100
  br i1 %cond, label %loop.1, label %merge

loop.1:
  %indvar.1 = phi i64 [0, %branch], [%indvar.next.1, %loop.1]
  %indvar.next.1 = add i64 %indvar.1, 1
  %val.1 = load float, float* %A
  %sum.1 = fadd float %val.1, 1.0
  store float %sum.1, float* %A
  %cond.1 = icmp sle i64 %indvar.1, 100
  br i1 %cond.1, label %loop.1, label %loop.2

loop.2:
  %indvar.2 = phi i64 [0, %loop.1], [%indvar.next.2, %loop.2]
  %indvar.next.2 = add i64 %indvar.2, 1
  %val.2 = load float, float* %A
  %sum.2 = fadd float %val.2, 1.0
  store float %sum.2, float* %A
  %cond.2 = icmp sle i64 %indvar.2, 300
  br i1 %cond.2, label %loop.2, label %merge

merge:
  br label %exit

exit:
  ret void
}

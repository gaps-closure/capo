; ModuleID = '<stdin>'
source_filename = "out.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@bar.i = internal global i32 0, align 4, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [6 x i8] c"out.c\00", section "llvm.metadata"
@foo.j = internal global i32 0, align 4, !dbg !10
@.str.2 = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @bar.i to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 9 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32* @foo.j to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 18 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @bar() #0 !dbg !2 {
  %1 = load i32, i32* @bar.i, align 4, !dbg !17
  %2 = add nsw i32 %1, 1, !dbg !17
  store i32 %2, i32* @bar.i, align 4, !dbg !17
  ret i32 %1, !dbg !18
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo() #0 !dbg !12 {
  %1 = load i32, i32* @foo.j, align 4, !dbg !19
  %2 = add nsw i32 %1, 1, !dbg !19
  store i32 %2, i32* @foo.j, align 4, !dbg !19
  %3 = call i32 @bar(), !dbg !20
  %4 = load i32, i32* @foo.j, align 4, !dbg !21
  %5 = add nsw i32 %3, %4, !dbg !22
  ret i32 %5, !dbg !23
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !24 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !25, metadata !DIExpression()), !dbg !26
  %3 = call i32 @foo(), !dbg !27
  store i32 %3, i32* %2, align 4, !dbg !26
  %4 = load i32, i32* %2, align 4, !dbg !28
  %5 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i64 0, i64 0), i32 %4), !dbg !29
  ret i32 0, !dbg !30
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "i", scope: !2, file: !3, line: 9, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "bar", scope: !3, file: !3, line: 6, type: !4, scopeLine: 6, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "out.c", directory: "/home/bflin/gaps/build/apps/conflicts/test-runs/2021-08-18-13-40-21/unannotated-cut")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !{}
!9 = !{!0, !10}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "j", scope: !12, file: !3, line: 18, type: !6, isLocal: true, isDefinition: true)
!12 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 15, type: !4, scopeLine: 15, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!13 = !{i32 7, !"Dwarf Version", i32 4}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{!"clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)"}
!17 = !DILocation(line: 12, column: 13, scope: !2)
!18 = !DILocation(line: 12, column: 5, scope: !2)
!19 = !DILocation(line: 21, column: 6, scope: !12)
!20 = !DILocation(line: 22, column: 12, scope: !12)
!21 = !DILocation(line: 22, column: 20, scope: !12)
!22 = !DILocation(line: 22, column: 18, scope: !12)
!23 = !DILocation(line: 22, column: 5, scope: !12)
!24 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 24, type: !4, scopeLine: 24, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!25 = !DILocalVariable(name: "a", scope: !24, file: !3, line: 25, type: !6)
!26 = !DILocation(line: 25, column: 9, scope: !24)
!27 = !DILocation(line: 25, column: 13, scope: !24)
!28 = !DILocation(line: 26, column: 20, scope: !24)
!29 = !DILocation(line: 26, column: 5, scope: !24)
!30 = !DILocation(line: 27, column: 5, scope: !24)

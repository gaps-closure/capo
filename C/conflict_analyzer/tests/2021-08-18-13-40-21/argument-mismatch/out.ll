; ModuleID = '<stdin>'
source_filename = "out.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [6 x i8] c"out.c\00", section "llvm.metadata"
@bar.x = internal global i32 1, align 4, !dbg !0
@.str.2 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32 ()* @foo to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 17 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32* @bar.x to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 26 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo() #0 !dbg !14 {
  ret i32 1, !dbg !15
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @bar() #0 !dbg !2 {
  %1 = load i32, i32* @bar.x, align 4, !dbg !16
  %2 = call i32 @foo(), !dbg !17
  %3 = add nsw i32 %1, %2, !dbg !18
  %4 = load i32, i32* @bar.x, align 4, !dbg !19
  %5 = add nsw i32 %4, %3, !dbg !19
  store i32 %5, i32* @bar.x, align 4, !dbg !19
  %6 = load i32, i32* @bar.x, align 4, !dbg !20
  ret i32 %6, !dbg !21
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !22 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !28, metadata !DIExpression()), !dbg !29
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !30, metadata !DIExpression()), !dbg !31
  %6 = call i32 @bar(), !dbg !32
  %7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i64 0, i64 0), i32 %6), !dbg !33
  ret i32 0, !dbg !34
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!10, !11, !12}
!llvm.ident = !{!13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 26, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "bar", scope: !3, file: !3, line: 23, type: !4, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "out.c", directory: "/home/bflin/gaps/build/apps/conflicts/test-runs/2021-08-18-13-40-21/argument-mismatch")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !{}
!9 = !{!0}
!10 = !{i32 7, !"Dwarf Version", i32 4}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{!"clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)"}
!14 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 17, type: !4, scopeLine: 17, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!15 = !DILocation(line: 20, column: 5, scope: !14)
!16 = !DILocation(line: 29, column: 10, scope: !2)
!17 = !DILocation(line: 29, column: 14, scope: !2)
!18 = !DILocation(line: 29, column: 12, scope: !2)
!19 = !DILocation(line: 29, column: 7, scope: !2)
!20 = !DILocation(line: 30, column: 12, scope: !2)
!21 = !DILocation(line: 30, column: 5, scope: !2)
!22 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 33, type: !23, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!23 = !DISubroutineType(types: !24)
!24 = !{!6, !6, !25}
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!27 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!28 = !DILocalVariable(name: "argc", arg: 1, scope: !22, file: !3, line: 33, type: !6)
!29 = !DILocation(line: 33, column: 14, scope: !22)
!30 = !DILocalVariable(name: "argv", arg: 2, scope: !22, file: !3, line: 33, type: !25)
!31 = !DILocation(line: 33, column: 27, scope: !22)
!32 = !DILocation(line: 34, column: 18, scope: !22)
!33 = !DILocation(line: 34, column: 3, scope: !22)
!34 = !DILocation(line: 35, column: 3, scope: !22)

; ModuleID = '<stdin>'
source_filename = "out.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@foo.x = internal global i32 1, align 4, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [6 x i8] c"out.c\00", section "llvm.metadata"
@foo.y = internal global i32 1, align 4, !dbg !10
@.str.2 = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @foo.x to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 9 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32* @foo.y to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 15 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo() #0 !dbg !2 {
  %1 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %1, metadata !16, metadata !DIExpression()), !dbg !17
  %2 = load i32, i32* @foo.x, align 4, !dbg !18
  %3 = load i32, i32* @foo.y, align 4, !dbg !19
  %4 = add nsw i32 %2, %3, !dbg !20
  store i32 %4, i32* %1, align 4, !dbg !17
  %5 = load i32, i32* @foo.x, align 4, !dbg !21
  %6 = add nsw i32 %5, 1, !dbg !21
  store i32 %6, i32* @foo.x, align 4, !dbg !21
  %7 = load i32, i32* @foo.y, align 4, !dbg !22
  %8 = add nsw i32 %7, 1, !dbg !22
  store i32 %8, i32* @foo.y, align 4, !dbg !22
  %9 = load i32, i32* %1, align 4, !dbg !23
  ret i32 %9, !dbg !24
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !25 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !31, metadata !DIExpression()), !dbg !32
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !33, metadata !DIExpression()), !dbg !34
  %6 = call i32 @foo(), !dbg !35
  %7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i64 0, i64 0), i32 %6), !dbg !36
  ret i32 0, !dbg !37
}

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!12, !13, !14}
!llvm.ident = !{!15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 9, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 6, type: !4, scopeLine: 6, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "out.c", directory: "/home/bflin/gaps/build/apps/conflicts/test-runs/2021-08-18-13-40-21/multiple-levels-fun")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !{}
!9 = !{!0, !10}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 15, type: !6, isLocal: true, isDefinition: true)
!12 = !{i32 7, !"Dwarf Version", i32 4}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{!"clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)"}
!16 = !DILocalVariable(name: "a", scope: !2, file: !3, line: 19, type: !6)
!17 = !DILocation(line: 19, column: 9, scope: !2)
!18 = !DILocation(line: 19, column: 13, scope: !2)
!19 = !DILocation(line: 19, column: 17, scope: !2)
!20 = !DILocation(line: 19, column: 15, scope: !2)
!21 = !DILocation(line: 20, column: 6, scope: !2)
!22 = !DILocation(line: 21, column: 6, scope: !2)
!23 = !DILocation(line: 22, column: 12, scope: !2)
!24 = !DILocation(line: 22, column: 5, scope: !2)
!25 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 25, type: !26, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!26 = !DISubroutineType(types: !27)
!27 = !{!6, !6, !28}
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!30 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!31 = !DILocalVariable(name: "argc", arg: 1, scope: !25, file: !3, line: 25, type: !6)
!32 = !DILocation(line: 25, column: 14, scope: !25)
!33 = !DILocalVariable(name: "argv", arg: 2, scope: !25, file: !3, line: 25, type: !28)
!34 = !DILocation(line: 25, column: 27, scope: !25)
!35 = !DILocation(line: 26, column: 18, scope: !25)
!36 = !DILocation(line: 26, column: 3, scope: !25)
!37 = !DILocation(line: 27, column: 3, scope: !25)

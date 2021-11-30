; ModuleID = '<stdin>'
source_filename = "out.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@foo.y = internal global i32 1, align 4, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [6 x i8] c"out.c\00", section "llvm.metadata"
@foo.z = internal global i32 1, align 4, !dbg !10
@.str.2 = private unnamed_addr constant [17 x i8] c"ORANGE_SHAREABLE\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [10 x i8] c"XD_ORANGE\00", section "llvm.metadata"
@bar.x = internal global i32 1, align 4, !dbg !12
@.str.4 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.5 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@llvm.global.annotations = appending global [4 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @foo.y to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 26 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32* @foo.z to i8*), i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 32 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32 ()* @get_foo to i8*), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 42 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32* @bar.x to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 51 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo() #0 !dbg !2 {
  %1 = load i32, i32* @foo.y, align 4, !dbg !19
  %2 = add nsw i32 %1, 1, !dbg !19
  store i32 %2, i32* @foo.y, align 4, !dbg !19
  %3 = load i32, i32* @foo.z, align 4, !dbg !20
  %4 = add nsw i32 %3, 1, !dbg !20
  store i32 %4, i32* @foo.z, align 4, !dbg !20
  %5 = load i32, i32* @foo.y, align 4, !dbg !21
  %6 = load i32, i32* @foo.z, align 4, !dbg !22
  %7 = add nsw i32 %5, %6, !dbg !23
  ret i32 %7, !dbg !24
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @get_foo() #0 !dbg !25 {
  %1 = call i32 @foo(), !dbg !26
  ret i32 %1, !dbg !27
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @bar() #0 !dbg !14 {
  %1 = load i32, i32* @bar.x, align 4, !dbg !28
  %2 = call i32 @get_foo(), !dbg !29
  %3 = add nsw i32 %1, %2, !dbg !30
  %4 = load i32, i32* @bar.x, align 4, !dbg !31
  %5 = add nsw i32 %4, %3, !dbg !31
  store i32 %5, i32* @bar.x, align 4, !dbg !31
  %6 = load i32, i32* @bar.x, align 4, !dbg !32
  ret i32 %6, !dbg !33
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !34 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !40, metadata !DIExpression()), !dbg !41
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !42, metadata !DIExpression()), !dbg !43
  %6 = call i32 @bar(), !dbg !44
  %7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i64 0, i64 0), i32 %6), !dbg !45
  ret i32 0, !dbg !46
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!15, !16, !17}
!llvm.ident = !{!18}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "y", scope: !2, file: !3, line: 26, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 23, type: !4, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "out.c", directory: "/home/bflin/gaps/build/apps/conflicts/test-runs/2021-08-18-13-40-21/multiple-taints-1")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !{}
!9 = !{!0, !10, !12}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 32, type: !6, isLocal: true, isDefinition: true)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "x", scope: !14, file: !3, line: 51, type: !6, isLocal: true, isDefinition: true)
!14 = distinct !DISubprogram(name: "bar", scope: !3, file: !3, line: 48, type: !4, scopeLine: 48, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!15 = !{i32 7, !"Dwarf Version", i32 4}
!16 = !{i32 2, !"Debug Info Version", i32 3}
!17 = !{i32 1, !"wchar_size", i32 4}
!18 = !{!"clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)"}
!19 = !DILocation(line: 35, column: 6, scope: !2)
!20 = !DILocation(line: 36, column: 6, scope: !2)
!21 = !DILocation(line: 37, column: 12, scope: !2)
!22 = !DILocation(line: 37, column: 16, scope: !2)
!23 = !DILocation(line: 37, column: 14, scope: !2)
!24 = !DILocation(line: 37, column: 5, scope: !2)
!25 = distinct !DISubprogram(name: "get_foo", scope: !3, file: !3, line: 42, type: !4, scopeLine: 42, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!26 = !DILocation(line: 45, column: 12, scope: !25)
!27 = !DILocation(line: 45, column: 5, scope: !25)
!28 = !DILocation(line: 54, column: 10, scope: !14)
!29 = !DILocation(line: 54, column: 14, scope: !14)
!30 = !DILocation(line: 54, column: 12, scope: !14)
!31 = !DILocation(line: 54, column: 7, scope: !14)
!32 = !DILocation(line: 55, column: 12, scope: !14)
!33 = !DILocation(line: 55, column: 5, scope: !14)
!34 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 58, type: !35, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!35 = !DISubroutineType(types: !36)
!36 = !{!6, !6, !37}
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!39 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!40 = !DILocalVariable(name: "argc", arg: 1, scope: !34, file: !3, line: 58, type: !6)
!41 = !DILocation(line: 58, column: 14, scope: !34)
!42 = !DILocalVariable(name: "argv", arg: 2, scope: !34, file: !3, line: 58, type: !37)
!43 = !DILocation(line: 58, column: 27, scope: !34)
!44 = !DILocation(line: 59, column: 18, scope: !34)
!45 = !DILocation(line: 59, column: 3, scope: !34)
!46 = !DILocation(line: 60, column: 3, scope: !34)

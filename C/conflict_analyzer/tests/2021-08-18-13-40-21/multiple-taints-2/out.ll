; ModuleID = '<stdin>'
source_filename = "out.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@baz.x = internal global i32 1, align 4, !dbg !0
@.str = private unnamed_addr constant [17 x i8] c"ORANGE_SHAREABLE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [6 x i8] c"out.c\00", section "llvm.metadata"
@foo.y = internal global i32 1, align 4, !dbg !10
@.str.2 = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [10 x i8] c"XD_ORANGE\00", section "llvm.metadata"
@bar.x = internal global i32 1, align 4, !dbg !13
@.str.4 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.5 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@llvm.global.annotations = appending global [4 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @baz.x to i8*), i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 26 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32* @foo.y to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 37 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32 ()* @get_foo to i8*), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 47 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32* @bar.x to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 56 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @baz() #0 !dbg !2 {
  %1 = load i32, i32* @baz.x, align 4, !dbg !20
  %2 = add nsw i32 %1, 1, !dbg !20
  store i32 %2, i32* @baz.x, align 4, !dbg !20
  %3 = load i32, i32* @baz.x, align 4, !dbg !21
  ret i32 %3, !dbg !22
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo() #0 !dbg !12 {
  %1 = alloca i32, align 4
  %2 = load i32, i32* @foo.y, align 4, !dbg !23
  %3 = add nsw i32 %2, 1, !dbg !23
  store i32 %3, i32* @foo.y, align 4, !dbg !23
  call void @llvm.dbg.declare(metadata i32* %1, metadata !24, metadata !DIExpression()), !dbg !25
  %4 = call i32 @baz(), !dbg !26
  store i32 %4, i32* %1, align 4, !dbg !25
  %5 = load i32, i32* %1, align 4, !dbg !27
  %6 = load i32, i32* @foo.y, align 4, !dbg !28
  %7 = add nsw i32 %5, %6, !dbg !29
  ret i32 %7, !dbg !30
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @get_foo() #0 !dbg !31 {
  %1 = call i32 @foo(), !dbg !32
  ret i32 %1, !dbg !33
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @bar() #0 !dbg !15 {
  %1 = load i32, i32* @bar.x, align 4, !dbg !34
  %2 = call i32 @get_foo(), !dbg !35
  %3 = add nsw i32 %1, %2, !dbg !36
  %4 = load i32, i32* @bar.x, align 4, !dbg !37
  %5 = add nsw i32 %4, %3, !dbg !37
  store i32 %5, i32* @bar.x, align 4, !dbg !37
  %6 = load i32, i32* @bar.x, align 4, !dbg !38
  ret i32 %6, !dbg !39
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !40 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !46, metadata !DIExpression()), !dbg !47
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !48, metadata !DIExpression()), !dbg !49
  %6 = call i32 @bar(), !dbg !50
  %7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i64 0, i64 0), i32 %6), !dbg !51
  ret i32 0, !dbg !52
}

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !3, line: 26, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "baz", scope: !3, file: !3, line: 23, type: !4, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "out.c", directory: "/home/bflin/gaps/build/apps/conflicts/test-runs/2021-08-18-13-40-21/multiple-taints-2")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !{}
!9 = !{!0, !10, !13}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "y", scope: !12, file: !3, line: 37, type: !6, isLocal: true, isDefinition: true)
!12 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 34, type: !4, scopeLine: 34, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(name: "x", scope: !15, file: !3, line: 56, type: !6, isLocal: true, isDefinition: true)
!15 = distinct !DISubprogram(name: "bar", scope: !3, file: !3, line: 53, type: !4, scopeLine: 53, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!16 = !{i32 7, !"Dwarf Version", i32 4}
!17 = !{i32 2, !"Debug Info Version", i32 3}
!18 = !{i32 1, !"wchar_size", i32 4}
!19 = !{!"clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)"}
!20 = !DILocation(line: 29, column: 6, scope: !2)
!21 = !DILocation(line: 30, column: 12, scope: !2)
!22 = !DILocation(line: 30, column: 5, scope: !2)
!23 = !DILocation(line: 40, column: 6, scope: !12)
!24 = !DILocalVariable(name: "x", scope: !12, file: !3, line: 41, type: !6)
!25 = !DILocation(line: 41, column: 9, scope: !12)
!26 = !DILocation(line: 41, column: 13, scope: !12)
!27 = !DILocation(line: 42, column: 12, scope: !12)
!28 = !DILocation(line: 42, column: 16, scope: !12)
!29 = !DILocation(line: 42, column: 14, scope: !12)
!30 = !DILocation(line: 42, column: 5, scope: !12)
!31 = distinct !DISubprogram(name: "get_foo", scope: !3, file: !3, line: 47, type: !4, scopeLine: 47, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!32 = !DILocation(line: 50, column: 12, scope: !31)
!33 = !DILocation(line: 50, column: 5, scope: !31)
!34 = !DILocation(line: 59, column: 10, scope: !15)
!35 = !DILocation(line: 59, column: 14, scope: !15)
!36 = !DILocation(line: 59, column: 12, scope: !15)
!37 = !DILocation(line: 59, column: 7, scope: !15)
!38 = !DILocation(line: 60, column: 12, scope: !15)
!39 = !DILocation(line: 60, column: 5, scope: !15)
!40 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 63, type: !41, scopeLine: 63, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!41 = !DISubroutineType(types: !42)
!42 = !{!6, !6, !43}
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!45 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!46 = !DILocalVariable(name: "argc", arg: 1, scope: !40, file: !3, line: 63, type: !6)
!47 = !DILocation(line: 63, column: 14, scope: !40)
!48 = !DILocalVariable(name: "argv", arg: 2, scope: !40, file: !3, line: 63, type: !43)
!49 = !DILocation(line: 63, column: 27, scope: !40)
!50 = !DILocation(line: 64, column: 18, scope: !40)
!51 = !DILocation(line: 64, column: 3, scope: !40)
!52 = !DILocation(line: 65, column: 3, scope: !40)

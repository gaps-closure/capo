; ModuleID = '<stdin>'
source_filename = "out.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@baz.z = internal global i32 1, align 4, !dbg !0
@.str = private unnamed_addr constant [17 x i8] c"ORANGE_SHAREABLE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [6 x i8] c"out.c\00", section "llvm.metadata"
@get_foo.y = internal global i32 1, align 4, !dbg !10
@.str.2 = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [10 x i8] c"XD_ORANGE\00", section "llvm.metadata"
@bar.x = internal global i32 1, align 4, !dbg !13
@.str.4 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.5 = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@llvm.global.annotations = appending global [4 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @baz.z to i8*), i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 26 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32* @get_foo.y to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 45 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32 ()* @get_foo to i8*), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 39 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32* @bar.x to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i32 56 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @baz() #0 !dbg !2 {
  %1 = load i32, i32* @baz.z, align 4, !dbg !20
  %2 = add nsw i32 %1, 1, !dbg !20
  store i32 %2, i32* @baz.z, align 4, !dbg !20
  %3 = load i32, i32* @baz.z, align 4, !dbg !21
  ret i32 %3, !dbg !22
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo(i32 %0, i32 %1) #0 !dbg !23 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !26, metadata !DIExpression()), !dbg !27
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !28, metadata !DIExpression()), !dbg !29
  %5 = load i32, i32* %3, align 4, !dbg !30
  %6 = load i32, i32* %4, align 4, !dbg !31
  %7 = add nsw i32 %5, %6, !dbg !32
  ret i32 %7, !dbg !33
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @get_foo() #0 !dbg !12 {
  %1 = alloca i32, align 4
  %2 = load i32, i32* @get_foo.y, align 4, !dbg !34
  %3 = add nsw i32 %2, 1, !dbg !34
  store i32 %3, i32* @get_foo.y, align 4, !dbg !34
  call void @llvm.dbg.declare(metadata i32* %1, metadata !35, metadata !DIExpression()), !dbg !36
  %4 = call i32 @baz(), !dbg !37
  store i32 %4, i32* %1, align 4, !dbg !36
  %5 = load i32, i32* @get_foo.y, align 4, !dbg !38
  %6 = load i32, i32* %1, align 4, !dbg !39
  %7 = call i32 @foo(i32 %5, i32 %6), !dbg !40
  ret i32 %7, !dbg !41
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @bar() #0 !dbg !15 {
  %1 = load i32, i32* @bar.x, align 4, !dbg !42
  %2 = call i32 @get_foo(), !dbg !43
  %3 = add nsw i32 %1, %2, !dbg !44
  %4 = load i32, i32* @bar.x, align 4, !dbg !45
  %5 = add nsw i32 %4, %3, !dbg !45
  store i32 %5, i32* @bar.x, align 4, !dbg !45
  %6 = load i32, i32* @bar.x, align 4, !dbg !46
  ret i32 %6, !dbg !47
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !48 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !54, metadata !DIExpression()), !dbg !55
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !56, metadata !DIExpression()), !dbg !57
  %6 = call i32 @bar(), !dbg !58
  %7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i64 0, i64 0), i32 %6), !dbg !59
  ret i32 0, !dbg !60
}

declare dso_local i32 @printf(i8*, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "z", scope: !2, file: !3, line: 26, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "baz", scope: !3, file: !3, line: 23, type: !4, scopeLine: 23, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "out.c", directory: "/home/bflin/gaps/build/apps/conflicts/test-runs/2021-08-18-13-40-21/multiple-taints-3")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !{}
!9 = !{!0, !10, !13}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "y", scope: !12, file: !3, line: 45, type: !6, isLocal: true, isDefinition: true)
!12 = distinct !DISubprogram(name: "get_foo", scope: !3, file: !3, line: 39, type: !4, scopeLine: 39, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
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
!23 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 33, type: !24, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!24 = !DISubroutineType(types: !25)
!25 = !{!6, !6, !6}
!26 = !DILocalVariable(name: "y", arg: 1, scope: !23, file: !3, line: 33, type: !6)
!27 = !DILocation(line: 33, column: 13, scope: !23)
!28 = !DILocalVariable(name: "z", arg: 2, scope: !23, file: !3, line: 33, type: !6)
!29 = !DILocation(line: 33, column: 20, scope: !23)
!30 = !DILocation(line: 34, column: 12, scope: !23)
!31 = !DILocation(line: 34, column: 16, scope: !23)
!32 = !DILocation(line: 34, column: 14, scope: !23)
!33 = !DILocation(line: 34, column: 5, scope: !23)
!34 = !DILocation(line: 48, column: 6, scope: !12)
!35 = !DILocalVariable(name: "z", scope: !12, file: !3, line: 49, type: !6)
!36 = !DILocation(line: 49, column: 9, scope: !12)
!37 = !DILocation(line: 49, column: 13, scope: !12)
!38 = !DILocation(line: 50, column: 16, scope: !12)
!39 = !DILocation(line: 50, column: 19, scope: !12)
!40 = !DILocation(line: 50, column: 12, scope: !12)
!41 = !DILocation(line: 50, column: 5, scope: !12)
!42 = !DILocation(line: 59, column: 10, scope: !15)
!43 = !DILocation(line: 59, column: 14, scope: !15)
!44 = !DILocation(line: 59, column: 12, scope: !15)
!45 = !DILocation(line: 59, column: 7, scope: !15)
!46 = !DILocation(line: 60, column: 12, scope: !15)
!47 = !DILocation(line: 60, column: 5, scope: !15)
!48 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 63, type: !49, scopeLine: 63, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!49 = !DISubroutineType(types: !50)
!50 = !{!6, !6, !51}
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!53 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!54 = !DILocalVariable(name: "argc", arg: 1, scope: !48, file: !3, line: 63, type: !6)
!55 = !DILocation(line: 63, column: 14, scope: !48)
!56 = !DILocalVariable(name: "argv", arg: 2, scope: !48, file: !3, line: 63, type: !51)
!57 = !DILocation(line: 63, column: 27, scope: !48)
!58 = !DILocation(line: 64, column: 18, scope: !48)
!59 = !DILocation(line: 64, column: 3, scope: !48)
!60 = !DILocation(line: 65, column: 3, scope: !48)

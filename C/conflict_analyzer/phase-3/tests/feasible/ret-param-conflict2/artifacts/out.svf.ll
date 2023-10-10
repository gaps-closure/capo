; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/out.svf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32 (i32*)* @foo to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.2, i32 0, i32 0), i32 34, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32 ()* @main to i8*), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.2, i32 0, i32 0), i32 42, i8* null }], section "llvm.metadata"
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"FOO\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@main.a = internal global i32 1, align 4, !dbg !0
@glob = dso_local global i32* null, align 8, !dbg !10
@.str.3 = private unnamed_addr constant [5 x i8] c"MAIN\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo(i32* noundef %0) #0 !dbg !22 {
  %2 = alloca i32*, align 8
  store i32* %0, i32** %2, align 8
  call void @llvm.dbg.declare(metadata i32** %2, metadata !25, metadata !DIExpression()), !dbg !26
  %3 = load i32*, i32** %2, align 8, !dbg !27
  %4 = load i32, i32* %3, align 4, !dbg !28
  %5 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %6 = call i32 (i8*, ...) @printf(i8* noundef %5, i32 noundef %4), !dbg !29
  ret i32 0, !dbg !30
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !2 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  store i32* @main.a, i32** @glob, align 8, !dbg !31
  %2 = load i32*, i32** @glob, align 8, !dbg !32
  %3 = call i32 @foo(i32* noundef %2), !dbg !33
  ret i32 0, !dbg !34
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @printf(i8* noundef, ...) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!7}
!llvm.ident = !{!14}
!llvm.module.flags = !{!15, !16, !17, !18, !19, !20, !21}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 44, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 42, type: !4, scopeLine: 42, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !13)
!3 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "1f12e86a4ed30161d06d2b7febd88b48")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "1f12e86a4ed30161d06d2b7febd88b48")
!9 = !{!0, !10}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "glob", scope: !7, file: !3, line: 30, type: !12, isLocal: false, isDefinition: true)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!13 = !{}
!14 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!15 = !{i32 7, !"Dwarf Version", i32 5}
!16 = !{i32 2, !"Debug Info Version", i32 3}
!17 = !{i32 1, !"wchar_size", i32 4}
!18 = !{i32 7, !"PIC Level", i32 2}
!19 = !{i32 7, !"PIE Level", i32 2}
!20 = !{i32 7, !"uwtable", i32 1}
!21 = !{i32 7, !"frame-pointer", i32 2}
!22 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 34, type: !23, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !13)
!23 = !DISubroutineType(types: !24)
!24 = !{!6, !12}
!25 = !DILocalVariable(name: "x", arg: 1, scope: !22, file: !3, line: 34, type: !12)
!26 = !DILocation(line: 34, column: 14, scope: !22)
!27 = !DILocation(line: 36, column: 21, scope: !22)
!28 = !DILocation(line: 36, column: 20, scope: !22)
!29 = !DILocation(line: 36, column: 5, scope: !22)
!30 = !DILocation(line: 37, column: 5, scope: !22)
!31 = !DILocation(line: 45, column: 10, scope: !2)
!32 = !DILocation(line: 46, column: 9, scope: !2)
!33 = !DILocation(line: 46, column: 5, scope: !2)
!34 = !DILocation(line: 47, column: 5, scope: !2)

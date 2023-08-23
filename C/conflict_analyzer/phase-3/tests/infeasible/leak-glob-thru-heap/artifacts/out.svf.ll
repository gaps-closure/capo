; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/out.svf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast ([3 x i32]* @x to i8*), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 31, i8* null }], section "llvm.metadata"
@x = dso_local global [3 x i32] [i32 1, i32 2, i32 3], align 4, !dbg !0
@.str = private unnamed_addr constant [15 x i8] c"ORANGE_NOSHARE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [13 x i8] c"ORANGE_SHARE\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32** @bar() #0 !dbg !21 {
  %1 = alloca i32**, align 8
  call void @llvm.dbg.declare(metadata i32*** %1, metadata !24, metadata !DIExpression()), !dbg !25
  %2 = call noalias i8* @malloc(i64 noundef 8) #4, !dbg !26
  %3 = bitcast i8* %2 to i32**, !dbg !27
  store i32** %3, i32*** %1, align 8, !dbg !25
  %4 = load i32**, i32*** %1, align 8, !dbg !28
  %5 = getelementptr inbounds [3 x i32], [3 x i32]* @x, i64 0, i64 0
  store i32* %5, i32** %4, align 8, !dbg !29
  %6 = load i32**, i32*** %1, align 8, !dbg !30
  ret i32** %6, !dbg !31
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !32 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32**, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !35, metadata !DIExpression()), !dbg !36
  %4 = bitcast i32* %2 to i8*, !dbg !37
  %5 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.2, i32 0, i32 0
  %6 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %4, i8* %5, i8* %6, i32 46, i8* null), !dbg !37
  call void @llvm.dbg.declare(metadata i32*** %3, metadata !38, metadata !DIExpression()), !dbg !39
  %7 = call i32** @bar(), !dbg !40
  store i32** %7, i32*** %3, align 8, !dbg !39
  %8 = load i32**, i32*** %3, align 8, !dbg !41
  %9 = load i32*, i32** %8, align 8, !dbg !42
  %10 = getelementptr inbounds i32, i32* %9, i64 0, !dbg !43
  store i32 2, i32* %10, align 4, !dbg !44
  ret i32 0, !dbg !45
}

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!13}
!llvm.module.flags = !{!14, !15, !16, !17, !18, !19, !20}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !9, line: 31, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !8, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "faebfb6b50442303efd007abd0a01b54")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{!0}
!9 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "faebfb6b50442303efd007abd0a01b54")
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 96, elements: !11)
!11 = !{!12}
!12 = !DISubrange(count: 3)
!13 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!14 = !{i32 7, !"Dwarf Version", i32 5}
!15 = !{i32 2, !"Debug Info Version", i32 3}
!16 = !{i32 1, !"wchar_size", i32 4}
!17 = !{i32 7, !"PIC Level", i32 2}
!18 = !{i32 7, !"PIE Level", i32 2}
!19 = !{i32 7, !"uwtable", i32 1}
!20 = !{i32 7, !"frame-pointer", i32 2}
!21 = distinct !DISubprogram(name: "bar", scope: !9, file: !9, line: 35, type: !22, scopeLine: 35, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!22 = !DISubroutineType(types: !4)
!23 = !{}
!24 = !DILocalVariable(name: "y", scope: !21, file: !9, line: 36, type: !5)
!25 = !DILocation(line: 36, column: 9, scope: !21)
!26 = !DILocation(line: 36, column: 20, scope: !21)
!27 = !DILocation(line: 36, column: 13, scope: !21)
!28 = !DILocation(line: 37, column: 4, scope: !21)
!29 = !DILocation(line: 37, column: 6, scope: !21)
!30 = !DILocation(line: 38, column: 10, scope: !21)
!31 = !DILocation(line: 38, column: 3, scope: !21)
!32 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 41, type: !33, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!33 = !DISubroutineType(types: !34)
!34 = !{!7}
!35 = !DILocalVariable(name: "unused", scope: !32, file: !9, line: 46, type: !7)
!36 = !DILocation(line: 46, column: 7, scope: !32)
!37 = !DILocation(line: 46, column: 3, scope: !32)
!38 = !DILocalVariable(name: "y", scope: !32, file: !9, line: 50, type: !5)
!39 = !DILocation(line: 50, column: 9, scope: !32)
!40 = !DILocation(line: 50, column: 13, scope: !32)
!41 = !DILocation(line: 51, column: 5, scope: !32)
!42 = !DILocation(line: 51, column: 4, scope: !32)
!43 = !DILocation(line: 51, column: 3, scope: !32)
!44 = !DILocation(line: 51, column: 11, scope: !32)
!45 = !DILocation(line: 52, column: 3, scope: !32)

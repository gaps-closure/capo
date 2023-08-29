; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c'
source_filename = "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global [3 x i32] [i32 1, i32 2, i32 3], align 4, !dbg !0
@.str = private unnamed_addr constant [15 x i8] c"ORANGE_NOSHARE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [4 x i8] c"BAR\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast ([3 x i32]* @x to i8*), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 31, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32** ()* @bar to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 37, i8* null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32** @bar() #0 !dbg !21 {
  %1 = alloca i32**, align 8
  call void @llvm.dbg.declare(metadata i32*** %1, metadata !24, metadata !DIExpression()), !dbg !25
  %2 = call noalias i8* @malloc(i64 noundef 8) #3, !dbg !26
  %3 = bitcast i8* %2 to i32**, !dbg !27
  store i32** %3, i32*** %1, align 8, !dbg !25
  %4 = load i32**, i32*** %1, align 8, !dbg !28
  store i32* getelementptr inbounds ([3 x i32], [3 x i32]* @x, i64 0, i64 0), i32** %4, align 8, !dbg !29
  %5 = load i32**, i32*** %1, align 8, !dbg !30
  ret i32** %5, !dbg !31
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !32 {
  %1 = alloca i32, align 4
  %2 = alloca i32**, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32*** %2, metadata !35, metadata !DIExpression()), !dbg !36
  %3 = call i32** @bar(), !dbg !37
  store i32** %3, i32*** %2, align 8, !dbg !36
  %4 = load i32**, i32*** %2, align 8, !dbg !38
  %5 = load i32*, i32** %4, align 8, !dbg !39
  %6 = getelementptr inbounds i32, i32* %5, i64 0, !dbg !40
  store i32 2, i32* %6, align 4, !dbg !41
  ret i32 0, !dbg !42
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!13, !14, !15, !16, !17, !18, !19}
!llvm.ident = !{!20}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !9, line: 31, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !8, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "3fa8d306af1393bed889292f42270b16")
!4 = !{!5}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{!0}
!9 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "3fa8d306af1393bed889292f42270b16")
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 96, elements: !11)
!11 = !{!12}
!12 = !DISubrange(count: 3)
!13 = !{i32 7, !"Dwarf Version", i32 5}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{i32 7, !"PIC Level", i32 2}
!17 = !{i32 7, !"PIE Level", i32 2}
!18 = !{i32 7, !"uwtable", i32 1}
!19 = !{i32 7, !"frame-pointer", i32 2}
!20 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!21 = distinct !DISubprogram(name: "bar", scope: !9, file: !9, line: 37, type: !22, scopeLine: 37, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!22 = !DISubroutineType(types: !4)
!23 = !{}
!24 = !DILocalVariable(name: "y", scope: !21, file: !9, line: 39, type: !5)
!25 = !DILocation(line: 39, column: 9, scope: !21)
!26 = !DILocation(line: 39, column: 20, scope: !21)
!27 = !DILocation(line: 39, column: 13, scope: !21)
!28 = !DILocation(line: 40, column: 4, scope: !21)
!29 = !DILocation(line: 40, column: 6, scope: !21)
!30 = !DILocation(line: 41, column: 10, scope: !21)
!31 = !DILocation(line: 41, column: 3, scope: !21)
!32 = distinct !DISubprogram(name: "main", scope: !9, file: !9, line: 44, type: !33, scopeLine: 44, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!33 = !DISubroutineType(types: !34)
!34 = !{!7}
!35 = !DILocalVariable(name: "y", scope: !32, file: !9, line: 51, type: !5)
!36 = !DILocation(line: 51, column: 9, scope: !32)
!37 = !DILocation(line: 51, column: 13, scope: !32)
!38 = !DILocation(line: 52, column: 5, scope: !32)
!39 = !DILocation(line: 52, column: 4, scope: !32)
!40 = !DILocation(line: 52, column: 3, scope: !32)
!41 = !DILocation(line: 52, column: 11, scope: !32)
!42 = !DILocation(line: 53, column: 3, scope: !32)

; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/out.svf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast ([3 x i32]* @x to i8*), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([82 x i8], [82 x i8]* @.str.1, i32 0, i32 0), i32 34, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32** ()* @bar to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([82 x i8], [82 x i8]* @.str.1, i32 0, i32 0), i32 39, i8* null }], section "llvm.metadata"
@x = dso_local global [3 x i32] [i32 1, i32 2, i32 3], align 4, !dbg !0
@.str = private unnamed_addr constant [15 x i8] c"ORANGE_NOSHARE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [82 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/global-noaccess.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [4 x i8] c"BAR\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32** @bar() #0 !dbg !18 {
  ret i32** bitcast ([3 x i32]* @x to i32**), !dbg !24
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !25 {
  %1 = alloca i32, align 4
  %2 = alloca i32**, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32*** %2, metadata !28, metadata !DIExpression()), !dbg !29
  %3 = call i32** @bar(), !dbg !30
  store i32** %3, i32*** %2, align 8, !dbg !29
  ret i32 0, !dbg !31
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!10}
!llvm.module.flags = !{!11, !12, !13, !14, !15, !16, !17}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !5, line: 34, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/global-noaccess.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "0afbb27f50d1728650914b3bfb888fc5")
!4 = !{!0}
!5 = !DIFile(filename: "global-noaccess.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "0afbb27f50d1728650914b3bfb888fc5")
!6 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 96, elements: !8)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{!9}
!9 = !DISubrange(count: 3)
!10 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!11 = !{i32 7, !"Dwarf Version", i32 5}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = !{i32 7, !"PIC Level", i32 2}
!15 = !{i32 7, !"PIE Level", i32 2}
!16 = !{i32 7, !"uwtable", i32 1}
!17 = !{i32 7, !"frame-pointer", i32 2}
!18 = distinct !DISubprogram(name: "bar", scope: !5, file: !5, line: 39, type: !19, scopeLine: 39, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!19 = !DISubroutineType(types: !20)
!20 = !{!21}
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!23 = !{}
!24 = !DILocation(line: 41, column: 3, scope: !18)
!25 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 44, type: !26, scopeLine: 44, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!26 = !DISubroutineType(types: !27)
!27 = !{!7}
!28 = !DILocalVariable(name: "y", scope: !25, file: !5, line: 45, type: !21)
!29 = !DILocation(line: 45, column: 9, scope: !25)
!30 = !DILocation(line: 45, column: 13, scope: !25)
!31 = !DILocation(line: 48, column: 3, scope: !25)

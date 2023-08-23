; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c'
source_filename = "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global [3 x i32] [i32 1, i32 2, i32 3], align 4, !dbg !0
@.str = private unnamed_addr constant [15 x i8] c"ORANGE_NOSHARE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@x_base = dso_local global i32* getelementptr inbounds ([3 x i32], [3 x i32]* @x, i32 0, i32 0), align 8, !dbg !5
@.str.2 = private unnamed_addr constant [4 x i8] c"BAR\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [13 x i8] c"ORANGE_SHARE\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast ([3 x i32]* @x to i8*), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 31, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32** ()* @bar to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 39, i8* null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32** @bar() #0 !dbg !21 {
  ret i32** @x_base, !dbg !26
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !27 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32**, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !30, metadata !DIExpression()), !dbg !31
  %4 = bitcast i32* %2 to i8*, !dbg !32
  call void @llvm.var.annotation(i8* %4, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 49, i8* null), !dbg !32
  call void @llvm.dbg.declare(metadata i32*** %3, metadata !33, metadata !DIExpression()), !dbg !34
  %5 = call i32** @bar(), !dbg !35
  store i32** %5, i32*** %3, align 8, !dbg !34
  %6 = load i32**, i32*** %3, align 8, !dbg !36
  %7 = load i32*, i32** %6, align 8, !dbg !37
  %8 = getelementptr inbounds i32, i32* %7, i64 0, !dbg !38
  store i32 2, i32* %8, align 4, !dbg !39
  ret i32 0, !dbg !40
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!13, !14, !15, !16, !17, !18, !19}
!llvm.ident = !{!20}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !7, line: 31, type: !10, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "b39bcda71e6522053f6db087447ade99")
!4 = !{!0, !5}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "x_base", scope: !2, file: !7, line: 34, type: !8, isLocal: false, isDefinition: true)
!7 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "b39bcda71e6522053f6db087447ade99")
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!10 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 96, elements: !11)
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
!21 = distinct !DISubprogram(name: "bar", scope: !7, file: !7, line: 39, type: !22, scopeLine: 39, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!22 = !DISubroutineType(types: !23)
!23 = !{!24}
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!25 = !{}
!26 = !DILocation(line: 41, column: 3, scope: !21)
!27 = distinct !DISubprogram(name: "main", scope: !7, file: !7, line: 44, type: !28, scopeLine: 44, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!28 = !DISubroutineType(types: !29)
!29 = !{!9}
!30 = !DILocalVariable(name: "unused", scope: !27, file: !7, line: 49, type: !9)
!31 = !DILocation(line: 49, column: 7, scope: !27)
!32 = !DILocation(line: 49, column: 3, scope: !27)
!33 = !DILocalVariable(name: "y", scope: !27, file: !7, line: 53, type: !24)
!34 = !DILocation(line: 53, column: 9, scope: !27)
!35 = !DILocation(line: 53, column: 13, scope: !27)
!36 = !DILocation(line: 54, column: 5, scope: !27)
!37 = !DILocation(line: 54, column: 4, scope: !27)
!38 = !DILocation(line: 54, column: 3, scope: !27)
!39 = !DILocation(line: 54, column: 11, scope: !27)
!40 = !DILocation(line: 55, column: 3, scope: !27)

; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c'
source_filename = "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@x = dso_local global [3 x i32] [i32 1, i32 2, i32 3], align 4, !dbg !0
@.str = private unnamed_addr constant [15 x i8] c"ORANGE_NOSHARE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [13 x i8] c"ORANGE_SHARE\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [4 x i8] c"BAR\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast ([3 x i32]* @x to i8*), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 31, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (void ()* @bar to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 49, i8* null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32** noundef %0) #0 !dbg !18 {
  %2 = alloca i32**, align 8
  %3 = alloca i32, align 4
  store i32** %0, i32*** %2, align 8
  call void @llvm.dbg.declare(metadata i32*** %2, metadata !24, metadata !DIExpression()), !dbg !25
  call void @llvm.dbg.declare(metadata i32* %3, metadata !26, metadata !DIExpression()), !dbg !27
  %4 = bitcast i32* %3 to i8*, !dbg !28
  call void @llvm.var.annotation(i8* %4, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 39, i8* null), !dbg !28
  %5 = load i32**, i32*** %2, align 8, !dbg !29
  %6 = load i32*, i32** %5, align 8, !dbg !30
  %7 = getelementptr inbounds i32, i32* %6, i64 0, !dbg !31
  store i32 2, i32* %7, align 4, !dbg !32
  ret void, !dbg !33
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bar() #0 !dbg !34 {
  %1 = alloca i32*, align 8
  call void @llvm.dbg.declare(metadata i32** %1, metadata !37, metadata !DIExpression()), !dbg !38
  store i32* getelementptr inbounds ([3 x i32], [3 x i32]* @x, i64 0, i64 0), i32** %1, align 8, !dbg !38
  call void @foo(i32** noundef %1), !dbg !39
  ret void, !dbg !40
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !41 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @bar(), !dbg !44
  ret i32 0, !dbg !45
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!10, !11, !12, !13, !14, !15, !16}
!llvm.ident = !{!17}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "x", scope: !2, file: !5, line: 31, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "67ecb52a64a9c297e8bdbc9ae2132150")
!4 = !{!0}
!5 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "67ecb52a64a9c297e8bdbc9ae2132150")
!6 = !DICompositeType(tag: DW_TAG_array_type, baseType: !7, size: 96, elements: !8)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !{!9}
!9 = !DISubrange(count: 3)
!10 = !{i32 7, !"Dwarf Version", i32 5}
!11 = !{i32 2, !"Debug Info Version", i32 3}
!12 = !{i32 1, !"wchar_size", i32 4}
!13 = !{i32 7, !"PIC Level", i32 2}
!14 = !{i32 7, !"PIE Level", i32 2}
!15 = !{i32 7, !"uwtable", i32 1}
!16 = !{i32 7, !"frame-pointer", i32 2}
!17 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!18 = distinct !DISubprogram(name: "foo", scope: !5, file: !5, line: 34, type: !19, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!19 = !DISubroutineType(types: !20)
!20 = !{null, !21}
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!23 = !{}
!24 = !DILocalVariable(name: "y", arg: 1, scope: !18, file: !5, line: 34, type: !21)
!25 = !DILocation(line: 34, column: 16, scope: !18)
!26 = !DILocalVariable(name: "unused", scope: !18, file: !5, line: 39, type: !7)
!27 = !DILocation(line: 39, column: 7, scope: !18)
!28 = !DILocation(line: 39, column: 3, scope: !18)
!29 = !DILocation(line: 43, column: 5, scope: !18)
!30 = !DILocation(line: 43, column: 4, scope: !18)
!31 = !DILocation(line: 43, column: 3, scope: !18)
!32 = !DILocation(line: 43, column: 11, scope: !18)
!33 = !DILocation(line: 44, column: 1, scope: !18)
!34 = distinct !DISubprogram(name: "bar", scope: !5, file: !5, line: 49, type: !35, scopeLine: 49, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!35 = !DISubroutineType(types: !36)
!36 = !{null}
!37 = !DILocalVariable(name: "y", scope: !34, file: !5, line: 51, type: !22)
!38 = !DILocation(line: 51, column: 8, scope: !34)
!39 = !DILocation(line: 52, column: 3, scope: !34)
!40 = !DILocation(line: 53, column: 1, scope: !34)
!41 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 55, type: !42, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!42 = !DISubroutineType(types: !43)
!43 = !{!7}
!44 = !DILocation(line: 56, column: 3, scope: !41)
!45 = !DILocation(line: 57, column: 3, scope: !41)
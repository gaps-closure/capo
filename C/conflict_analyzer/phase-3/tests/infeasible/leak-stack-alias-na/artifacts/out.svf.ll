; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/out.svf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (void (i32*)* @foo to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 46, i8* null }], section "llvm.metadata"
@.str = private unnamed_addr constant [13 x i8] c"ORANGE_SHARE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [4 x i8] c"FOO\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [15 x i8] c"ORANGE_NOSHARE\00", section "llvm.metadata"
@__const.main.x = private unnamed_addr constant [3 x i32] [i32 1, i32 2, i32 3], align 4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32* noundef %0) #0 !dbg !10 {
  %2 = alloca i32*, align 8
  %3 = alloca i32*, align 8
  store i32* %0, i32** %2, align 8
  call void @llvm.dbg.declare(metadata i32** %2, metadata !17, metadata !DIExpression()), !dbg !18
  call void @llvm.dbg.declare(metadata i32** %3, metadata !19, metadata !DIExpression()), !dbg !20
  %4 = bitcast i32** %3 to i8*, !dbg !21
  %5 = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i32 0, i32 0
  %6 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %4, i8* %5, i8* %6, i32 51, i8* null), !dbg !21
  %7 = load i32*, i32** %2, align 8, !dbg !22
  store i32* %7, i32** %3, align 8, !dbg !23
  %8 = load i32*, i32** %3, align 8, !dbg !24
  call void @bar(i32* noundef %8), !dbg !25
  ret void, !dbg !26
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bar(i32* noundef %0) #0 !dbg !27 {
  %2 = alloca i32*, align 8
  %3 = alloca i32, align 4
  store i32* %0, i32** %2, align 8
  call void @llvm.dbg.declare(metadata i32** %2, metadata !28, metadata !DIExpression()), !dbg !29
  call void @llvm.dbg.declare(metadata i32* %3, metadata !30, metadata !DIExpression()), !dbg !31
  %4 = bitcast i32* %3 to i8*, !dbg !32
  %5 = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i32 0, i32 0
  %6 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %4, i8* %5, i8* %6, i32 37, i8* null), !dbg !32
  store i32 0, i32* %3, align 4, !dbg !31
  %7 = load i32*, i32** %2, align 8, !dbg !33
  %8 = getelementptr inbounds i32, i32* %7, i64 0, !dbg !33
  store i32 5, i32* %8, align 4, !dbg !34
  ret void, !dbg !35
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !36 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i32], align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i32]* %2, metadata !39, metadata !DIExpression()), !dbg !43
  %3 = bitcast [3 x i32]* %2 to i8*, !dbg !44
  %4 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.3, i32 0, i32 0
  %5 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %3, i8* %4, i8* %5, i32 63, i8* null), !dbg !44
  %6 = bitcast [3 x i32]* %2 to i8*, !dbg !43
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %6, i8* align 4 bitcast ([3 x i32]* @__const.main.x to i8*), i64 12, i1 false), !dbg !43
  %7 = getelementptr inbounds [3 x i32], [3 x i32]* %2, i64 0, i64 0, !dbg !45
  call void @foo(i32* noundef %7), !dbg !46
  ret i32 0, !dbg !47
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #3 = { argmemonly nofree nounwind willreturn }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!2}
!llvm.module.flags = !{!3, !4, !5, !6, !7, !8, !9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "d533322657f9971155bfe57c8f7cdc0b")
!2 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"PIC Level", i32 2}
!7 = !{i32 7, !"PIE Level", i32 2}
!8 = !{i32 7, !"uwtable", i32 1}
!9 = !{i32 7, !"frame-pointer", i32 2}
!10 = distinct !DISubprogram(name: "foo", scope: !11, file: !11, line: 46, type: !12, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!11 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "d533322657f9971155bfe57c8f7cdc0b")
!12 = !DISubroutineType(types: !13)
!13 = !{null, !14}
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !{}
!17 = !DILocalVariable(name: "x", arg: 1, scope: !10, file: !11, line: 46, type: !14)
!18 = !DILocation(line: 46, column: 15, scope: !10)
!19 = !DILocalVariable(name: "y", scope: !10, file: !11, line: 51, type: !14)
!20 = !DILocation(line: 51, column: 8, scope: !10)
!21 = !DILocation(line: 51, column: 3, scope: !10)
!22 = !DILocation(line: 54, column: 7, scope: !10)
!23 = !DILocation(line: 54, column: 5, scope: !10)
!24 = !DILocation(line: 55, column: 7, scope: !10)
!25 = !DILocation(line: 55, column: 3, scope: !10)
!26 = !DILocation(line: 56, column: 1, scope: !10)
!27 = distinct !DISubprogram(name: "bar", scope: !11, file: !11, line: 32, type: !12, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!28 = !DILocalVariable(name: "y", arg: 1, scope: !27, file: !11, line: 32, type: !14)
!29 = !DILocation(line: 32, column: 15, scope: !27)
!30 = !DILocalVariable(name: "unused", scope: !27, file: !11, line: 37, type: !15)
!31 = !DILocation(line: 37, column: 7, scope: !27)
!32 = !DILocation(line: 37, column: 3, scope: !27)
!33 = !DILocation(line: 40, column: 3, scope: !27)
!34 = !DILocation(line: 40, column: 8, scope: !27)
!35 = !DILocation(line: 41, column: 1, scope: !27)
!36 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 59, type: !37, scopeLine: 59, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!37 = !DISubroutineType(types: !38)
!38 = !{!15}
!39 = !DILocalVariable(name: "x", scope: !36, file: !11, line: 63, type: !40)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 96, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 3)
!43 = !DILocation(line: 63, column: 7, scope: !36)
!44 = !DILocation(line: 63, column: 3, scope: !36)
!45 = !DILocation(line: 65, column: 7, scope: !36)
!46 = !DILocation(line: 65, column: 3, scope: !36)
!47 = !DILocation(line: 66, column: 3, scope: !36)

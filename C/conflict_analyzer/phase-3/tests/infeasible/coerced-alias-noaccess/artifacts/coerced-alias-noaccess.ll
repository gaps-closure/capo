; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/coerced-alias-noaccess.c'
source_filename = "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/coerced-alias-noaccess.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"ORANGE_SHARE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [89 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/coerced-alias-noaccess.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [4 x i8] c"FOO\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [15 x i8] c"ORANGE_NOSHARE\00", section "llvm.metadata"
@__const.main.x = private unnamed_addr constant [3 x i32] [i32 1, i32 2, i32 3], align 4
@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (void (i32*)* @foo to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([89 x i8], [89 x i8]* @.str.1, i32 0, i32 0), i32 39, i8* null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bar(i32* noundef %0) #0 !dbg !10 {
  %2 = alloca i32*, align 8
  store i32* %0, i32** %2, align 8
  call void @llvm.dbg.declare(metadata i32** %2, metadata !17, metadata !DIExpression()), !dbg !18
  %3 = load i32*, i32** %2, align 8, !dbg !19
  %4 = getelementptr inbounds i32, i32* %3, i64 0, !dbg !19
  store i32 5, i32* %4, align 4, !dbg !20
  ret void, !dbg !21
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32* noundef %0) #0 !dbg !22 {
  %2 = alloca i32*, align 8
  %3 = alloca i32*, align 8
  store i32* %0, i32** %2, align 8
  call void @llvm.dbg.declare(metadata i32** %2, metadata !23, metadata !DIExpression()), !dbg !24
  call void @llvm.dbg.declare(metadata i32** %3, metadata !25, metadata !DIExpression()), !dbg !26
  %4 = bitcast i32** %3 to i8*, !dbg !27
  call void @llvm.var.annotation(i8* %4, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([89 x i8], [89 x i8]* @.str.1, i32 0, i32 0), i32 44, i8* null), !dbg !27
  %5 = load i32*, i32** %2, align 8, !dbg !28
  store i32* %5, i32** %3, align 8, !dbg !29
  %6 = load i32*, i32** %3, align 8, !dbg !30
  call void @bar(i32* noundef %6), !dbg !31
  ret void, !dbg !32
}

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !33 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i32], align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i32]* %2, metadata !36, metadata !DIExpression()), !dbg !40
  %3 = bitcast [3 x i32]* %2 to i8*, !dbg !41
  call void @llvm.var.annotation(i8* %3, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([89 x i8], [89 x i8]* @.str.1, i32 0, i32 0), i32 56, i8* null), !dbg !41
  %4 = bitcast [3 x i32]* %2 to i8*, !dbg !40
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %4, i8* align 4 bitcast ([3 x i32]* @__const.main.x to i8*), i64 12, i1 false), !dbg !40
  %5 = getelementptr inbounds [3 x i32], [3 x i32]* %2, i64 0, i64 0, !dbg !42
  call void @foo(i32* noundef %5), !dbg !43
  ret i32 0, !dbg !44
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #3 = { argmemonly nofree nounwind willreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/coerced-alias-noaccess.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "b761a3fdfbd452be48a6efd0be1ccbe2")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!10 = distinct !DISubprogram(name: "bar", scope: !11, file: !11, line: 32, type: !12, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!11 = !DIFile(filename: "coerced-alias-noaccess.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "b761a3fdfbd452be48a6efd0be1ccbe2")
!12 = !DISubroutineType(types: !13)
!13 = !{null, !14}
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !{}
!17 = !DILocalVariable(name: "y", arg: 1, scope: !10, file: !11, line: 32, type: !14)
!18 = !DILocation(line: 32, column: 15, scope: !10)
!19 = !DILocation(line: 33, column: 3, scope: !10)
!20 = !DILocation(line: 33, column: 8, scope: !10)
!21 = !DILocation(line: 34, column: 1, scope: !10)
!22 = distinct !DISubprogram(name: "foo", scope: !11, file: !11, line: 39, type: !12, scopeLine: 39, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!23 = !DILocalVariable(name: "x", arg: 1, scope: !22, file: !11, line: 39, type: !14)
!24 = !DILocation(line: 39, column: 15, scope: !22)
!25 = !DILocalVariable(name: "y", scope: !22, file: !11, line: 44, type: !14)
!26 = !DILocation(line: 44, column: 8, scope: !22)
!27 = !DILocation(line: 44, column: 3, scope: !22)
!28 = !DILocation(line: 47, column: 7, scope: !22)
!29 = !DILocation(line: 47, column: 5, scope: !22)
!30 = !DILocation(line: 48, column: 7, scope: !22)
!31 = !DILocation(line: 48, column: 3, scope: !22)
!32 = !DILocation(line: 49, column: 1, scope: !22)
!33 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 52, type: !34, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!34 = !DISubroutineType(types: !35)
!35 = !{!15}
!36 = !DILocalVariable(name: "x", scope: !33, file: !11, line: 56, type: !37)
!37 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 96, elements: !38)
!38 = !{!39}
!39 = !DISubrange(count: 3)
!40 = !DILocation(line: 56, column: 7, scope: !33)
!41 = !DILocation(line: 56, column: 3, scope: !33)
!42 = !DILocation(line: 58, column: 7, scope: !33)
!43 = !DILocation(line: 58, column: 3, scope: !33)
!44 = !DILocation(line: 59, column: 3, scope: !33)

; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/stack.c'
source_filename = "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/stack.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"ORANGE_SHARE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [72 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/stack.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [4 x i8] c"FOO\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [15 x i8] c"ORANGE_NOSHARE\00", section "llvm.metadata"
@__const.main.x = private unnamed_addr constant [3 x i32] [i32 1, i32 2, i32 3], align 4
@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (void (i32*)* @foo to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([72 x i8], [72 x i8]* @.str.1, i32 0, i32 0), i32 46, i8* null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bar(i32* noundef %0) #0 !dbg !10 {
  %2 = alloca i32*, align 8
  %3 = alloca i32, align 4
  store i32* %0, i32** %2, align 8
  call void @llvm.dbg.declare(metadata i32** %2, metadata !17, metadata !DIExpression()), !dbg !18
  call void @llvm.dbg.declare(metadata i32* %3, metadata !19, metadata !DIExpression()), !dbg !20
  %4 = bitcast i32* %3 to i8*, !dbg !21
  call void @llvm.var.annotation(i8* %4, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([72 x i8], [72 x i8]* @.str.1, i32 0, i32 0), i32 37, i8* null), !dbg !21
  store i32 1, i32* %3, align 4, !dbg !20
  %5 = load i32*, i32** %2, align 8, !dbg !22
  %6 = getelementptr inbounds i32, i32* %5, i64 0, !dbg !22
  store i32 5, i32* %6, align 4, !dbg !23
  ret void, !dbg !24
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32* noundef %0) #0 !dbg !25 {
  %2 = alloca i32*, align 8
  store i32* %0, i32** %2, align 8
  call void @llvm.dbg.declare(metadata i32** %2, metadata !26, metadata !DIExpression()), !dbg !27
  %3 = load i32*, i32** %2, align 8, !dbg !28
  call void @bar(i32* noundef %3), !dbg !29
  ret void, !dbg !30
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !31 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i32], align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i32]* %2, metadata !34, metadata !DIExpression()), !dbg !38
  %3 = bitcast [3 x i32]* %2 to i8*, !dbg !39
  call void @llvm.var.annotation(i8* %3, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([72 x i8], [72 x i8]* @.str.1, i32 0, i32 0), i32 56, i8* null), !dbg !39
  %4 = bitcast [3 x i32]* %2 to i8*, !dbg !38
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %4, i8* align 4 bitcast ([3 x i32]* @__const.main.x to i8*), i64 12, i1 false), !dbg !38
  %5 = getelementptr inbounds [3 x i32], [3 x i32]* %2, i64 0, i64 0, !dbg !40
  call void @foo(i32* noundef %5), !dbg !41
  ret i32 0, !dbg !42
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
!1 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/stack.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "412dc23de4f022910f4d0432b5299145")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!10 = distinct !DISubprogram(name: "bar", scope: !11, file: !11, line: 32, type: !12, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!11 = !DIFile(filename: "stack.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "412dc23de4f022910f4d0432b5299145")
!12 = !DISubroutineType(types: !13)
!13 = !{null, !14}
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !{}
!17 = !DILocalVariable(name: "x", arg: 1, scope: !10, file: !11, line: 32, type: !14)
!18 = !DILocation(line: 32, column: 15, scope: !10)
!19 = !DILocalVariable(name: "unused", scope: !10, file: !11, line: 37, type: !15)
!20 = !DILocation(line: 37, column: 7, scope: !10)
!21 = !DILocation(line: 37, column: 3, scope: !10)
!22 = !DILocation(line: 40, column: 3, scope: !10)
!23 = !DILocation(line: 40, column: 8, scope: !10)
!24 = !DILocation(line: 41, column: 1, scope: !10)
!25 = distinct !DISubprogram(name: "foo", scope: !11, file: !11, line: 46, type: !12, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!26 = !DILocalVariable(name: "x", arg: 1, scope: !25, file: !11, line: 46, type: !14)
!27 = !DILocation(line: 46, column: 15, scope: !25)
!28 = !DILocation(line: 48, column: 7, scope: !25)
!29 = !DILocation(line: 48, column: 3, scope: !25)
!30 = !DILocation(line: 49, column: 1, scope: !25)
!31 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 52, type: !32, scopeLine: 52, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!32 = !DISubroutineType(types: !33)
!33 = !{!15}
!34 = !DILocalVariable(name: "x", scope: !31, file: !11, line: 56, type: !35)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 96, elements: !36)
!36 = !{!37}
!37 = !DISubrange(count: 3)
!38 = !DILocation(line: 56, column: 7, scope: !31)
!39 = !DILocation(line: 56, column: 3, scope: !31)
!40 = !DILocation(line: 58, column: 7, scope: !31)
!41 = !DILocation(line: 58, column: 3, scope: !31)
!42 = !DILocation(line: 59, column: 3, scope: !31)

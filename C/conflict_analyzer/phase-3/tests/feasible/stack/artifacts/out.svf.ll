; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/out.svf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (void (i32*)* @foo to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 46, i8* null }], section "llvm.metadata"
@.str = private unnamed_addr constant [13 x i8] c"ORANGE_SHARE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@__const.foo.y = private unnamed_addr constant [3 x i32] [i32 1, i32 2, i32 3], align 4
@.str.2 = private unnamed_addr constant [4 x i8] c"FOO\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [15 x i8] c"ORANGE_NOSHARE\00", section "llvm.metadata"
@__const.main.x = private unnamed_addr constant [3 x i32] [i32 1, i32 2, i32 3], align 4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32* noundef %0) #0 !dbg !10 {
  %2 = alloca i32*, align 8
  %3 = alloca [3 x i32], align 4
  store i32* %0, i32** %2, align 8
  call void @llvm.dbg.declare(metadata i32** %2, metadata !17, metadata !DIExpression()), !dbg !18
  call void @llvm.dbg.declare(metadata [3 x i32]* %3, metadata !19, metadata !DIExpression()), !dbg !23
  %4 = bitcast [3 x i32]* %3 to i8*, !dbg !24
  %5 = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i32 0, i32 0
  %6 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %4, i8* %5, i8* %6, i32 51, i8* null), !dbg !24
  %7 = bitcast [3 x i32]* %3 to i8*, !dbg !23
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %7, i8* align 4 bitcast ([3 x i32]* @__const.foo.y to i8*), i64 12, i1 false), !dbg !23
  %8 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !25
  call void @bar(i32* noundef %8), !dbg !26
  ret void, !dbg !27
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bar(i32* noundef %0) #0 !dbg !28 {
  %2 = alloca i32*, align 8
  %3 = alloca i32, align 4
  store i32* %0, i32** %2, align 8
  call void @llvm.dbg.declare(metadata i32** %2, metadata !29, metadata !DIExpression()), !dbg !30
  call void @llvm.dbg.declare(metadata i32* %3, metadata !31, metadata !DIExpression()), !dbg !32
  %4 = bitcast i32* %3 to i8*, !dbg !33
  %5 = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i32 0, i32 0
  %6 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %4, i8* %5, i8* %6, i32 37, i8* null), !dbg !33
  store i32 1, i32* %3, align 4, !dbg !32
  %7 = load i32*, i32** %2, align 8, !dbg !34
  %8 = getelementptr inbounds i32, i32* %7, i64 0, !dbg !34
  store i32 5, i32* %8, align 4, !dbg !35
  ret void, !dbg !36
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !37 {
  %1 = alloca i32, align 4
  %2 = alloca [3 x i32], align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [3 x i32]* %2, metadata !40, metadata !DIExpression()), !dbg !41
  %3 = bitcast [3 x i32]* %2 to i8*, !dbg !42
  %4 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.3, i32 0, i32 0
  %5 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %3, i8* %4, i8* %5, i32 62, i8* null), !dbg !42
  %6 = bitcast [3 x i32]* %2 to i8*, !dbg !41
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %6, i8* align 4 bitcast ([3 x i32]* @__const.main.x to i8*), i64 12, i1 false), !dbg !41
  %7 = getelementptr inbounds [3 x i32], [3 x i32]* %2, i64 0, i64 0, !dbg !43
  call void @foo(i32* noundef %7), !dbg !44
  ret i32 0, !dbg !45
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #3 = { argmemonly nofree nounwind willreturn }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!2}
!llvm.module.flags = !{!3, !4, !5, !6, !7, !8, !9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "79eb7b8cc04a494191c615d840363cad")
!2 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"PIC Level", i32 2}
!7 = !{i32 7, !"PIE Level", i32 2}
!8 = !{i32 7, !"uwtable", i32 1}
!9 = !{i32 7, !"frame-pointer", i32 2}
!10 = distinct !DISubprogram(name: "foo", scope: !11, file: !11, line: 46, type: !12, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!11 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "79eb7b8cc04a494191c615d840363cad")
!12 = !DISubroutineType(types: !13)
!13 = !{null, !14}
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !{}
!17 = !DILocalVariable(name: "x", arg: 1, scope: !10, file: !11, line: 46, type: !14)
!18 = !DILocation(line: 46, column: 15, scope: !10)
!19 = !DILocalVariable(name: "y", scope: !10, file: !11, line: 51, type: !20)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 96, elements: !21)
!21 = !{!22}
!22 = !DISubrange(count: 3)
!23 = !DILocation(line: 51, column: 7, scope: !10)
!24 = !DILocation(line: 51, column: 3, scope: !10)
!25 = !DILocation(line: 54, column: 7, scope: !10)
!26 = !DILocation(line: 54, column: 3, scope: !10)
!27 = !DILocation(line: 55, column: 1, scope: !10)
!28 = distinct !DISubprogram(name: "bar", scope: !11, file: !11, line: 32, type: !12, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!29 = !DILocalVariable(name: "y", arg: 1, scope: !28, file: !11, line: 32, type: !14)
!30 = !DILocation(line: 32, column: 15, scope: !28)
!31 = !DILocalVariable(name: "unused", scope: !28, file: !11, line: 37, type: !15)
!32 = !DILocation(line: 37, column: 7, scope: !28)
!33 = !DILocation(line: 37, column: 3, scope: !28)
!34 = !DILocation(line: 40, column: 3, scope: !28)
!35 = !DILocation(line: 40, column: 8, scope: !28)
!36 = !DILocation(line: 41, column: 1, scope: !28)
!37 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 58, type: !38, scopeLine: 58, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!38 = !DISubroutineType(types: !39)
!39 = !{!15}
!40 = !DILocalVariable(name: "x", scope: !37, file: !11, line: 62, type: !20)
!41 = !DILocation(line: 62, column: 7, scope: !37)
!42 = !DILocation(line: 62, column: 3, scope: !37)
!43 = !DILocation(line: 65, column: 7, scope: !37)
!44 = !DILocation(line: 65, column: 3, scope: !37)
!45 = !DILocation(line: 66, column: 3, scope: !37)

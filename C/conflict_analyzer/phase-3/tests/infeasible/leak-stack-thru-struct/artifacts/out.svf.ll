; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/out.svf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.S = type { i32*, i32 }

@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (void (i32*, i32)* @foo to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 44, i8* null }], section "llvm.metadata"
@.str = private unnamed_addr constant [13 x i8] c"ORANGE_SHARE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [15 x i8] c"ORANGE_NOSHARE\00", section "llvm.metadata"
@__const.foo.x = private unnamed_addr constant [3 x i32] [i32 1, i32 2, i32 3], align 4
@.str.3 = private unnamed_addr constant [4 x i8] c"FOO\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32* %0, i32 %1) #0 !dbg !10 {
  %3 = alloca %struct.S, align 8
  %4 = alloca [3 x i32], align 4
  %5 = bitcast %struct.S* %3 to { i32*, i32 }*
  %6 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %5, i32 0, i32 0
  store i32* %0, i32** %6, align 8
  %7 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %5, i32 0, i32 1
  store i32 %1, i32* %7, align 8
  call void @llvm.dbg.declare(metadata %struct.S* %3, metadata !22, metadata !DIExpression()), !dbg !23
  call void @llvm.dbg.declare(metadata [3 x i32]* %4, metadata !24, metadata !DIExpression()), !dbg !28
  %8 = bitcast [3 x i32]* %4 to i8*, !dbg !29
  %9 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.2, i32 0, i32 0
  %10 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %8, i8* %9, i8* %10, i32 49, i8* null), !dbg !29
  %11 = bitcast [3 x i32]* %4 to i8*, !dbg !28
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %11, i8* align 4 bitcast ([3 x i32]* @__const.foo.x to i8*), i64 12, i1 false), !dbg !28
  %12 = getelementptr inbounds [3 x i32], [3 x i32]* %4, i64 0, i64 0, !dbg !30
  %13 = getelementptr inbounds %struct.S, %struct.S* %3, i32 0, i32 0, !dbg !31
  store i32* %12, i32** %13, align 8, !dbg !32
  %14 = bitcast %struct.S* %3 to { i32*, i32 }*, !dbg !33
  %15 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %14, i32 0, i32 0, !dbg !33
  %16 = load i32*, i32** %15, align 8, !dbg !33
  %17 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %14, i32 0, i32 1, !dbg !33
  %18 = load i32, i32* %17, align 8, !dbg !33
  call void @bar(i32* %16, i32 %18), !dbg !33
  ret void, !dbg !34
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @bar(i32* %0, i32 %1) #0 !dbg !35 {
  %3 = alloca %struct.S, align 8
  %4 = alloca i32, align 4
  %5 = bitcast %struct.S* %3 to { i32*, i32 }*
  %6 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %5, i32 0, i32 0
  store i32* %0, i32** %6, align 8
  %7 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %5, i32 0, i32 1
  store i32 %1, i32* %7, align 8
  call void @llvm.dbg.declare(metadata %struct.S* %3, metadata !36, metadata !DIExpression()), !dbg !37
  call void @llvm.dbg.declare(metadata i32* %4, metadata !38, metadata !DIExpression()), !dbg !39
  %8 = bitcast i32* %4 to i8*, !dbg !40
  %9 = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i32 0, i32 0
  %10 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %8, i8* %9, i8* %10, i32 38, i8* null), !dbg !40
  store i32 1, i32* %4, align 4, !dbg !39
  ret void, !dbg !41
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !42 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.S, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct.S* %2, metadata !45, metadata !DIExpression()), !dbg !46
  %3 = bitcast %struct.S* %2 to i8*, !dbg !47
  %4 = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i32 0, i32 0
  %5 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %3, i8* %4, i8* %5, i32 59, i8* null), !dbg !47
  %6 = getelementptr inbounds %struct.S, %struct.S* %2, i32 0, i32 1, !dbg !48
  store i32 5, i32* %6, align 8, !dbg !49
  %7 = bitcast %struct.S* %2 to { i32*, i32 }*, !dbg !50
  %8 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %7, i32 0, i32 0, !dbg !50
  %9 = load i32*, i32** %8, align 8, !dbg !50
  %10 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %7, i32 0, i32 1, !dbg !50
  %11 = load i32, i32* %10, align 8, !dbg !50
  call void @foo(i32* %9, i32 %11), !dbg !50
  ret i32 0, !dbg !51
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #3 = { argmemonly nofree nounwind willreturn }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!2}
!llvm.module.flags = !{!3, !4, !5, !6, !7, !8, !9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "ae6bc3d5c196aeaeaf97f12098a75af3")
!2 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"PIC Level", i32 2}
!7 = !{i32 7, !"PIE Level", i32 2}
!8 = !{i32 7, !"uwtable", i32 1}
!9 = !{i32 7, !"frame-pointer", i32 2}
!10 = distinct !DISubprogram(name: "foo", scope: !11, file: !11, line: 44, type: !12, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !21)
!11 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "ae6bc3d5c196aeaeaf97f12098a75af3")
!12 = !DISubroutineType(types: !13)
!13 = !{null, !14}
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "S", file: !11, line: 31, baseType: !15)
!15 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !11, line: 28, size: 128, elements: !16)
!16 = !{!17, !20}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !15, file: !11, line: 29, baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !15, file: !11, line: 30, baseType: !19, size: 32, offset: 64)
!21 = !{}
!22 = !DILocalVariable(name: "s", arg: 1, scope: !10, file: !11, line: 44, type: !14)
!23 = !DILocation(line: 44, column: 12, scope: !10)
!24 = !DILocalVariable(name: "x", scope: !10, file: !11, line: 49, type: !25)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !19, size: 96, elements: !26)
!26 = !{!27}
!27 = !DISubrange(count: 3)
!28 = !DILocation(line: 49, column: 7, scope: !10)
!29 = !DILocation(line: 49, column: 3, scope: !10)
!30 = !DILocation(line: 51, column: 9, scope: !10)
!31 = !DILocation(line: 51, column: 5, scope: !10)
!32 = !DILocation(line: 51, column: 7, scope: !10)
!33 = !DILocation(line: 52, column: 3, scope: !10)
!34 = !DILocation(line: 53, column: 1, scope: !10)
!35 = distinct !DISubprogram(name: "bar", scope: !11, file: !11, line: 33, type: !12, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !21)
!36 = !DILocalVariable(name: "s", arg: 1, scope: !35, file: !11, line: 33, type: !14)
!37 = !DILocation(line: 33, column: 12, scope: !35)
!38 = !DILocalVariable(name: "unused", scope: !35, file: !11, line: 38, type: !19)
!39 = !DILocation(line: 38, column: 7, scope: !35)
!40 = !DILocation(line: 38, column: 3, scope: !35)
!41 = !DILocation(line: 40, column: 1, scope: !35)
!42 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 55, type: !43, scopeLine: 55, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !21)
!43 = !DISubroutineType(types: !44)
!44 = !{!19}
!45 = !DILocalVariable(name: "s", scope: !42, file: !11, line: 59, type: !14)
!46 = !DILocation(line: 59, column: 5, scope: !42)
!47 = !DILocation(line: 59, column: 3, scope: !42)
!48 = !DILocation(line: 61, column: 5, scope: !42)
!49 = !DILocation(line: 61, column: 7, scope: !42)
!50 = !DILocation(line: 62, column: 3, scope: !42)
!51 = !DILocation(line: 63, column: 3, scope: !42)

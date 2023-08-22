; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/out.svf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32* ()* @bar to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 34, i8* null }], section "llvm.metadata"
@.str = private unnamed_addr constant [15 x i8] c"ORANGE_NOSHARE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/heap.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [4 x i8] c"BAR\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [13 x i8] c"ORANGE_SHARE\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32* @bar() #0 !dbg !10 {
  %1 = alloca i32*, align 8
  call void @llvm.dbg.declare(metadata i32** %1, metadata !17, metadata !DIExpression()), !dbg !18
  %2 = bitcast i32** %1 to i8*, !dbg !19
  %3 = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i32 0, i32 0
  %4 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %2, i8* %3, i8* %4, i32 38, i8* null), !dbg !19
  %5 = call noalias i8* @malloc(i64 noundef 4) #4, !dbg !20
  %6 = bitcast i8* %5 to i32*, !dbg !20
  store i32* %6, i32** %1, align 8, !dbg !18
  %7 = load i32*, i32** %1, align 8, !dbg !21
  ret i32* %7, !dbg !22
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !23 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !26, metadata !DIExpression()), !dbg !27
  %4 = bitcast i32* %2 to i8*, !dbg !28
  %5 = getelementptr inbounds [13 x i8], [13 x i8]* @.str.3, i32 0, i32 0
  %6 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %4, i8* %5, i8* %6, i32 47, i8* null), !dbg !28
  store i32 0, i32* %2, align 4, !dbg !27
  call void @llvm.dbg.declare(metadata i32** %3, metadata !29, metadata !DIExpression()), !dbg !30
  %7 = call i32* @bar(), !dbg !31
  store i32* %7, i32** %3, align 8, !dbg !30
  %8 = load i32*, i32** %3, align 8, !dbg !32
  store i32 2, i32* %8, align 4, !dbg !33
  %9 = load i32*, i32** %3, align 8, !dbg !34
  %10 = bitcast i32* %9 to i8*, !dbg !34
  call void @free(i8* noundef %10) #4, !dbg !35
  ret i32 0, !dbg !36
}

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!2}
!llvm.module.flags = !{!3, !4, !5, !6, !7, !8, !9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/heap.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "b48d839108da44814d4e0db29d0615af")
!2 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"PIC Level", i32 2}
!7 = !{i32 7, !"PIE Level", i32 2}
!8 = !{i32 7, !"uwtable", i32 1}
!9 = !{i32 7, !"frame-pointer", i32 2}
!10 = distinct !DISubprogram(name: "bar", scope: !11, file: !11, line: 34, type: !12, scopeLine: 34, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!11 = !DIFile(filename: "heap.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "b48d839108da44814d4e0db29d0615af")
!12 = !DISubroutineType(types: !13)
!13 = !{!14}
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !{}
!17 = !DILocalVariable(name: "x", scope: !10, file: !11, line: 38, type: !14)
!18 = !DILocation(line: 38, column: 8, scope: !10)
!19 = !DILocation(line: 38, column: 3, scope: !10)
!20 = !DILocation(line: 38, column: 12, scope: !10)
!21 = !DILocation(line: 40, column: 10, scope: !10)
!22 = !DILocation(line: 40, column: 3, scope: !10)
!23 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 43, type: !24, scopeLine: 43, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!24 = !DISubroutineType(types: !25)
!25 = !{!15}
!26 = !DILocalVariable(name: "unused", scope: !23, file: !11, line: 47, type: !15)
!27 = !DILocation(line: 47, column: 7, scope: !23)
!28 = !DILocation(line: 47, column: 3, scope: !23)
!29 = !DILocalVariable(name: "y", scope: !23, file: !11, line: 50, type: !14)
!30 = !DILocation(line: 50, column: 8, scope: !23)
!31 = !DILocation(line: 50, column: 12, scope: !23)
!32 = !DILocation(line: 51, column: 4, scope: !23)
!33 = !DILocation(line: 51, column: 6, scope: !23)
!34 = !DILocation(line: 52, column: 8, scope: !23)
!35 = !DILocation(line: 52, column: 3, scope: !23)
!36 = !DILocation(line: 53, column: 3, scope: !23)

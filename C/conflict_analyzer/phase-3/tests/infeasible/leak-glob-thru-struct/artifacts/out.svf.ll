; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/out.svf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.S = type { i32*, i32 }

@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32* @glob to i8*), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 21, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32 ()* @main to i8*), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 43, i8* null }], section "llvm.metadata"
@glob = dso_local global i32 1, align 4, !dbg !0
@.str = private unnamed_addr constant [2 x i8] c"B\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [2 x i8] c"A\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [10 x i8] c"glob: %d\0A\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"MAIN\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !15 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.S, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct.S* %2, metadata !19, metadata !DIExpression()), !dbg !26
  %3 = bitcast %struct.S* %2 to i8*, !dbg !27
  %4 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.2, i32 0, i32 0
  %5 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %3, i8* %4, i8* %5, i32 48, i8* null), !dbg !27
  %6 = getelementptr inbounds %struct.S, %struct.S* %2, i32 0, i32 0, !dbg !28
  store i32* @glob, i32** %6, align 8, !dbg !29
  %7 = getelementptr inbounds %struct.S, %struct.S* %2, i32 0, i32 1, !dbg !30
  store i32 6, i32* %7, align 8, !dbg !31
  %8 = bitcast %struct.S* %2 to { i32*, i32 }*, !dbg !32
  %9 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %8, i32 0, i32 0, !dbg !32
  %10 = load i32*, i32** %9, align 8, !dbg !32
  %11 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %8, i32 0, i32 1, !dbg !32
  %12 = load i32, i32* %11, align 8, !dbg !32
  call void @foo(i32* %10, i32 %12), !dbg !32
  ret i32 0, !dbg !33
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(i32* %0, i32 %1) #0 !dbg !34 {
  %3 = alloca %struct.S, align 8
  %4 = alloca i32, align 4
  %5 = bitcast %struct.S* %3 to { i32*, i32 }*
  %6 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %5, i32 0, i32 0
  store i32* %0, i32** %6, align 8
  %7 = getelementptr inbounds { i32*, i32 }, { i32*, i32 }* %5, i32 0, i32 1
  store i32 %1, i32* %7, align 8
  call void @llvm.dbg.declare(metadata %struct.S* %3, metadata !37, metadata !DIExpression()), !dbg !38
  call void @llvm.dbg.declare(metadata i32* %4, metadata !39, metadata !DIExpression()), !dbg !40
  %8 = bitcast i32* %4 to i8*, !dbg !41
  %9 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.2, i32 0, i32 0
  %10 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %8, i8* %9, i8* %10, i32 34, i8* null), !dbg !41
  store i32 0, i32* %4, align 4, !dbg !40
  %11 = getelementptr inbounds %struct.S, %struct.S* %3, i32 0, i32 0, !dbg !42
  %12 = load i32*, i32** %11, align 8, !dbg !42
  %13 = load i32, i32* %12, align 4, !dbg !43
  %14 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.3, i64 0, i64 0
  %15 = call i32 (i8*, ...) @printf(i8* noundef %14, i32 noundef %13), !dbg !44
  ret void, !dbg !45
}

declare i32 @printf(i8* noundef, ...) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!2}
!llvm.ident = !{!7}
!llvm.module.flags = !{!8, !9, !10, !11, !12, !13, !14}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "glob", scope: !2, file: !5, line: 21, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "462332277cf3914f57c6e1a547297130")
!4 = !{!0}
!5 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "462332277cf3914f57c6e1a547297130")
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!8 = !{i32 7, !"Dwarf Version", i32 5}
!9 = !{i32 2, !"Debug Info Version", i32 3}
!10 = !{i32 1, !"wchar_size", i32 4}
!11 = !{i32 7, !"PIC Level", i32 2}
!12 = !{i32 7, !"PIE Level", i32 2}
!13 = !{i32 7, !"uwtable", i32 1}
!14 = !{i32 7, !"frame-pointer", i32 2}
!15 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 43, type: !16, scopeLine: 43, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !18)
!16 = !DISubroutineType(types: !17)
!17 = !{!6}
!18 = !{}
!19 = !DILocalVariable(name: "s", scope: !15, file: !5, line: 48, type: !20)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "S", file: !5, line: 27, baseType: !21)
!21 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !5, line: 24, size: 128, elements: !22)
!22 = !{!23, !25}
!23 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !21, file: !5, line: 25, baseType: !24, size: 64)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !21, file: !5, line: 26, baseType: !6, size: 32, offset: 64)
!26 = !DILocation(line: 48, column: 5, scope: !15)
!27 = !DILocation(line: 48, column: 3, scope: !15)
!28 = !DILocation(line: 51, column: 5, scope: !15)
!29 = !DILocation(line: 51, column: 7, scope: !15)
!30 = !DILocation(line: 52, column: 5, scope: !15)
!31 = !DILocation(line: 52, column: 7, scope: !15)
!32 = !DILocation(line: 54, column: 3, scope: !15)
!33 = !DILocation(line: 55, column: 3, scope: !15)
!34 = distinct !DISubprogram(name: "foo", scope: !5, file: !5, line: 29, type: !35, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !18)
!35 = !DISubroutineType(types: !36)
!36 = !{null, !20}
!37 = !DILocalVariable(name: "s", arg: 1, scope: !34, file: !5, line: 29, type: !20)
!38 = !DILocation(line: 29, column: 12, scope: !34)
!39 = !DILocalVariable(name: "unused", scope: !34, file: !5, line: 34, type: !6)
!40 = !DILocation(line: 34, column: 7, scope: !34)
!41 = !DILocation(line: 34, column: 3, scope: !34)
!42 = !DILocation(line: 38, column: 28, scope: !34)
!43 = !DILocation(line: 38, column: 24, scope: !34)
!44 = !DILocation(line: 38, column: 3, scope: !34)
!45 = !DILocation(line: 39, column: 1, scope: !34)

; ModuleID = '/home/bflin/gaps/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c'
source_filename = "/home/bflin/gaps/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"FOO\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [64 x i8] c"/home/bflin/gaps/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [16 x i8] c"GREEN_SHAREABLE\00", section "llvm.metadata"
@__const.main.buf = private unnamed_addr constant [5 x i32] [i32 0, i32 1, i32 2, i32 3, i32 4], align 16
@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32 (i32*)* @foo to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.1, i32 0, i32 0), i8* getelementptr inbounds ([64 x i8], [64 x i8]* @.str.2, i32 0, i32 0), i32 43, i8* null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo(i32* noundef %0) #0 !dbg !10 {
  %2 = alloca i32*, align 8
  store i32* %0, i32** %2, align 8
  call void @llvm.dbg.declare(metadata i32** %2, metadata !17, metadata !DIExpression()), !dbg !18
  %3 = load i32*, i32** %2, align 8, !dbg !19
  %4 = getelementptr inbounds i32, i32* %3, i64 0, !dbg !19
  %5 = load i32, i32* %4, align 4, !dbg !19
  %6 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %5), !dbg !20
  ret i32 0, !dbg !21
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare i32 @printf(i8* noundef, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !22 {
  %1 = alloca i32, align 4
  %2 = alloca [5 x i32], align 16
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [5 x i32]* %2, metadata !25, metadata !DIExpression()), !dbg !29
  %3 = bitcast [5 x i32]* %2 to i8*, !dbg !30
  call void @llvm.var.annotation(i8* %3, i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([64 x i8], [64 x i8]* @.str.2, i32 0, i32 0), i32 53, i8* null), !dbg !30
  %4 = bitcast [5 x i32]* %2 to i8*, !dbg !29
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %4, i8* align 16 bitcast ([5 x i32]* @__const.main.buf to i8*), i64 20, i1 false), !dbg !29
  %5 = getelementptr inbounds [5 x i32], [5 x i32]* %2, i64 0, i64 0, !dbg !31
  %6 = call i32 @foo(i32* noundef %5), !dbg !32
  ret i32 0, !dbg !33
}

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #3

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #4 = { argmemonly nofree nounwind willreturn }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/bflin/gaps/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/bflin/gaps/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "3984f7f2c9bafe9879c89bc3f00d9748")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.6"}
!10 = distinct !DISubprogram(name: "foo", scope: !11, file: !11, line: 43, type: !12, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!11 = !DIFile(filename: "prog.c", directory: "/home/bflin/gaps/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "3984f7f2c9bafe9879c89bc3f00d9748")
!12 = !DISubroutineType(types: !13)
!13 = !{!14, !15}
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!16 = !{}
!17 = !DILocalVariable(name: "buf", arg: 1, scope: !10, file: !11, line: 43, type: !15)
!18 = !DILocation(line: 43, column: 14, scope: !10)
!19 = !DILocation(line: 45, column: 20, scope: !10)
!20 = !DILocation(line: 45, column: 5, scope: !10)
!21 = !DILocation(line: 46, column: 5, scope: !10)
!22 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 49, type: !23, scopeLine: 49, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!23 = !DISubroutineType(types: !24)
!24 = !{!14}
!25 = !DILocalVariable(name: "buf", scope: !22, file: !11, line: 53, type: !26)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 160, elements: !27)
!27 = !{!28}
!28 = !DISubrange(count: 5)
!29 = !DILocation(line: 53, column: 9, scope: !22)
!30 = !DILocation(line: 53, column: 5, scope: !22)
!31 = !DILocation(line: 55, column: 9, scope: !22)
!32 = !DILocation(line: 55, column: 5, scope: !22)
!33 = !DILocation(line: 56, column: 5, scope: !22)

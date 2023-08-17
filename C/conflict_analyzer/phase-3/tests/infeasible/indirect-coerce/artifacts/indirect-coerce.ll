; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/indirect-coerce.c'
source_filename = "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/indirect-coerce.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [9 x i8] c"ORANGE_2\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [82 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/indirect-coerce.c\00", section "llvm.metadata"
@main.b = internal global i32 1, align 4, !dbg !0
@.str.2 = private unnamed_addr constant [9 x i8] c"ORANGE_1\00", section "llvm.metadata"
@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32* @main.b to i8*), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([82 x i8], [82 x i8]* @.str.1, i32 0, i32 0), i32 26, i8* null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo() #0 !dbg !19 {
  %1 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %1, metadata !20, metadata !DIExpression()), !dbg !21
  %2 = bitcast i32* %1 to i8*, !dbg !22
  call void @llvm.var.annotation(i8* %2, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([82 x i8], [82 x i8]* @.str.1, i32 0, i32 0), i32 15, i8* null), !dbg !22
  store i32 5, i32* %1, align 4, !dbg !21
  %3 = load i32, i32* %1, align 4, !dbg !23
  ret i32 %3, !dbg !24
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !2 {
  %1 = alloca i32, align 4
  %2 = alloca i32 ()*, align 8
  %3 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32 ()** %2, metadata !25, metadata !DIExpression()), !dbg !27
  store i32 ()* @foo, i32 ()** %2, align 8, !dbg !27
  call void @llvm.dbg.declare(metadata i32* %3, metadata !28, metadata !DIExpression()), !dbg !29
  %4 = load i32 ()*, i32 ()** %2, align 8, !dbg !30
  %5 = call i32 %4(), !dbg !31
  store i32 %5, i32* %3, align 4, !dbg !29
  ret i32 0, !dbg !32
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!11, !12, !13, !14, !15, !16, !17}
!llvm.ident = !{!18}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "b", scope: !2, file: !3, line: 26, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 22, type: !4, scopeLine: 22, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !10)
!3 = !DIFile(filename: "indirect-coerce.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "ad5b1e3da24147a8d35ae13266ddc9fc")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/indirect-coerce.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "ad5b1e3da24147a8d35ae13266ddc9fc")
!9 = !{!0}
!10 = !{}
!11 = !{i32 7, !"Dwarf Version", i32 5}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{i32 1, !"wchar_size", i32 4}
!14 = !{i32 7, !"PIC Level", i32 2}
!15 = !{i32 7, !"PIE Level", i32 2}
!16 = !{i32 7, !"uwtable", i32 1}
!17 = !{i32 7, !"frame-pointer", i32 2}
!18 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!19 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 11, type: !4, scopeLine: 11, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !10)
!20 = !DILocalVariable(name: "a", scope: !19, file: !3, line: 15, type: !6)
!21 = !DILocation(line: 15, column: 7, scope: !19)
!22 = !DILocation(line: 15, column: 3, scope: !19)
!23 = !DILocation(line: 18, column: 10, scope: !19)
!24 = !DILocation(line: 18, column: 3, scope: !19)
!25 = !DILocalVariable(name: "f", scope: !2, file: !3, line: 28, type: !26)
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!27 = !DILocation(line: 28, column: 9, scope: !2)
!28 = !DILocalVariable(name: "c", scope: !2, file: !3, line: 29, type: !6)
!29 = !DILocation(line: 29, column: 7, scope: !2)
!30 = !DILocation(line: 29, column: 13, scope: !2)
!31 = !DILocation(line: 29, column: 11, scope: !2)
!32 = !DILocation(line: 31, column: 3, scope: !2)

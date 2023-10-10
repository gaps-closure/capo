; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/out.svf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo() #0 !dbg !10 {
  %1 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata i32* %1, metadata !16, metadata !DIExpression()), !dbg !17
  %2 = bitcast i32* %1 to i8*, !dbg !18
  %3 = getelementptr inbounds [7 x i8], [7 x i8]* @.str, i32 0, i32 0
  %4 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %2, i8* %3, i8* %4, i32 10, i8* null), !dbg !18
  store i32 5, i32* %1, align 4, !dbg !17
  %5 = load i32, i32* %1, align 4, !dbg !19
  ret i32 %5, !dbg !20
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !21 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32 ()*, align 8
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !22, metadata !DIExpression()), !dbg !23
  %5 = bitcast i32* %2 to i8*, !dbg !24
  %6 = getelementptr inbounds [7 x i8], [7 x i8]* @.str, i32 0, i32 0
  %7 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %5, i8* %6, i8* %7, i32 21, i8* null), !dbg !24
  store i32 1, i32* %2, align 4, !dbg !23
  call void @llvm.dbg.declare(metadata i32 ()** %3, metadata !25, metadata !DIExpression()), !dbg !27
  store i32 ()* @foo, i32 ()** %3, align 8, !dbg !27
  call void @llvm.dbg.declare(metadata i32* %4, metadata !28, metadata !DIExpression()), !dbg !29
  %8 = load i32 ()*, i32 ()** %3, align 8, !dbg !30
  %9 = call i32 %8(), !dbg !31
  store i32 %9, i32* %4, align 4, !dbg !29
  ret i32 0, !dbg !32
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!2}
!llvm.module.flags = !{!3, !4, !5, !6, !7, !8, !9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "c325d71611c079e95a42857e30061d7a")
!2 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"PIC Level", i32 2}
!7 = !{i32 7, !"PIE Level", i32 2}
!8 = !{i32 7, !"uwtable", i32 1}
!9 = !{i32 7, !"frame-pointer", i32 2}
!10 = distinct !DISubprogram(name: "foo", scope: !11, file: !11, line: 6, type: !12, scopeLine: 6, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!11 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "c325d71611c079e95a42857e30061d7a")
!12 = !DISubroutineType(types: !13)
!13 = !{!14}
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !{}
!16 = !DILocalVariable(name: "a", scope: !10, file: !11, line: 10, type: !14)
!17 = !DILocation(line: 10, column: 7, scope: !10)
!18 = !DILocation(line: 10, column: 3, scope: !10)
!19 = !DILocation(line: 13, column: 10, scope: !10)
!20 = !DILocation(line: 13, column: 3, scope: !10)
!21 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 17, type: !12, scopeLine: 17, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!22 = !DILocalVariable(name: "b", scope: !21, file: !11, line: 21, type: !14)
!23 = !DILocation(line: 21, column: 7, scope: !21)
!24 = !DILocation(line: 21, column: 3, scope: !21)
!25 = !DILocalVariable(name: "f", scope: !21, file: !11, line: 23, type: !26)
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!27 = !DILocation(line: 23, column: 9, scope: !21)
!28 = !DILocalVariable(name: "c", scope: !21, file: !11, line: 24, type: !14)
!29 = !DILocation(line: 24, column: 7, scope: !21)
!30 = !DILocation(line: 24, column: 13, scope: !21)
!31 = !DILocation(line: 24, column: 11, scope: !21)
!32 = !DILocation(line: 26, column: 3, scope: !21)

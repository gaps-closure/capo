; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/out.svf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo(i32 noundef %0) #0 !dbg !10 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata i32* %3, metadata !18, metadata !DIExpression()), !dbg !19
  %4 = bitcast i32* %3 to i8*, !dbg !20
  %5 = getelementptr inbounds [7 x i8], [7 x i8]* @.str, i32 0, i32 0
  %6 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %4, i8* %5, i8* %6, i32 14, i8* null), !dbg !20
  store i32 5, i32* %3, align 4, !dbg !19
  %7 = load i32, i32* %3, align 4, !dbg !21
  %8 = load i32, i32* %2, align 4, !dbg !22
  %9 = mul nsw i32 %7, %8, !dbg !23
  ret i32 %9, !dbg !24
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @bar(i32 noundef %0, i32 noundef %1) #0 !dbg !25 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !28, metadata !DIExpression()), !dbg !29
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !30, metadata !DIExpression()), !dbg !31
  %5 = load i32, i32* %3, align 4, !dbg !32
  %6 = load i32, i32* %4, align 4, !dbg !33
  %7 = mul nsw i32 %5, %6, !dbg !34
  ret i32 %7, !dbg !35
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !36 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32 (i32)*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !39, metadata !DIExpression()), !dbg !40
  %7 = bitcast i32* %2 to i8*, !dbg !41
  %8 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.2, i32 0, i32 0
  %9 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %7, i8* %8, i8* %9, i32 29, i8* null), !dbg !41
  store i32 1, i32* %2, align 4, !dbg !40
  call void @llvm.dbg.declare(metadata i32* %3, metadata !42, metadata !DIExpression()), !dbg !43
  store i32 3, i32* %3, align 4, !dbg !43
  call void @llvm.dbg.declare(metadata i32 (i32)** %4, metadata !44, metadata !DIExpression()), !dbg !46
  store i32 (i32)* @foo, i32 (i32)** %4, align 8, !dbg !46
  call void @llvm.dbg.declare(metadata i32* %5, metadata !47, metadata !DIExpression()), !dbg !48
  %10 = load i32 (i32)*, i32 (i32)** %4, align 8, !dbg !49
  %11 = load i32, i32* %3, align 4, !dbg !50
  %12 = call i32 %10(i32 noundef %11), !dbg !51
  store i32 %12, i32* %5, align 4, !dbg !48
  call void @llvm.dbg.declare(metadata i32* %6, metadata !52, metadata !DIExpression()), !dbg !53
  %13 = load i32, i32* %2, align 4, !dbg !54
  %14 = load i32, i32* %3, align 4, !dbg !55
  %15 = call i32 @bar(i32 noundef %13, i32 noundef %14), !dbg !56
  store i32 %15, i32* %6, align 4, !dbg !53
  ret i32 0, !dbg !57
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }

!llvm.dbg.cu = !{!0}
!llvm.ident = !{!2}
!llvm.module.flags = !{!3, !4, !5, !6, !7, !8, !9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "42a6a8941ff89e7f9c5a98dd74396714")
!2 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!3 = !{i32 7, !"Dwarf Version", i32 5}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"PIC Level", i32 2}
!7 = !{i32 7, !"PIE Level", i32 2}
!8 = !{i32 7, !"uwtable", i32 1}
!9 = !{i32 7, !"frame-pointer", i32 2}
!10 = distinct !DISubprogram(name: "foo", scope: !11, file: !11, line: 10, type: !12, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!11 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "42a6a8941ff89e7f9c5a98dd74396714")
!12 = !DISubroutineType(types: !13)
!13 = !{!14, !14}
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !{}
!16 = !DILocalVariable(name: "mul", arg: 1, scope: !10, file: !11, line: 10, type: !14)
!17 = !DILocation(line: 10, column: 13, scope: !10)
!18 = !DILocalVariable(name: "a", scope: !10, file: !11, line: 14, type: !14)
!19 = !DILocation(line: 14, column: 7, scope: !10)
!20 = !DILocation(line: 14, column: 3, scope: !10)
!21 = !DILocation(line: 17, column: 10, scope: !10)
!22 = !DILocation(line: 17, column: 14, scope: !10)
!23 = !DILocation(line: 17, column: 12, scope: !10)
!24 = !DILocation(line: 17, column: 3, scope: !10)
!25 = distinct !DISubprogram(name: "bar", scope: !11, file: !11, line: 20, type: !26, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!26 = !DISubroutineType(types: !27)
!27 = !{!14, !14, !14}
!28 = !DILocalVariable(name: "y", arg: 1, scope: !25, file: !11, line: 20, type: !14)
!29 = !DILocation(line: 20, column: 13, scope: !25)
!30 = !DILocalVariable(name: "z", arg: 2, scope: !25, file: !11, line: 20, type: !14)
!31 = !DILocation(line: 20, column: 20, scope: !25)
!32 = !DILocation(line: 21, column: 10, scope: !25)
!33 = !DILocation(line: 21, column: 14, scope: !25)
!34 = !DILocation(line: 21, column: 12, scope: !25)
!35 = !DILocation(line: 21, column: 3, scope: !25)
!36 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 25, type: !37, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!37 = !DISubroutineType(types: !38)
!38 = !{!14}
!39 = !DILocalVariable(name: "b", scope: !36, file: !11, line: 29, type: !14)
!40 = !DILocation(line: 29, column: 7, scope: !36)
!41 = !DILocation(line: 29, column: 3, scope: !36)
!42 = !DILocalVariable(name: "mul", scope: !36, file: !11, line: 32, type: !14)
!43 = !DILocation(line: 32, column: 7, scope: !36)
!44 = !DILocalVariable(name: "f", scope: !36, file: !11, line: 33, type: !45)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!46 = !DILocation(line: 33, column: 9, scope: !36)
!47 = !DILocalVariable(name: "c", scope: !36, file: !11, line: 34, type: !14)
!48 = !DILocation(line: 34, column: 7, scope: !36)
!49 = !DILocation(line: 34, column: 13, scope: !36)
!50 = !DILocation(line: 34, column: 16, scope: !36)
!51 = !DILocation(line: 34, column: 11, scope: !36)
!52 = !DILocalVariable(name: "d", scope: !36, file: !11, line: 36, type: !14)
!53 = !DILocation(line: 36, column: 7, scope: !36)
!54 = !DILocation(line: 36, column: 15, scope: !36)
!55 = !DILocation(line: 36, column: 18, scope: !36)
!56 = !DILocation(line: 36, column: 11, scope: !36)
!57 = !DILocation(line: 38, column: 3, scope: !36)

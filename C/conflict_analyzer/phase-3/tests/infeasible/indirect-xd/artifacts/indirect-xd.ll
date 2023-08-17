; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/indirect-xd.c'
source_filename = "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/indirect-xd.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@foo.a = internal global i32 5, align 4, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [78 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/indirect-xd.c\00", section "llvm.metadata"
@main.b = internal global i32 1, align 4, !dbg !10
@.str.2 = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32* @foo.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i32 0, i32 0), i32 14, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32* @main.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([78 x i8], [78 x i8]* @.str.1, i32 0, i32 0), i32 25, i8* null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @foo(i32 noundef %0) #0 !dbg !2 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !24, metadata !DIExpression()), !dbg !25
  %3 = load i32, i32* @foo.a, align 4, !dbg !26
  %4 = load i32, i32* %2, align 4, !dbg !27
  %5 = mul nsw i32 %3, %4, !dbg !28
  ret i32 %5, !dbg !29
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !12 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32 (i32)*, align 8
  %4 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !30, metadata !DIExpression()), !dbg !31
  store i32 3, i32* %2, align 4, !dbg !31
  call void @llvm.dbg.declare(metadata i32 (i32)** %3, metadata !32, metadata !DIExpression()), !dbg !34
  store i32 (i32)* @foo, i32 (i32)** %3, align 8, !dbg !34
  call void @llvm.dbg.declare(metadata i32* %4, metadata !35, metadata !DIExpression()), !dbg !36
  %5 = load i32 (i32)*, i32 (i32)** %3, align 8, !dbg !37
  %6 = load i32, i32* %2, align 4, !dbg !38
  %7 = call i32 %5(i32 noundef %6), !dbg !39
  store i32 %7, i32* %4, align 4, !dbg !36
  ret i32 0, !dbg !40
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!16, !17, !18, !19, !20, !21, !22}
!llvm.ident = !{!23}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 14, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "foo", scope: !3, file: !3, line: 10, type: !4, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!3 = !DIFile(filename: "indirect-xd.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "c8b71d155f4490d9398727beacb6f353")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/indirect-xd.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "c8b71d155f4490d9398727beacb6f353")
!9 = !{!0, !10}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "b", scope: !12, file: !3, line: 25, type: !6, isLocal: true, isDefinition: true)
!12 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 21, type: !13, scopeLine: 21, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!13 = !DISubroutineType(types: !14)
!14 = !{!6}
!15 = !{}
!16 = !{i32 7, !"Dwarf Version", i32 5}
!17 = !{i32 2, !"Debug Info Version", i32 3}
!18 = !{i32 1, !"wchar_size", i32 4}
!19 = !{i32 7, !"PIC Level", i32 2}
!20 = !{i32 7, !"PIE Level", i32 2}
!21 = !{i32 7, !"uwtable", i32 1}
!22 = !{i32 7, !"frame-pointer", i32 2}
!23 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!24 = !DILocalVariable(name: "mul", arg: 1, scope: !2, file: !3, line: 10, type: !6)
!25 = !DILocation(line: 10, column: 13, scope: !2)
!26 = !DILocation(line: 17, column: 10, scope: !2)
!27 = !DILocation(line: 17, column: 14, scope: !2)
!28 = !DILocation(line: 17, column: 12, scope: !2)
!29 = !DILocation(line: 17, column: 3, scope: !2)
!30 = !DILocalVariable(name: "mul", scope: !12, file: !3, line: 28, type: !6)
!31 = !DILocation(line: 28, column: 7, scope: !12)
!32 = !DILocalVariable(name: "f", scope: !12, file: !3, line: 29, type: !33)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!34 = !DILocation(line: 29, column: 9, scope: !12)
!35 = !DILocalVariable(name: "c", scope: !12, file: !3, line: 30, type: !6)
!36 = !DILocation(line: 30, column: 7, scope: !12)
!37 = !DILocation(line: 30, column: 13, scope: !12)
!38 = !DILocation(line: 30, column: 16, scope: !12)
!39 = !DILocation(line: 30, column: 11, scope: !12)
!40 = !DILocation(line: 32, column: 3, scope: !12)

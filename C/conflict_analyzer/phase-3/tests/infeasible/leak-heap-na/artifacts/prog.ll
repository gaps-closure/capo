; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c'
source_filename = "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [15 x i8] c"ORANGE_NOSHARE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [4 x i8] c"BAR\00", section "llvm.metadata"
@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32* ()* @bar to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 34, i8* null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32* @bar() #0 !dbg !10 {
  %1 = alloca i32*, align 8
  call void @llvm.dbg.declare(metadata i32** %1, metadata !17, metadata !DIExpression()), !dbg !18
  %2 = bitcast i32** %1 to i8*, !dbg !19
  call void @llvm.var.annotation(i8* %2, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 38, i8* null), !dbg !19
  %3 = call noalias i8* @malloc(i64 noundef 4) #4, !dbg !20
  %4 = bitcast i8* %3 to i32*, !dbg !20
  store i32* %4, i32** %1, align 8, !dbg !18
  %5 = load i32*, i32** %1, align 8, !dbg !21
  ret i32* %5, !dbg !22
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
  %2 = alloca i32*, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i32** %2, metadata !26, metadata !DIExpression()), !dbg !27
  %3 = call i32* @bar(), !dbg !28
  store i32* %3, i32** %2, align 8, !dbg !27
  ret i32 0, !dbg !29
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "d173b3188218dec4ebeebcf1667d3515")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!10 = distinct !DISubprogram(name: "bar", scope: !11, file: !11, line: 34, type: !12, scopeLine: 34, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !16)
!11 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "d173b3188218dec4ebeebcf1667d3515")
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
!26 = !DILocalVariable(name: "y", scope: !23, file: !11, line: 44, type: !14)
!27 = !DILocation(line: 44, column: 8, scope: !23)
!28 = !DILocation(line: 44, column: 12, scope: !23)
!29 = !DILocation(line: 45, column: 3, scope: !23)

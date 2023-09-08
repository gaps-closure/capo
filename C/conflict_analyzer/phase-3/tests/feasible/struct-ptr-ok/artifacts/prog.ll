; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c'
source_filename = "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.S = type { i32*, i32 }
%struct.S2 = type { %struct.S*, i32* }

@glob = dso_local global i32 1, align 4, !dbg !0
@.str = private unnamed_addr constant [2 x i8] c"B\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [2 x i8] c"A\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [7 x i8] c"b: %d\0A\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"MAIN\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32* @glob to i8*), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 21, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32 ()* @main to i8*), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 47, i8* null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(%struct.S* noundef %0) #0 !dbg !15 {
  %2 = alloca %struct.S*, align 8
  %3 = alloca i32, align 4
  store %struct.S* %0, %struct.S** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.S** %2, metadata !26, metadata !DIExpression()), !dbg !27
  call void @llvm.dbg.declare(metadata i32* %3, metadata !28, metadata !DIExpression()), !dbg !29
  %4 = bitcast i32* %3 to i8*, !dbg !30
  call void @llvm.var.annotation(i8* %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 39, i8* null), !dbg !30
  store i32 0, i32* %3, align 4, !dbg !29
  %5 = load %struct.S*, %struct.S** %2, align 8, !dbg !31
  %6 = getelementptr inbounds %struct.S, %struct.S* %5, i32 0, i32 1, !dbg !32
  %7 = load i32, i32* %6, align 8, !dbg !32
  %8 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i64 0, i64 0), i32 noundef %7), !dbg !33
  ret void, !dbg !34
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

declare i32 @printf(i8* noundef, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !35 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.S2, align 8
  %3 = alloca %struct.S, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct.S2* %2, metadata !38, metadata !DIExpression()), !dbg !44
  %4 = bitcast %struct.S2* %2 to i8*, !dbg !45
  call void @llvm.var.annotation(i8* %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 52, i8* null), !dbg !45
  %5 = getelementptr inbounds %struct.S2, %struct.S2* %2, i32 0, i32 1, !dbg !46
  store i32* @glob, i32** %5, align 8, !dbg !47
  call void @llvm.dbg.declare(metadata %struct.S* %3, metadata !48, metadata !DIExpression()), !dbg !49
  %6 = bitcast %struct.S* %3 to i8*, !dbg !50
  call void @llvm.var.annotation(i8* %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 58, i8* null), !dbg !50
  %7 = getelementptr inbounds %struct.S, %struct.S* %3, i32 0, i32 0, !dbg !51
  store i32* null, i32** %7, align 8, !dbg !52
  %8 = getelementptr inbounds %struct.S, %struct.S* %3, i32 0, i32 1, !dbg !53
  store i32 6, i32* %8, align 8, !dbg !54
  %9 = getelementptr inbounds %struct.S2, %struct.S2* %2, i32 0, i32 0, !dbg !55
  store %struct.S* %3, %struct.S** %9, align 8, !dbg !56
  %10 = getelementptr inbounds %struct.S2, %struct.S2* %2, i32 0, i32 0, !dbg !57
  %11 = load %struct.S*, %struct.S** %10, align 8, !dbg !57
  call void @foo(%struct.S* noundef %11), !dbg !58
  ret i32 0, !dbg !59
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!7, !8, !9, !10, !11, !12, !13}
!llvm.ident = !{!14}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "glob", scope: !2, file: !5, line: 21, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "475740880ddee79a510e07aad153d7e5")
!4 = !{!0}
!5 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "475740880ddee79a510e07aad153d7e5")
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{i32 7, !"Dwarf Version", i32 5}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = !{i32 7, !"PIC Level", i32 2}
!11 = !{i32 7, !"PIE Level", i32 2}
!12 = !{i32 7, !"uwtable", i32 1}
!13 = !{i32 7, !"frame-pointer", i32 2}
!14 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!15 = distinct !DISubprogram(name: "foo", scope: !5, file: !5, line: 34, type: !16, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!16 = !DISubroutineType(types: !17)
!17 = !{null, !18}
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "S", file: !5, line: 27, baseType: !20)
!20 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !5, line: 24, size: 128, elements: !21)
!21 = !{!22, !24}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !20, file: !5, line: 25, baseType: !23, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !20, file: !5, line: 26, baseType: !6, size: 32, offset: 64)
!25 = !{}
!26 = !DILocalVariable(name: "s1", arg: 1, scope: !15, file: !5, line: 34, type: !18)
!27 = !DILocation(line: 34, column: 13, scope: !15)
!28 = !DILocalVariable(name: "unused", scope: !15, file: !5, line: 39, type: !6)
!29 = !DILocation(line: 39, column: 7, scope: !15)
!30 = !DILocation(line: 39, column: 3, scope: !15)
!31 = !DILocation(line: 42, column: 21, scope: !15)
!32 = !DILocation(line: 42, column: 25, scope: !15)
!33 = !DILocation(line: 42, column: 3, scope: !15)
!34 = !DILocation(line: 43, column: 1, scope: !15)
!35 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 47, type: !36, scopeLine: 47, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !25)
!36 = !DISubroutineType(types: !37)
!37 = !{!6}
!38 = !DILocalVariable(name: "s2", scope: !35, file: !5, line: 52, type: !39)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "S2", file: !5, line: 32, baseType: !40)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !5, line: 29, size: 128, elements: !41)
!41 = !{!42, !43}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "s1", scope: !40, file: !5, line: 30, baseType: !18, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "c", scope: !40, file: !5, line: 31, baseType: !23, size: 64, offset: 64)
!44 = !DILocation(line: 52, column: 6, scope: !35)
!45 = !DILocation(line: 52, column: 3, scope: !35)
!46 = !DILocation(line: 54, column: 6, scope: !35)
!47 = !DILocation(line: 54, column: 8, scope: !35)
!48 = !DILocalVariable(name: "s", scope: !35, file: !5, line: 58, type: !19)
!49 = !DILocation(line: 58, column: 5, scope: !35)
!50 = !DILocation(line: 58, column: 3, scope: !35)
!51 = !DILocation(line: 60, column: 5, scope: !35)
!52 = !DILocation(line: 60, column: 7, scope: !35)
!53 = !DILocation(line: 61, column: 5, scope: !35)
!54 = !DILocation(line: 61, column: 7, scope: !35)
!55 = !DILocation(line: 63, column: 6, scope: !35)
!56 = !DILocation(line: 63, column: 9, scope: !35)
!57 = !DILocation(line: 64, column: 10, scope: !35)
!58 = !DILocation(line: 64, column: 3, scope: !35)
!59 = !DILocation(line: 65, column: 3, scope: !35)

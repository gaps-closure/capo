; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c'
source_filename = "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.S2 = type { %struct.S*, i32 }
%struct.S = type { i32*, i32 }

@glob = dso_local global i32 1, align 4, !dbg !0
@.str = private unnamed_addr constant [2 x i8] c"B\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [2 x i8] c"A\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [10 x i8] c"glob: %d\0A\00", align 1
@.str.4 = private unnamed_addr constant [5 x i8] c"MAIN\00", section "llvm.metadata"
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32* @glob to i8*), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 21, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32 ()* @main to i8*), i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 48, i8* null }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @foo(%struct.S2* noundef %0) #0 !dbg !15 {
  %2 = alloca %struct.S2*, align 8
  %3 = alloca i32, align 4
  store %struct.S2* %0, %struct.S2** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.S2** %2, metadata !32, metadata !DIExpression()), !dbg !33
  call void @llvm.dbg.declare(metadata i32* %3, metadata !34, metadata !DIExpression()), !dbg !35
  %4 = bitcast i32* %3 to i8*, !dbg !36
  call void @llvm.var.annotation(i8* %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 39, i8* null), !dbg !36
  store i32 0, i32* %3, align 4, !dbg !35
  %5 = load %struct.S2*, %struct.S2** %2, align 8, !dbg !37
  %6 = getelementptr inbounds %struct.S2, %struct.S2* %5, i32 0, i32 0, !dbg !38
  %7 = load %struct.S*, %struct.S** %6, align 8, !dbg !38
  %8 = getelementptr inbounds %struct.S, %struct.S* %7, i32 0, i32 0, !dbg !39
  %9 = load i32*, i32** %8, align 8, !dbg !39
  %10 = load i32, i32* %9, align 4, !dbg !40
  %11 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([10 x i8], [10 x i8]* @.str.3, i64 0, i64 0), i32 noundef %10), !dbg !41
  ret void, !dbg !42
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

declare i32 @printf(i8* noundef, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !43 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.S2, align 8
  %3 = alloca %struct.S, align 8
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata %struct.S2* %2, metadata !46, metadata !DIExpression()), !dbg !47
  %4 = bitcast %struct.S2* %2 to i8*, !dbg !48
  call void @llvm.var.annotation(i8* %4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 53, i8* null), !dbg !48
  %5 = getelementptr inbounds %struct.S2, %struct.S2* %2, i32 0, i32 1, !dbg !49
  store i32 0, i32* %5, align 8, !dbg !50
  call void @llvm.dbg.declare(metadata %struct.S* %3, metadata !51, metadata !DIExpression()), !dbg !52
  %6 = bitcast %struct.S* %3 to i8*, !dbg !53
  call void @llvm.var.annotation(i8* %6, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 59, i8* null), !dbg !53
  %7 = getelementptr inbounds %struct.S, %struct.S* %3, i32 0, i32 0, !dbg !54
  store i32* @glob, i32** %7, align 8, !dbg !55
  %8 = getelementptr inbounds %struct.S, %struct.S* %3, i32 0, i32 1, !dbg !56
  store i32 6, i32* %8, align 8, !dbg !57
  %9 = getelementptr inbounds %struct.S2, %struct.S2* %2, i32 0, i32 0, !dbg !58
  store %struct.S* %3, %struct.S** %9, align 8, !dbg !59
  call void @foo(%struct.S2* noundef %2), !dbg !60
  ret i32 0, !dbg !61
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
!3 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "ad9bbac57b2d044bec299aa4aaadd60c")
!4 = !{!0}
!5 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "ad9bbac57b2d044bec299aa4aaadd60c")
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{i32 7, !"Dwarf Version", i32 5}
!8 = !{i32 2, !"Debug Info Version", i32 3}
!9 = !{i32 1, !"wchar_size", i32 4}
!10 = !{i32 7, !"PIC Level", i32 2}
!11 = !{i32 7, !"PIE Level", i32 2}
!12 = !{i32 7, !"uwtable", i32 1}
!13 = !{i32 7, !"frame-pointer", i32 2}
!14 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!15 = distinct !DISubprogram(name: "foo", scope: !5, file: !5, line: 34, type: !16, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !31)
!16 = !DISubroutineType(types: !17)
!17 = !{null, !18}
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "S2", file: !5, line: 32, baseType: !20)
!20 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !5, line: 29, size: 128, elements: !21)
!21 = !{!22, !30}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "s1", scope: !20, file: !5, line: 30, baseType: !23, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "S", file: !5, line: 27, baseType: !25)
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !5, line: 24, size: 128, elements: !26)
!26 = !{!27, !29}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !25, file: !5, line: 25, baseType: !28, size: 64)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "b", scope: !25, file: !5, line: 26, baseType: !6, size: 32, offset: 64)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "c", scope: !20, file: !5, line: 31, baseType: !6, size: 32, offset: 64)
!31 = !{}
!32 = !DILocalVariable(name: "s2", arg: 1, scope: !15, file: !5, line: 34, type: !18)
!33 = !DILocation(line: 34, column: 14, scope: !15)
!34 = !DILocalVariable(name: "unused", scope: !15, file: !5, line: 39, type: !6)
!35 = !DILocation(line: 39, column: 7, scope: !15)
!36 = !DILocation(line: 39, column: 3, scope: !15)
!37 = !DILocation(line: 43, column: 26, scope: !15)
!38 = !DILocation(line: 43, column: 30, scope: !15)
!39 = !DILocation(line: 43, column: 34, scope: !15)
!40 = !DILocation(line: 43, column: 24, scope: !15)
!41 = !DILocation(line: 43, column: 3, scope: !15)
!42 = !DILocation(line: 44, column: 1, scope: !15)
!43 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 48, type: !44, scopeLine: 48, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !31)
!44 = !DISubroutineType(types: !45)
!45 = !{!6}
!46 = !DILocalVariable(name: "s2", scope: !43, file: !5, line: 53, type: !19)
!47 = !DILocation(line: 53, column: 6, scope: !43)
!48 = !DILocation(line: 53, column: 3, scope: !43)
!49 = !DILocation(line: 55, column: 6, scope: !43)
!50 = !DILocation(line: 55, column: 8, scope: !43)
!51 = !DILocalVariable(name: "s", scope: !43, file: !5, line: 59, type: !24)
!52 = !DILocation(line: 59, column: 5, scope: !43)
!53 = !DILocation(line: 59, column: 3, scope: !43)
!54 = !DILocation(line: 61, column: 5, scope: !43)
!55 = !DILocation(line: 61, column: 7, scope: !43)
!56 = !DILocation(line: 62, column: 5, scope: !43)
!57 = !DILocation(line: 62, column: 7, scope: !43)
!58 = !DILocation(line: 64, column: 6, scope: !43)
!59 = !DILocation(line: 64, column: 9, scope: !43)
!60 = !DILocation(line: 65, column: 3, scope: !43)
!61 = !DILocation(line: 66, column: 3, scope: !43)

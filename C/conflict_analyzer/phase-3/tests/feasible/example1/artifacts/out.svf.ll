; ModuleID = '/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/out.svf.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [4 x { i8*, i8*, i8*, i32, i8* }] [{ i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 52, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double ()* @get_a to i8*), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 47, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 61, i8* null }, { i8*, i8*, i8*, i32, i8* } { i8* bitcast (i32 ()* @ewma_main to i8*), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.5, i32 0, i32 0), i8* getelementptr inbounds ([71 x i8], [71 x i8]* @.str.1, i32 0, i32 0), i32 69, i8* null }], section "llvm.metadata"
@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !0
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !10
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [71 x i8] c"/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [16 x i8] c"XDLINKAGE_GET_A\00", section "llvm.metadata"
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !16
@.str.3 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"EWMA_MAIN\00", section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !12 {
  %1 = load double, double* @get_a.a, align 8, !dbg !27
  %2 = fadd double %1, 1.000000e+00, !dbg !27
  store double %2, double* @get_a.a, align 8, !dbg !27
  %3 = load double, double* @get_a.a, align 8, !dbg !28
  ret double %3, !dbg !29
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !30 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !34, metadata !DIExpression()), !dbg !35
  call void @llvm.dbg.declare(metadata double* %2, metadata !36, metadata !DIExpression()), !dbg !37
  call void @llvm.dbg.declare(metadata double* %3, metadata !38, metadata !DIExpression()), !dbg !39
  %5 = bitcast double* %3 to i8*, !dbg !40
  %6 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.3, i32 0, i32 0
  %7 = getelementptr inbounds [71 x i8], [71 x i8]* @.str.1, i32 0, i32 0
  call void @llvm.var.annotation(i8* %5, i8* %6, i8* %7, i32 76, i8* null), !dbg !40
  call void @llvm.dbg.declare(metadata i32* %4, metadata !41, metadata !DIExpression()), !dbg !43
  store i32 0, i32* %4, align 4, !dbg !43
  br label %8, !dbg !44

8:                                                ; preds = %20, %0
  %9 = load i32, i32* %4, align 4, !dbg !45
  %10 = icmp slt i32 %9, 10, !dbg !47
  br i1 %10, label %11, label %23, !dbg !48

11:                                               ; preds = %8
  %12 = call double @get_a(), !dbg !49
  store double %12, double* %1, align 8, !dbg !51
  %13 = call double @get_b(), !dbg !52
  store double %13, double* %2, align 8, !dbg !53
  %14 = load double, double* %1, align 8, !dbg !54
  %15 = load double, double* %2, align 8, !dbg !55
  %16 = call double @calc_ewma(double noundef %14, double noundef %15), !dbg !56
  store double %16, double* %3, align 8, !dbg !57
  %17 = load double, double* %3, align 8, !dbg !58
  %18 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.4, i64 0, i64 0
  %19 = call i32 (i8*, ...) @printf(i8* noundef %18, double noundef %17), !dbg !59
  br label %20, !dbg !60

20:                                               ; preds = %11
  %21 = load i32, i32* %4, align 4, !dbg !61
  %22 = add nsw i32 %21, 1, !dbg !61
  store i32 %22, i32* %4, align 4, !dbg !61
  br label %8, !dbg !62, !llvm.loop !63

23:                                               ; preds = %8
  ret i32 0, !dbg !66
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: inaccessiblememonly nofree nosync nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32, i8*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !18 {
  %1 = load double, double* @get_b.b, align 8, !dbg !67
  %2 = load double, double* @get_b.b, align 8, !dbg !68
  %3 = fadd double %2, %1, !dbg !68
  store double %3, double* @get_b.b, align 8, !dbg !68
  %4 = load double, double* @get_b.b, align 8, !dbg !69
  ret double %4, !dbg !70
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double noundef %0, double noundef %1) #0 !dbg !2 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %3, align 8
  call void @llvm.dbg.declare(metadata double* %3, metadata !71, metadata !DIExpression()), !dbg !72
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !73, metadata !DIExpression()), !dbg !74
  call void @llvm.dbg.declare(metadata double* %5, metadata !75, metadata !DIExpression()), !dbg !77
  store double 2.500000e-01, double* %5, align 8, !dbg !77
  %6 = load double, double* %3, align 8, !dbg !78
  %7 = load double, double* %4, align 8, !dbg !79
  %8 = fadd double %6, %7, !dbg !80
  %9 = load double, double* @calc_ewma.c, align 8, !dbg !81
  %10 = fmul double 7.500000e-01, %9, !dbg !82
  %11 = call double @llvm.fmuladd.f64(double 2.500000e-01, double %8, double %10), !dbg !83
  store double %11, double* @calc_ewma.c, align 8, !dbg !84
  %12 = load double, double* @calc_ewma.c, align 8, !dbg !85
  ret double %12, !dbg !86
}

declare i32 @printf(i8* noundef, ...) #3

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.fmuladd.f64(double, double, double) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 noundef %0, i8** noundef %1) #0 !dbg !87 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !93, metadata !DIExpression()), !dbg !94
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !95, metadata !DIExpression()), !dbg !96
  %6 = call i32 @ewma_main(), !dbg !97
  ret i32 %6, !dbg !98
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { inaccessiblememonly nofree nosync nounwind willreturn }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!7}
!llvm.ident = !{!19}
!llvm.module.flags = !{!20, !21, !22, !23, !24, !25, !26}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "c", scope: !2, file: !3, line: 41, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "calc_ewma", scope: !3, file: !3, line: 39, type: !4, scopeLine: 39, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!3 = !DIFile(filename: "prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "92545d45494523c57ee91573da8d6e82")
!4 = !DISubroutineType(types: !5)
!5 = !{!6, !6, !6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !9, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca/prog.c", directory: "/home/mlevatich/m/build/capo/C/conflict_analyzer/phase-3/tmp-ca", checksumkind: CSK_MD5, checksum: "92545d45494523c57ee91573da8d6e82")
!9 = !{!0, !10, !16}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "a", scope: !12, file: !3, line: 52, type: !6, isLocal: true, isDefinition: true)
!12 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 47, type: !13, scopeLine: 47, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!13 = !DISubroutineType(types: !14)
!14 = !{!6}
!15 = !{}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "b", scope: !18, file: !3, line: 61, type: !6, isLocal: true, isDefinition: true)
!18 = distinct !DISubprogram(name: "get_b", scope: !3, file: !3, line: 58, type: !13, scopeLine: 58, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!19 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!20 = !{i32 7, !"Dwarf Version", i32 5}
!21 = !{i32 2, !"Debug Info Version", i32 3}
!22 = !{i32 1, !"wchar_size", i32 4}
!23 = !{i32 7, !"PIC Level", i32 2}
!24 = !{i32 7, !"PIE Level", i32 2}
!25 = !{i32 7, !"uwtable", i32 1}
!26 = !{i32 7, !"frame-pointer", i32 2}
!27 = !DILocation(line: 55, column: 5, scope: !12)
!28 = !DILocation(line: 56, column: 10, scope: !12)
!29 = !DILocation(line: 56, column: 3, scope: !12)
!30 = distinct !DISubprogram(name: "ewma_main", scope: !3, file: !3, line: 69, type: !31, scopeLine: 69, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!31 = !DISubroutineType(types: !32)
!32 = !{!33}
!33 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!34 = !DILocalVariable(name: "x", scope: !30, file: !3, line: 72, type: !6)
!35 = !DILocation(line: 72, column: 10, scope: !30)
!36 = !DILocalVariable(name: "y", scope: !30, file: !3, line: 73, type: !6)
!37 = !DILocation(line: 73, column: 10, scope: !30)
!38 = !DILocalVariable(name: "ewma", scope: !30, file: !3, line: 76, type: !6)
!39 = !DILocation(line: 76, column: 10, scope: !30)
!40 = !DILocation(line: 76, column: 3, scope: !30)
!41 = !DILocalVariable(name: "i", scope: !42, file: !3, line: 79, type: !33)
!42 = distinct !DILexicalBlock(scope: !30, file: !3, line: 79, column: 3)
!43 = !DILocation(line: 79, column: 12, scope: !42)
!44 = !DILocation(line: 79, column: 8, scope: !42)
!45 = !DILocation(line: 79, column: 17, scope: !46)
!46 = distinct !DILexicalBlock(scope: !42, file: !3, line: 79, column: 3)
!47 = !DILocation(line: 79, column: 19, scope: !46)
!48 = !DILocation(line: 79, column: 3, scope: !42)
!49 = !DILocation(line: 80, column: 9, scope: !50)
!50 = distinct !DILexicalBlock(scope: !46, file: !3, line: 79, column: 30)
!51 = !DILocation(line: 80, column: 7, scope: !50)
!52 = !DILocation(line: 81, column: 9, scope: !50)
!53 = !DILocation(line: 81, column: 7, scope: !50)
!54 = !DILocation(line: 82, column: 22, scope: !50)
!55 = !DILocation(line: 82, column: 24, scope: !50)
!56 = !DILocation(line: 82, column: 12, scope: !50)
!57 = !DILocation(line: 82, column: 10, scope: !50)
!58 = !DILocation(line: 83, column: 20, scope: !50)
!59 = !DILocation(line: 83, column: 5, scope: !50)
!60 = !DILocation(line: 84, column: 3, scope: !50)
!61 = !DILocation(line: 79, column: 26, scope: !46)
!62 = !DILocation(line: 79, column: 3, scope: !46)
!63 = distinct !{!63, !48, !64, !65}
!64 = !DILocation(line: 84, column: 3, scope: !42)
!65 = !{!"llvm.loop.mustprogress"}
!66 = !DILocation(line: 85, column: 3, scope: !30)
!67 = !DILocation(line: 64, column: 8, scope: !18)
!68 = !DILocation(line: 64, column: 5, scope: !18)
!69 = !DILocation(line: 65, column: 10, scope: !18)
!70 = !DILocation(line: 65, column: 3, scope: !18)
!71 = !DILocalVariable(name: "a", arg: 1, scope: !2, file: !3, line: 39, type: !6)
!72 = !DILocation(line: 39, column: 25, scope: !2)
!73 = !DILocalVariable(name: "b", arg: 2, scope: !2, file: !3, line: 39, type: !6)
!74 = !DILocation(line: 39, column: 35, scope: !2)
!75 = !DILocalVariable(name: "alpha", scope: !2, file: !3, line: 40, type: !76)
!76 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!77 = !DILocation(line: 40, column: 17, scope: !2)
!78 = !DILocation(line: 42, column: 16, scope: !2)
!79 = !DILocation(line: 42, column: 20, scope: !2)
!80 = !DILocation(line: 42, column: 18, scope: !2)
!81 = !DILocation(line: 42, column: 39, scope: !2)
!82 = !DILocation(line: 42, column: 37, scope: !2)
!83 = !DILocation(line: 42, column: 23, scope: !2)
!84 = !DILocation(line: 42, column: 5, scope: !2)
!85 = !DILocation(line: 43, column: 10, scope: !2)
!86 = !DILocation(line: 43, column: 3, scope: !2)
!87 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 87, type: !88, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !15)
!88 = !DISubroutineType(types: !89)
!89 = !{!33, !33, !90}
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64)
!91 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !92, size: 64)
!92 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!93 = !DILocalVariable(name: "argc", arg: 1, scope: !87, file: !3, line: 87, type: !33)
!94 = !DILocation(line: 87, column: 14, scope: !87)
!95 = !DILocalVariable(name: "argv", arg: 2, scope: !87, file: !3, line: 87, type: !90)
!96 = !DILocation(line: 87, column: 27, scope: !87)
!97 = !DILocation(line: 88, column: 10, scope: !87)
!98 = !DILocation(line: 88, column: 3, scope: !87)

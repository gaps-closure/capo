; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@llvm.global.annotations = appending global [3 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 31 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double ()* @get_a to i8*), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 26 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1.4, i32 0, i32 0), i32 34 }], section "llvm.metadata"
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [32 x i8] c"./divvied/orange/example1.mod.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [16 x i8] c"XDLINKAGE_GET_A\00", section "llvm.metadata"
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !10
@.str.3 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.1.4 = private unnamed_addr constant [32 x i8] c"./divvied/purple/example1.mod.c\00", section "llvm.metadata"
@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !16
@.str.2.5 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !2 {
entry:
  %0 = load double, double* @get_a.a, align 8, !dbg !25
  %add = fadd double %0, 1.000000e+00, !dbg !25
  store double %add, double* @get_a.a, align 8, !dbg !25
  %1 = load double, double* @get_a.a, align 8, !dbg !26
  ret double %1, !dbg !27
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double %a, double %b) #0 !dbg !18 {
entry:
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  %alpha = alloca double, align 8
  store double %a, double* %a.addr, align 8
  call void @llvm.dbg.declare(metadata double* %a.addr, metadata !28, metadata !DIExpression()), !dbg !29
  store double %b, double* %b.addr, align 8
  call void @llvm.dbg.declare(metadata double* %b.addr, metadata !30, metadata !DIExpression()), !dbg !31
  call void @llvm.dbg.declare(metadata double* %alpha, metadata !32, metadata !DIExpression()), !dbg !34
  store double 2.500000e-01, double* %alpha, align 8, !dbg !34
  %0 = load double, double* %a.addr, align 8, !dbg !35
  %1 = load double, double* %b.addr, align 8, !dbg !36
  %add = fadd double %0, %1, !dbg !37
  %mul = fmul double 2.500000e-01, %add, !dbg !38
  %2 = load double, double* @calc_ewma.c, align 8, !dbg !39
  %mul1 = fmul double 7.500000e-01, %2, !dbg !40
  %add2 = fadd double %mul, %mul1, !dbg !41
  store double %add2, double* @calc_ewma.c, align 8, !dbg !42
  %3 = load double, double* @calc_ewma.c, align 8, !dbg !43
  ret double %3, !dbg !44
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !12 {
entry:
  %0 = load double, double* @get_b.b, align 8, !dbg !45
  %1 = load double, double* @get_b.b, align 8, !dbg !46
  %add = fadd double %1, %0, !dbg !46
  store double %add, double* @get_b.b, align 8, !dbg !46
  %2 = load double, double* @get_b.b, align 8, !dbg !47
  ret double %2, !dbg !48
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !49 {
entry:
  %x = alloca double, align 8
  %y = alloca double, align 8
  %ewma = alloca double, align 8
  %i = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %x, metadata !53, metadata !DIExpression()), !dbg !54
  call void @llvm.dbg.declare(metadata double* %y, metadata !55, metadata !DIExpression()), !dbg !56
  call void @llvm.dbg.declare(metadata double* %ewma, metadata !57, metadata !DIExpression()), !dbg !58
  %ewma1 = bitcast double* %ewma to i8*, !dbg !59
  call void @llvm.var.annotation(i8* %ewma1, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1.4, i32 0, i32 0), i32 46), !dbg !59
  call void @llvm.dbg.declare(metadata i32* %i, metadata !60, metadata !DIExpression()), !dbg !62
  store i32 0, i32* %i, align 4, !dbg !62
  br label %for.cond, !dbg !63

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, i32* %i, align 4, !dbg !64
  %cmp = icmp slt i32 %0, 10, !dbg !66
  br i1 %cmp, label %for.body, label %for.end, !dbg !67

for.body:                                         ; preds = %for.cond
  %call = call i32 (...) bitcast (double ()* @get_a to i32 (...)*)(), !dbg !68
  %conv = sitofp i32 %call to double, !dbg !68
  store double %conv, double* %x, align 8, !dbg !70
  %call2 = call double @get_b(), !dbg !71
  store double %call2, double* %y, align 8, !dbg !72
  %1 = load double, double* %x, align 8, !dbg !73
  %2 = load double, double* %y, align 8, !dbg !74
  %call3 = call double @calc_ewma(double %1, double %2), !dbg !75
  store double %call3, double* %ewma, align 8, !dbg !76
  %3 = load double, double* %ewma, align 8, !dbg !77
  %call4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2.5, i64 0, i64 0), double %3), !dbg !78
  br label %for.inc, !dbg !79

for.inc:                                          ; preds = %for.body
  %4 = load i32, i32* %i, align 4, !dbg !80
  %inc = add nsw i32 %4, 1, !dbg !80
  store i32 %inc, i32* %i, align 4, !dbg !80
  br label %for.cond, !dbg !81, !llvm.loop !82

for.end:                                          ; preds = %for.cond
  ret i32 0, !dbg !84
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %argc, i8** %argv) #0 !dbg !85 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca i8**, align 8
  store i32 0, i32* %retval, align 4
  store i32 %argc, i32* %argc.addr, align 4
  call void @llvm.dbg.declare(metadata i32* %argc.addr, metadata !91, metadata !DIExpression()), !dbg !92
  store i8** %argv, i8*** %argv.addr, align 8
  call void @llvm.dbg.declare(metadata i8*** %argv.addr, metadata !93, metadata !DIExpression()), !dbg !94
  %call = call i32 @ewma_main(), !dbg !95
  ret i32 %call, !dbg !96
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { nounwind }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7, !14}
!llvm.ident = !{!21, !21}
!llvm.module.flags = !{!22, !23, !24}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 31, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 26, type: !4, scopeLine: 26, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "./divvied/orange/example1.mod.c", directory: "/home/rkrishnan/gaps/build/apps/examples/example1")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, globals: !9, nameTableKind: None)
!8 = !{}
!9 = !{!0}
!10 = !DIGlobalVariableExpression(var: !11, expr: !DIExpression())
!11 = distinct !DIGlobalVariable(name: "b", scope: !12, file: !13, line: 34, type: !6, isLocal: true, isDefinition: true)
!12 = distinct !DISubprogram(name: "get_b", scope: !13, file: !13, line: 31, type: !4, scopeLine: 31, spFlags: DISPFlagDefinition, unit: !14, retainedNodes: !8)
!13 = !DIFile(filename: "./divvied/purple/example1.mod.c", directory: "/home/rkrishnan/gaps/build/apps/examples/example1")
!14 = distinct !DICompileUnit(language: DW_LANG_C99, file: !13, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, globals: !15, nameTableKind: None)
!15 = !{!16, !10}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "c", scope: !18, file: !13, line: 25, type: !6, isLocal: true, isDefinition: true)
!18 = distinct !DISubprogram(name: "calc_ewma", scope: !13, file: !13, line: 23, type: !19, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !14, retainedNodes: !8)
!19 = !DISubroutineType(types: !20)
!20 = !{!6, !6, !6}
!21 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!22 = !{i32 2, !"Dwarf Version", i32 4}
!23 = !{i32 2, !"Debug Info Version", i32 3}
!24 = !{i32 1, !"wchar_size", i32 4}
!25 = !DILocation(line: 34, column: 5, scope: !2)
!26 = !DILocation(line: 35, column: 10, scope: !2)
!27 = !DILocation(line: 35, column: 3, scope: !2)
!28 = !DILocalVariable(name: "a", arg: 1, scope: !18, file: !13, line: 23, type: !6)
!29 = !DILocation(line: 23, column: 25, scope: !18)
!30 = !DILocalVariable(name: "b", arg: 2, scope: !18, file: !13, line: 23, type: !6)
!31 = !DILocation(line: 23, column: 35, scope: !18)
!32 = !DILocalVariable(name: "alpha", scope: !18, file: !13, line: 24, type: !33)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!34 = !DILocation(line: 24, column: 17, scope: !18)
!35 = !DILocation(line: 26, column: 16, scope: !18)
!36 = !DILocation(line: 26, column: 20, scope: !18)
!37 = !DILocation(line: 26, column: 18, scope: !18)
!38 = !DILocation(line: 26, column: 13, scope: !18)
!39 = !DILocation(line: 26, column: 39, scope: !18)
!40 = !DILocation(line: 26, column: 37, scope: !18)
!41 = !DILocation(line: 26, column: 23, scope: !18)
!42 = !DILocation(line: 26, column: 5, scope: !18)
!43 = !DILocation(line: 27, column: 10, scope: !18)
!44 = !DILocation(line: 27, column: 3, scope: !18)
!45 = !DILocation(line: 37, column: 8, scope: !12)
!46 = !DILocation(line: 37, column: 5, scope: !12)
!47 = !DILocation(line: 38, column: 10, scope: !12)
!48 = !DILocation(line: 38, column: 3, scope: !12)
!49 = distinct !DISubprogram(name: "ewma_main", scope: !13, file: !13, line: 41, type: !50, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !14, retainedNodes: !8)
!50 = !DISubroutineType(types: !51)
!51 = !{!52}
!52 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!53 = !DILocalVariable(name: "x", scope: !49, file: !13, line: 42, type: !6)
!54 = !DILocation(line: 42, column: 10, scope: !49)
!55 = !DILocalVariable(name: "y", scope: !49, file: !13, line: 43, type: !6)
!56 = !DILocation(line: 43, column: 10, scope: !49)
!57 = !DILocalVariable(name: "ewma", scope: !49, file: !13, line: 46, type: !6)
!58 = !DILocation(line: 46, column: 10, scope: !49)
!59 = !DILocation(line: 46, column: 3, scope: !49)
!60 = !DILocalVariable(name: "i", scope: !61, file: !13, line: 49, type: !52)
!61 = distinct !DILexicalBlock(scope: !49, file: !13, line: 49, column: 3)
!62 = !DILocation(line: 49, column: 12, scope: !61)
!63 = !DILocation(line: 49, column: 8, scope: !61)
!64 = !DILocation(line: 49, column: 17, scope: !65)
!65 = distinct !DILexicalBlock(scope: !61, file: !13, line: 49, column: 3)
!66 = !DILocation(line: 49, column: 19, scope: !65)
!67 = !DILocation(line: 49, column: 3, scope: !61)
!68 = !DILocation(line: 50, column: 9, scope: !69)
!69 = distinct !DILexicalBlock(scope: !65, file: !13, line: 49, column: 30)
!70 = !DILocation(line: 50, column: 7, scope: !69)
!71 = !DILocation(line: 51, column: 9, scope: !69)
!72 = !DILocation(line: 51, column: 7, scope: !69)
!73 = !DILocation(line: 52, column: 22, scope: !69)
!74 = !DILocation(line: 52, column: 24, scope: !69)
!75 = !DILocation(line: 52, column: 12, scope: !69)
!76 = !DILocation(line: 52, column: 10, scope: !69)
!77 = !DILocation(line: 53, column: 20, scope: !69)
!78 = !DILocation(line: 53, column: 5, scope: !69)
!79 = !DILocation(line: 54, column: 3, scope: !69)
!80 = !DILocation(line: 49, column: 26, scope: !65)
!81 = !DILocation(line: 49, column: 3, scope: !65)
!82 = distinct !{!82, !67, !83}
!83 = !DILocation(line: 54, column: 3, scope: !61)
!84 = !DILocation(line: 55, column: 3, scope: !49)
!85 = distinct !DISubprogram(name: "main", scope: !13, file: !13, line: 58, type: !86, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !14, retainedNodes: !8)
!86 = !DISubroutineType(types: !87)
!87 = !{!52, !52, !88}
!88 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !89, size: 64)
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!90 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!91 = !DILocalVariable(name: "argc", arg: 1, scope: !85, file: !13, line: 58, type: !52)
!92 = !DILocation(line: 58, column: 14, scope: !85)
!93 = !DILocalVariable(name: "argv", arg: 2, scope: !85, file: !13, line: 58, type: !88)
!94 = !DILocation(line: 58, column: 27, scope: !85)
!95 = !DILocation(line: 59, column: 10, scope: !85)
!96 = !DILocation(line: 59, column: 3, scope: !85)

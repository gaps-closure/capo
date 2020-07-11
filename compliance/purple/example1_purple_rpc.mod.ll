; ModuleID = 'partitioned/multithreaded/purple/example1_purple_rpc.mod.c'
source_filename = "partitioned/multithreaded/purple/example1_purple_rpc.mod.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._tag = type { i32, i32, i32 }
%struct._requesta_datatype = type { i32, %struct._trailer_datatype }
%struct._trailer_datatype = type { i32, i32, i32, i16, i16 }
%struct._responsea_datatype = type { double, %struct._trailer_datatype }

@_rpc_get_a.inited = internal global i32 0, align 4, !dbg !0
@_rpc_get_a.psocket = internal global i8* null, align 8, !dbg !13
@_rpc_get_a.ssocket = internal global i8* null, align 8, !dbg !16
@.str = private unnamed_addr constant [18 x i8] c"TAG_REQUEST_GET_A\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [59 x i8] c"partitioned/multithreaded/purple/example1_purple_rpc.mod.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [19 x i8] c"TAG_RESPONSE_GET_A\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [20 x i8] c"XDLINKAGE_RPC_GET_A\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [26 x i8] c"ipc:///tmp/test1subpurple\00", align 1
@.str.5 = private unnamed_addr constant [26 x i8] c"ipc:///tmp/test1pubpurple\00", align 1
@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double ()* @_rpc_get_a to i8*), i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([59 x i8], [59 x i8]* @.str.1, i32 0, i32 0), i32 7 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @_rpc_get_a() #0 !dbg !2 {
entry:
  %t_tag = alloca %struct._tag, align 4
  %o_tag = alloca %struct._tag, align 4
  %reqA = alloca %struct._requesta_datatype, align 4
  %resA = alloca %struct._responsea_datatype, align 8
  %o_tag.coerce = alloca { i64, i32 }, align 4
  call void @llvm.dbg.declare(metadata %struct._tag* %t_tag, metadata !23, metadata !DIExpression()), !dbg !36
  call void @llvm.dbg.declare(metadata %struct._tag* %o_tag, metadata !37, metadata !DIExpression()), !dbg !38
  call void @llvm.dbg.declare(metadata %struct._requesta_datatype* %reqA, metadata !39, metadata !DIExpression()), !dbg !60
  %reqA1 = bitcast %struct._requesta_datatype* %reqA to i8*, !dbg !61
  call void @llvm.var.annotation(i8* %reqA1, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([59 x i8], [59 x i8]* @.str.1, i32 0, i32 0), i32 17), !dbg !61
  call void @llvm.dbg.declare(metadata %struct._responsea_datatype* %resA, metadata !62, metadata !DIExpression()), !dbg !68
  %resA2 = bitcast %struct._responsea_datatype* %resA to i8*, !dbg !69
  call void @llvm.var.annotation(i8* %resA2, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([59 x i8], [59 x i8]* @.str.1, i32 0, i32 0), i32 22), !dbg !69
  %x = getelementptr inbounds %struct._requesta_datatype, %struct._requesta_datatype* %reqA, i32 0, i32 0, !dbg !70
  store i32 0, i32* %x, align 4, !dbg !71
  call void @tag_write(%struct._tag* %t_tag, i32 1, i32 1, i32 3), !dbg !72
  call void @tag_write(%struct._tag* %o_tag, i32 2, i32 2, i32 4), !dbg !73
  %0 = load i32, i32* @_rpc_get_a.inited, align 4, !dbg !74
  %tobool = icmp ne i32 %0, 0, !dbg !74
  br i1 %tobool, label %if.end, label %if.then, !dbg !76

if.then:                                          ; preds = %entry
  store i32 1, i32* @_rpc_get_a.inited, align 4, !dbg !77
  %call = call i8* @xdc_pub_socket(), !dbg !79
  store i8* %call, i8** @_rpc_get_a.psocket, align 8, !dbg !80
  %1 = bitcast { i64, i32 }* %o_tag.coerce to i8*, !dbg !81
  %2 = bitcast %struct._tag* %o_tag to i8*, !dbg !81
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %1, i8* align 4 %2, i64 12, i1 false), !dbg !81
  %3 = getelementptr inbounds { i64, i32 }, { i64, i32 }* %o_tag.coerce, i32 0, i32 0, !dbg !81
  %4 = load i64, i64* %3, align 4, !dbg !81
  %5 = getelementptr inbounds { i64, i32 }, { i64, i32 }* %o_tag.coerce, i32 0, i32 1, !dbg !81
  %6 = load i32, i32* %5, align 4, !dbg !81
  %call3 = call i8* @xdc_sub_socket(i64 %4, i32 %6), !dbg !81
  store i8* %call3, i8** @_rpc_get_a.ssocket, align 8, !dbg !82
  %call4 = call i32 @sleep(i32 1), !dbg !83
  br label %if.end, !dbg !84

if.end:                                           ; preds = %if.then, %entry
  %7 = load i8*, i8** @_rpc_get_a.psocket, align 8, !dbg !85
  %8 = bitcast %struct._requesta_datatype* %reqA to i8*, !dbg !86
  call void @xdc_asyn_send(i8* %7, i8* %8, %struct._tag* %t_tag), !dbg !87
  %9 = load i8*, i8** @_rpc_get_a.ssocket, align 8, !dbg !88
  %10 = bitcast %struct._responsea_datatype* %resA to i8*, !dbg !89
  call void @xdc_blocking_recv(i8* %9, i8* %10, %struct._tag* %o_tag), !dbg !90
  %a = getelementptr inbounds %struct._responsea_datatype, %struct._responsea_datatype* %resA, i32 0, i32 0, !dbg !91
  %11 = load double, double* %a, align 8, !dbg !91
  ret double %11, !dbg !92
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

declare dso_local void @tag_write(%struct._tag*, i32, i32, i32) #3

declare dso_local i8* @xdc_pub_socket() #3

declare dso_local i8* @xdc_sub_socket(i64, i32) #3

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

declare dso_local i32 @sleep(i32) #3

declare dso_local void @xdc_asyn_send(i8*, i8*, %struct._tag*) #3

declare dso_local void @xdc_blocking_recv(i8*, i8*, %struct._tag*) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_hal_init(i8* %inuri, i8* %outuri) #0 !dbg !93 {
entry:
  %inuri.addr = alloca i8*, align 8
  %outuri.addr = alloca i8*, align 8
  store i8* %inuri, i8** %inuri.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %inuri.addr, metadata !96, metadata !DIExpression()), !dbg !97
  store i8* %outuri, i8** %outuri.addr, align 8
  call void @llvm.dbg.declare(metadata i8** %outuri.addr, metadata !98, metadata !DIExpression()), !dbg !99
  %0 = load i8*, i8** %inuri.addr, align 8, !dbg !100
  %call = call i8* @xdc_set_in(i8* %0), !dbg !101
  %1 = load i8*, i8** %outuri.addr, align 8, !dbg !102
  %call1 = call i8* @xdc_set_out(i8* %1), !dbg !103
  call void @xdc_register(void (i8*, i8*, i64*)* @nextrpc_data_encode, void (i8*, i8*, i64*)* @nextrpc_data_decode, i32 1), !dbg !104
  call void @xdc_register(void (i8*, i8*, i64*)* @okay_data_encode, void (i8*, i8*, i64*)* @okay_data_decode, i32 2), !dbg !105
  call void @xdc_register(void (i8*, i8*, i64*)* @requesta_data_encode, void (i8*, i8*, i64*)* @requesta_data_decode, i32 3), !dbg !106
  call void @xdc_register(void (i8*, i8*, i64*)* @responsea_data_encode, void (i8*, i8*, i64*)* @responsea_data_decode, i32 4), !dbg !107
  ret void, !dbg !108
}

declare dso_local i8* @xdc_set_in(i8*) #3

declare dso_local i8* @xdc_set_out(i8*) #3

declare dso_local void @xdc_register(void (i8*, i8*, i64*)*, void (i8*, i8*, i64*)*, i32) #3

declare dso_local void @nextrpc_data_encode(i8*, i8*, i64*) #3

declare dso_local void @nextrpc_data_decode(i8*, i8*, i64*) #3

declare dso_local void @okay_data_encode(i8*, i8*, i64*) #3

declare dso_local void @okay_data_decode(i8*, i8*, i64*) #3

declare dso_local void @requesta_data_encode(i8*, i8*, i64*) #3

declare dso_local void @requesta_data_decode(i8*, i8*, i64*) #3

declare dso_local void @responsea_data_encode(i8*, i8*, i64*) #3

declare dso_local void @responsea_data_decode(i8*, i8*, i64*) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_master_rpc_init() #0 !dbg !109 {
entry:
  call void @_hal_init(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.4, i64 0, i64 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.5, i64 0, i64 0)), !dbg !112
  ret void, !dbg !113
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { argmemonly nounwind willreturn }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!19, !20, !21}
!llvm.ident = !{!22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "inited", scope: !2, file: !3, line: 10, type: !18, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "_rpc_get_a", scope: !3, file: !3, line: 7, type: !4, scopeLine: 7, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!3 = !DIFile(filename: "partitioned/multithreaded/purple/example1_purple_rpc.mod.c", directory: "/home/mkaplan/gaps/build/apps/examples/example1")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.0 (https://github.com/gaps-closure/llvm-project.git 27076be6fc363f9973ef5af6e1af3823cd6ac777)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !8, retainedTypes: !9, globals: !12, nameTableKind: None)
!8 = !{}
!9 = !{!10}
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!0, !13, !16}
!13 = !DIGlobalVariableExpression(var: !14, expr: !DIExpression())
!14 = distinct !DIGlobalVariable(name: "psocket", scope: !2, file: !3, line: 11, type: !15, isLocal: true, isDefinition: true)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "ssocket", scope: !2, file: !3, line: 12, type: !15, isLocal: true, isDefinition: true)
!18 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!19 = !{i32 2, !"Dwarf Version", i32 4}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{i32 1, !"wchar_size", i32 4}
!22 = !{!"clang version 10.0.0 (https://github.com/gaps-closure/llvm-project.git 27076be6fc363f9973ef5af6e1af3823cd6ac777)"}
!23 = !DILocalVariable(name: "t_tag", scope: !2, file: !3, line: 13, type: !24)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "gaps_tag", file: !25, line: 29, baseType: !26)
!25 = !DIFile(filename: "src/hal/api/xdcomms.h", directory: "/home/mkaplan/gaps/build")
!26 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_tag", file: !25, line: 25, size: 96, elements: !27)
!27 = !{!28, !34, !35}
!28 = !DIDerivedType(tag: DW_TAG_member, name: "mux", scope: !26, file: !25, line: 26, baseType: !29, size: 32)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !30, line: 26, baseType: !31)
!30 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !32, line: 42, baseType: !33)
!32 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!33 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "sec", scope: !26, file: !25, line: 27, baseType: !29, size: 32, offset: 32)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "typ", scope: !26, file: !25, line: 28, baseType: !29, size: 32, offset: 64)
!36 = !DILocation(line: 13, column: 14, scope: !2)
!37 = !DILocalVariable(name: "o_tag", scope: !2, file: !3, line: 14, type: !24)
!38 = !DILocation(line: 14, column: 14, scope: !2)
!39 = !DILocalVariable(name: "reqA", scope: !2, file: !3, line: 17, type: !40)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "requesta_datatype", file: !41, line: 57, baseType: !42)
!41 = !DIFile(filename: "partitioned/multithreaded/autogen/codec.h", directory: "/home/mkaplan/gaps/build/apps/examples/example1")
!42 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_requesta_datatype", file: !41, line: 54, size: 160, elements: !43)
!43 = !{!44, !48}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !42, file: !41, line: 55, baseType: !45, size: 32)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !46, line: 26, baseType: !47)
!46 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !32, line: 41, baseType: !18)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "trailer", scope: !42, file: !41, line: 56, baseType: !49, size: 128, offset: 32)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "trailer_datatype", file: !41, line: 23, baseType: !50)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_trailer_datatype", file: !41, line: 17, size: 128, elements: !51)
!51 = !{!52, !53, !54, !55, !59}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !50, file: !41, line: 18, baseType: !29, size: 32)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "rqr", scope: !50, file: !41, line: 19, baseType: !29, size: 32, offset: 32)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "oid", scope: !50, file: !41, line: 20, baseType: !29, size: 32, offset: 64)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "mid", scope: !50, file: !41, line: 21, baseType: !56, size: 16, offset: 96)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !30, line: 25, baseType: !57)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !32, line: 40, baseType: !58)
!58 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "crc", scope: !50, file: !41, line: 22, baseType: !56, size: 16, offset: 112)
!60 = !DILocation(line: 17, column: 24, scope: !2)
!61 = !DILocation(line: 17, column: 5, scope: !2)
!62 = !DILocalVariable(name: "resA", scope: !2, file: !3, line: 22, type: !63)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "responsea_datatype", file: !41, line: 67, baseType: !64)
!64 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_responsea_datatype", file: !41, line: 64, size: 192, elements: !65)
!65 = !{!66, !67}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !64, file: !41, line: 65, baseType: !6, size: 64)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "trailer", scope: !64, file: !41, line: 66, baseType: !49, size: 128, offset: 64)
!68 = !DILocation(line: 22, column: 24, scope: !2)
!69 = !DILocation(line: 22, column: 5, scope: !2)
!70 = !DILocation(line: 26, column: 10, scope: !2)
!71 = !DILocation(line: 26, column: 12, scope: !2)
!72 = !DILocation(line: 27, column: 5, scope: !2)
!73 = !DILocation(line: 28, column: 5, scope: !2)
!74 = !DILocation(line: 30, column: 10, scope: !75)
!75 = distinct !DILexicalBlock(scope: !2, file: !3, line: 30, column: 9)
!76 = !DILocation(line: 30, column: 9, scope: !2)
!77 = !DILocation(line: 31, column: 14, scope: !78)
!78 = distinct !DILexicalBlock(scope: !75, file: !3, line: 30, column: 18)
!79 = !DILocation(line: 32, column: 17, scope: !78)
!80 = !DILocation(line: 32, column: 15, scope: !78)
!81 = !DILocation(line: 33, column: 17, scope: !78)
!82 = !DILocation(line: 33, column: 15, scope: !78)
!83 = !DILocation(line: 34, column: 7, scope: !78)
!84 = !DILocation(line: 35, column: 5, scope: !78)
!85 = !DILocation(line: 37, column: 19, scope: !2)
!86 = !DILocation(line: 37, column: 28, scope: !2)
!87 = !DILocation(line: 37, column: 5, scope: !2)
!88 = !DILocation(line: 38, column: 23, scope: !2)
!89 = !DILocation(line: 38, column: 32, scope: !2)
!90 = !DILocation(line: 38, column: 5, scope: !2)
!91 = !DILocation(line: 40, column: 18, scope: !2)
!92 = !DILocation(line: 40, column: 5, scope: !2)
!93 = distinct !DISubprogram(name: "_hal_init", scope: !3, file: !3, line: 43, type: !94, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!94 = !DISubroutineType(types: !95)
!95 = !{null, !10, !10}
!96 = !DILocalVariable(name: "inuri", arg: 1, scope: !93, file: !3, line: 43, type: !10)
!97 = !DILocation(line: 43, column: 22, scope: !93)
!98 = !DILocalVariable(name: "outuri", arg: 2, scope: !93, file: !3, line: 43, type: !10)
!99 = !DILocation(line: 43, column: 35, scope: !93)
!100 = !DILocation(line: 45, column: 14, scope: !93)
!101 = !DILocation(line: 45, column: 3, scope: !93)
!102 = !DILocation(line: 46, column: 15, scope: !93)
!103 = !DILocation(line: 46, column: 3, scope: !93)
!104 = !DILocation(line: 47, column: 3, scope: !93)
!105 = !DILocation(line: 48, column: 3, scope: !93)
!106 = !DILocation(line: 49, column: 3, scope: !93)
!107 = !DILocation(line: 50, column: 3, scope: !93)
!108 = !DILocation(line: 51, column: 1, scope: !93)
!109 = distinct !DISubprogram(name: "_master_rpc_init", scope: !3, file: !3, line: 53, type: !110, scopeLine: 53, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !8)
!110 = !DISubroutineType(types: !111)
!111 = !{null}
!112 = !DILocation(line: 54, column: 5, scope: !109)
!113 = !DILocation(line: 55, column: 1, scope: !109)

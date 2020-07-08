; ModuleID = 'test1_purple_rpc.mod.c'
source_filename = "test1_purple_rpc.mod.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._tag = type { i32, i32, i32 }
%struct._nextrpc_datatype = type { i32, i32, i32, %struct._trailer_datatype }
%struct._trailer_datatype = type { i32, i32, i32, i16, i16 }
%struct._okay_datatype = type { i32, %struct._trailer_datatype }
%struct._requesta_datatype = type { i32, %struct._trailer_datatype }
%struct._responsea_datatype = type { double, %struct._trailer_datatype }

@_notify_next_tag.inited = internal global i32 0, align 4, !dbg !0
@_notify_next_tag.psocket = internal global i8* null, align 8, !dbg !25
@_notify_next_tag.ssocket = internal global i8* null, align 8, !dbg !28
@.str = private unnamed_addr constant [12 x i8] c"TAG_NEXTRPC\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [23 x i8] c"test1_purple_rpc.mod.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [9 x i8] c"TAG_OKAY\00", section "llvm.metadata"
@_rpc_get_a.inited = internal global i32 0, align 4, !dbg !30
@_rpc_get_a.psocket = internal global i8* null, align 8, !dbg !37
@_rpc_get_a.ssocket = internal global i8* null, align 8, !dbg !39
@.str.3 = private unnamed_addr constant [13 x i8] c"TAG_REQUESTA\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [14 x i8] c"TAG_RESPONSEA\00", section "llvm.metadata"
@.str.5 = private unnamed_addr constant [26 x i8] c"ipc:///tmp/test1subpurple\00", align 1
@.str.6 = private unnamed_addr constant [26 x i8] c"ipc:///tmp/test1pubpurple\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_notify_next_tag(%struct._tag* %0) #0 !dbg !2 {
  %2 = alloca %struct._tag*, align 8
  %3 = alloca %struct._tag, align 4
  %4 = alloca %struct._tag, align 4
  %5 = alloca %struct._nextrpc_datatype, align 4
  %6 = alloca %struct._okay_datatype, align 4
  %7 = alloca { i64, i32 }, align 4
  store %struct._tag* %0, %struct._tag** %2, align 8
  call void @llvm.dbg.declare(metadata %struct._tag** %2, metadata !45, metadata !DIExpression()), !dbg !46
  call void @llvm.dbg.declare(metadata %struct._tag* %3, metadata !47, metadata !DIExpression()), !dbg !48
  call void @llvm.dbg.declare(metadata %struct._tag* %4, metadata !49, metadata !DIExpression()), !dbg !50
  call void @llvm.dbg.declare(metadata %struct._nextrpc_datatype* %5, metadata !51, metadata !DIExpression()), !dbg !74
  %8 = bitcast %struct._nextrpc_datatype* %5 to i8*, !dbg !75
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i32 0, i32 0), i32 13), !dbg !75
  call void @llvm.dbg.declare(metadata %struct._okay_datatype* %6, metadata !76, metadata !DIExpression()), !dbg !82
  %9 = bitcast %struct._okay_datatype* %6 to i8*, !dbg !83
  call void @llvm.var.annotation(i8* %9, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i32 0, i32 0), i32 18), !dbg !83
  %10 = load %struct._tag*, %struct._tag** %2, align 8, !dbg !84
  %11 = getelementptr inbounds %struct._tag, %struct._tag* %10, i32 0, i32 0, !dbg !85
  %12 = load i32, i32* %11, align 4, !dbg !85
  %13 = getelementptr inbounds %struct._nextrpc_datatype, %struct._nextrpc_datatype* %5, i32 0, i32 0, !dbg !86
  store i32 %12, i32* %13, align 4, !dbg !87
  %14 = load %struct._tag*, %struct._tag** %2, align 8, !dbg !88
  %15 = getelementptr inbounds %struct._tag, %struct._tag* %14, i32 0, i32 1, !dbg !89
  %16 = load i32, i32* %15, align 4, !dbg !89
  %17 = getelementptr inbounds %struct._nextrpc_datatype, %struct._nextrpc_datatype* %5, i32 0, i32 1, !dbg !90
  store i32 %16, i32* %17, align 4, !dbg !91
  %18 = load %struct._tag*, %struct._tag** %2, align 8, !dbg !92
  %19 = getelementptr inbounds %struct._tag, %struct._tag* %18, i32 0, i32 2, !dbg !93
  %20 = load i32, i32* %19, align 4, !dbg !93
  %21 = getelementptr inbounds %struct._nextrpc_datatype, %struct._nextrpc_datatype* %5, i32 0, i32 2, !dbg !94
  store i32 %20, i32* %21, align 4, !dbg !95
  call void @tag_write(%struct._tag* %3, i32 1, i32 1, i32 1), !dbg !96
  call void @tag_write(%struct._tag* %4, i32 2, i32 2, i32 2), !dbg !97
  %22 = load i32, i32* @_notify_next_tag.inited, align 4, !dbg !98
  %23 = icmp ne i32 %22, 0, !dbg !98
  br i1 %23, label %34, label %24, !dbg !100

24:                                               ; preds = %1
  store i32 1, i32* @_notify_next_tag.inited, align 4, !dbg !101
  %25 = call i8* @xdc_pub_socket(), !dbg !103
  store i8* %25, i8** @_notify_next_tag.psocket, align 8, !dbg !104
  %26 = bitcast { i64, i32 }* %7 to i8*, !dbg !105
  %27 = bitcast %struct._tag* %4 to i8*, !dbg !105
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %26, i8* align 4 %27, i64 12, i1 false), !dbg !105
  %28 = getelementptr inbounds { i64, i32 }, { i64, i32 }* %7, i32 0, i32 0, !dbg !105
  %29 = load i64, i64* %28, align 4, !dbg !105
  %30 = getelementptr inbounds { i64, i32 }, { i64, i32 }* %7, i32 0, i32 1, !dbg !105
  %31 = load i32, i32* %30, align 4, !dbg !105
  %32 = call i8* @xdc_sub_socket(i64 %29, i32 %31), !dbg !105
  store i8* %32, i8** @_notify_next_tag.ssocket, align 8, !dbg !106
  %33 = call i32 @sleep(i32 1), !dbg !107
  br label %34, !dbg !108

34:                                               ; preds = %24, %1
  %35 = load i8*, i8** @_notify_next_tag.psocket, align 8, !dbg !109
  %36 = bitcast %struct._nextrpc_datatype* %5 to i8*, !dbg !110
  call void @xdc_asyn_send(i8* %35, i8* %36, %struct._tag* %3), !dbg !111
  %37 = load i8*, i8** @_notify_next_tag.ssocket, align 8, !dbg !112
  %38 = bitcast %struct._okay_datatype* %6 to i8*, !dbg !113
  call void @xdc_blocking_recv(i8* %37, i8* %38, %struct._tag* %4), !dbg !114
  ret void, !dbg !115
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
define dso_local double @_rpc_get_a() #0 !dbg !32 {
  %1 = alloca %struct._tag, align 4
  %2 = alloca %struct._tag, align 4
  %3 = alloca %struct._requesta_datatype, align 4
  %4 = alloca %struct._responsea_datatype, align 8
  %5 = alloca { i64, i32 }, align 4
  call void @llvm.dbg.declare(metadata %struct._tag* %1, metadata !116, metadata !DIExpression()), !dbg !117
  call void @llvm.dbg.declare(metadata %struct._tag* %2, metadata !118, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.declare(metadata %struct._requesta_datatype* %3, metadata !120, metadata !DIExpression()), !dbg !126
  %6 = bitcast %struct._requesta_datatype* %3 to i8*, !dbg !127
  call void @llvm.var.annotation(i8* %6, i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i32 0, i32 0), i32 49), !dbg !127
  call void @llvm.dbg.declare(metadata %struct._responsea_datatype* %4, metadata !128, metadata !DIExpression()), !dbg !134
  %7 = bitcast %struct._responsea_datatype* %4 to i8*, !dbg !135
  call void @llvm.var.annotation(i8* %7, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i32 0, i32 0), i32 54), !dbg !135
  %8 = getelementptr inbounds %struct._requesta_datatype, %struct._requesta_datatype* %3, i32 0, i32 0, !dbg !136
  store i32 0, i32* %8, align 4, !dbg !137
  call void @tag_write(%struct._tag* %1, i32 1, i32 1, i32 3), !dbg !138
  call void @tag_write(%struct._tag* %2, i32 2, i32 2, i32 4), !dbg !139
  %9 = load i32, i32* @_rpc_get_a.inited, align 4, !dbg !140
  %10 = icmp ne i32 %9, 0, !dbg !140
  br i1 %10, label %21, label %11, !dbg !142

11:                                               ; preds = %0
  store i32 1, i32* @_rpc_get_a.inited, align 4, !dbg !143
  %12 = call i8* @xdc_pub_socket(), !dbg !145
  store i8* %12, i8** @_rpc_get_a.psocket, align 8, !dbg !146
  %13 = bitcast { i64, i32 }* %5 to i8*, !dbg !147
  %14 = bitcast %struct._tag* %2 to i8*, !dbg !147
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %13, i8* align 4 %14, i64 12, i1 false), !dbg !147
  %15 = getelementptr inbounds { i64, i32 }, { i64, i32 }* %5, i32 0, i32 0, !dbg !147
  %16 = load i64, i64* %15, align 4, !dbg !147
  %17 = getelementptr inbounds { i64, i32 }, { i64, i32 }* %5, i32 0, i32 1, !dbg !147
  %18 = load i32, i32* %17, align 4, !dbg !147
  %19 = call i8* @xdc_sub_socket(i64 %16, i32 %18), !dbg !147
  store i8* %19, i8** @_rpc_get_a.ssocket, align 8, !dbg !148
  %20 = call i32 @sleep(i32 1), !dbg !149
  br label %21, !dbg !150

21:                                               ; preds = %11, %0
  %22 = load i8*, i8** @_rpc_get_a.psocket, align 8, !dbg !151
  %23 = bitcast %struct._requesta_datatype* %3 to i8*, !dbg !152
  call void @xdc_asyn_send(i8* %22, i8* %23, %struct._tag* %1), !dbg !153
  %24 = load i8*, i8** @_rpc_get_a.ssocket, align 8, !dbg !154
  %25 = bitcast %struct._responsea_datatype* %4 to i8*, !dbg !155
  call void @xdc_blocking_recv(i8* %24, i8* %25, %struct._tag* %2), !dbg !156
  %26 = getelementptr inbounds %struct._responsea_datatype, %struct._responsea_datatype* %4, i32 0, i32 0, !dbg !157
  %27 = load double, double* %26, align 8, !dbg !157
  ret double %27, !dbg !158
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_hal_init(i8* %0, i8* %1) #0 !dbg !159 {
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !162, metadata !DIExpression()), !dbg !163
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !164, metadata !DIExpression()), !dbg !165
  %5 = load i8*, i8** %3, align 8, !dbg !166
  %6 = call i8* @xdc_set_in(i8* %5), !dbg !167
  %7 = load i8*, i8** %4, align 8, !dbg !168
  %8 = call i8* @xdc_set_out(i8* %7), !dbg !169
  call void @xdc_register(void (i8*, i8*, i64*)* @nextrpc_data_encode, void (i8*, i8*, i64*)* @nextrpc_data_decode, i32 1), !dbg !170
  call void @xdc_register(void (i8*, i8*, i64*)* @okay_data_encode, void (i8*, i8*, i64*)* @okay_data_decode, i32 2), !dbg !171
  call void @xdc_register(void (i8*, i8*, i64*)* @requesta_data_encode, void (i8*, i8*, i64*)* @requesta_data_decode, i32 3), !dbg !172
  call void @xdc_register(void (i8*, i8*, i64*)* @responsea_data_encode, void (i8*, i8*, i64*)* @responsea_data_decode, i32 4), !dbg !173
  ret void, !dbg !174
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
define dso_local void @_master_rpc_init() #0 !dbg !175 {
  call void @_hal_init(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.5, i64 0, i64 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.6, i64 0, i64 0)), !dbg !178
  ret void, !dbg !179
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { argmemonly nounwind willreturn }

!llvm.dbg.cu = !{!19}
!llvm.module.flags = !{!41, !42, !43}
!llvm.ident = !{!44}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "inited", scope: !2, file: !3, line: 6, type: !36, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "_notify_next_tag", scope: !3, file: !3, line: 5, type: !4, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !19, retainedNodes: !20)
!3 = !DIFile(filename: "test1_purple_rpc.mod.c", directory: "/home/tchen/gaps/build/apps/tests/test1/partitioned/multithreaded/purple")
!4 = !DISubroutineType(types: !5)
!5 = !{null, !6}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "gaps_tag", file: !8, line: 29, baseType: !9)
!8 = !DIFile(filename: "../../../../../../src/hal/api/xdcomms.h", directory: "/home/tchen/gaps/build/apps/tests/test1/partitioned/multithreaded/purple")
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_tag", file: !8, line: 25, size: 96, elements: !10)
!10 = !{!11, !17, !18}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "mux", scope: !9, file: !8, line: 26, baseType: !12, size: 32)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !13, line: 26, baseType: !14)
!13 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !15, line: 42, baseType: !16)
!15 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!16 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!17 = !DIDerivedType(tag: DW_TAG_member, name: "sec", scope: !9, file: !8, line: 27, baseType: !12, size: 32, offset: 32)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "typ", scope: !9, file: !8, line: 28, baseType: !12, size: 32, offset: 64)
!19 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !20, retainedTypes: !21, globals: !24, splitDebugInlining: false, nameTableKind: None)
!20 = !{}
!21 = !{!22}
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!23 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!24 = !{!0, !25, !28, !30, !37, !39}
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "psocket", scope: !2, file: !3, line: 7, type: !27, isLocal: true, isDefinition: true)
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "ssocket", scope: !2, file: !3, line: 8, type: !27, isLocal: true, isDefinition: true)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "inited", scope: !32, file: !3, line: 42, type: !36, isLocal: true, isDefinition: true)
!32 = distinct !DISubprogram(name: "_rpc_get_a", scope: !3, file: !3, line: 41, type: !33, scopeLine: 41, spFlags: DISPFlagDefinition, unit: !19, retainedNodes: !20)
!33 = !DISubroutineType(types: !34)
!34 = !{!35}
!35 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!36 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(name: "psocket", scope: !32, file: !3, line: 43, type: !27, isLocal: true, isDefinition: true)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(name: "ssocket", scope: !32, file: !3, line: 44, type: !27, isLocal: true, isDefinition: true)
!41 = !{i32 7, !"Dwarf Version", i32 4}
!42 = !{i32 2, !"Debug Info Version", i32 3}
!43 = !{i32 1, !"wchar_size", i32 4}
!44 = !{!"clang version 10.0.1 (https://github.com/llvm/llvm-project.git d24d5c8e308e689dcd83cbafd2e8bd32aa845a15)"}
!45 = !DILocalVariable(name: "n_tag", arg: 1, scope: !2, file: !3, line: 5, type: !6)
!46 = !DILocation(line: 5, column: 33, scope: !2)
!47 = !DILocalVariable(name: "t_tag", scope: !2, file: !3, line: 9, type: !7)
!48 = !DILocation(line: 9, column: 14, scope: !2)
!49 = !DILocalVariable(name: "o_tag", scope: !2, file: !3, line: 10, type: !7)
!50 = !DILocation(line: 10, column: 14, scope: !2)
!51 = !DILocalVariable(name: "nxt", scope: !2, file: !3, line: 13, type: !52)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "nextrpc_datatype", file: !53, line: 35, baseType: !54)
!53 = !DIFile(filename: "../autogen/codec.h", directory: "/home/tchen/gaps/build/apps/tests/test1/partitioned/multithreaded/purple")
!54 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_nextrpc_datatype", file: !53, line: 30, size: 224, elements: !55)
!55 = !{!56, !60, !61, !62}
!56 = !DIDerivedType(tag: DW_TAG_member, name: "mux", scope: !54, file: !53, line: 31, baseType: !57, size: 32)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !58, line: 26, baseType: !59)
!58 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !15, line: 41, baseType: !36)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "sec", scope: !54, file: !53, line: 32, baseType: !57, size: 32, offset: 32)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "typ", scope: !54, file: !53, line: 33, baseType: !57, size: 32, offset: 64)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "trailer", scope: !54, file: !53, line: 34, baseType: !63, size: 128, offset: 96)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "trailer_datatype", file: !53, line: 23, baseType: !64)
!64 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_trailer_datatype", file: !53, line: 17, size: 128, elements: !65)
!65 = !{!66, !67, !68, !69, !73}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !64, file: !53, line: 18, baseType: !12, size: 32)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "rqr", scope: !64, file: !53, line: 19, baseType: !12, size: 32, offset: 32)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "oid", scope: !64, file: !53, line: 20, baseType: !12, size: 32, offset: 64)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "mid", scope: !64, file: !53, line: 21, baseType: !70, size: 16, offset: 96)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !13, line: 25, baseType: !71)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !15, line: 40, baseType: !72)
!72 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "crc", scope: !64, file: !53, line: 22, baseType: !70, size: 16, offset: 112)
!74 = !DILocation(line: 13, column: 22, scope: !2)
!75 = !DILocation(line: 13, column: 5, scope: !2)
!76 = !DILocalVariable(name: "okay", scope: !2, file: !3, line: 18, type: !77)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "okay_datatype", file: !53, line: 47, baseType: !78)
!78 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_okay_datatype", file: !53, line: 44, size: 160, elements: !79)
!79 = !{!80, !81}
!80 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !78, file: !53, line: 45, baseType: !57, size: 32)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "trailer", scope: !78, file: !53, line: 46, baseType: !63, size: 128, offset: 32)
!82 = !DILocation(line: 18, column: 19, scope: !2)
!83 = !DILocation(line: 18, column: 5, scope: !2)
!84 = !DILocation(line: 22, column: 15, scope: !2)
!85 = !DILocation(line: 22, column: 22, scope: !2)
!86 = !DILocation(line: 22, column: 9, scope: !2)
!87 = !DILocation(line: 22, column: 13, scope: !2)
!88 = !DILocation(line: 23, column: 15, scope: !2)
!89 = !DILocation(line: 23, column: 22, scope: !2)
!90 = !DILocation(line: 23, column: 9, scope: !2)
!91 = !DILocation(line: 23, column: 13, scope: !2)
!92 = !DILocation(line: 24, column: 15, scope: !2)
!93 = !DILocation(line: 24, column: 22, scope: !2)
!94 = !DILocation(line: 24, column: 9, scope: !2)
!95 = !DILocation(line: 24, column: 13, scope: !2)
!96 = !DILocation(line: 26, column: 5, scope: !2)
!97 = !DILocation(line: 27, column: 5, scope: !2)
!98 = !DILocation(line: 29, column: 10, scope: !99)
!99 = distinct !DILexicalBlock(scope: !2, file: !3, line: 29, column: 9)
!100 = !DILocation(line: 29, column: 9, scope: !2)
!101 = !DILocation(line: 30, column: 14, scope: !102)
!102 = distinct !DILexicalBlock(scope: !99, file: !3, line: 29, column: 18)
!103 = !DILocation(line: 31, column: 17, scope: !102)
!104 = !DILocation(line: 31, column: 15, scope: !102)
!105 = !DILocation(line: 32, column: 17, scope: !102)
!106 = !DILocation(line: 32, column: 15, scope: !102)
!107 = !DILocation(line: 33, column: 7, scope: !102)
!108 = !DILocation(line: 34, column: 5, scope: !102)
!109 = !DILocation(line: 36, column: 19, scope: !2)
!110 = !DILocation(line: 36, column: 28, scope: !2)
!111 = !DILocation(line: 36, column: 5, scope: !2)
!112 = !DILocation(line: 37, column: 23, scope: !2)
!113 = !DILocation(line: 37, column: 32, scope: !2)
!114 = !DILocation(line: 37, column: 5, scope: !2)
!115 = !DILocation(line: 39, column: 1, scope: !2)
!116 = !DILocalVariable(name: "t_tag", scope: !32, file: !3, line: 45, type: !7)
!117 = !DILocation(line: 45, column: 14, scope: !32)
!118 = !DILocalVariable(name: "o_tag", scope: !32, file: !3, line: 46, type: !7)
!119 = !DILocation(line: 46, column: 14, scope: !32)
!120 = !DILocalVariable(name: "reqA", scope: !32, file: !3, line: 49, type: !121)
!121 = !DIDerivedType(tag: DW_TAG_typedef, name: "requesta_datatype", file: !53, line: 57, baseType: !122)
!122 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_requesta_datatype", file: !53, line: 54, size: 160, elements: !123)
!123 = !{!124, !125}
!124 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !122, file: !53, line: 55, baseType: !57, size: 32)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "trailer", scope: !122, file: !53, line: 56, baseType: !63, size: 128, offset: 32)
!126 = !DILocation(line: 49, column: 24, scope: !32)
!127 = !DILocation(line: 49, column: 5, scope: !32)
!128 = !DILocalVariable(name: "resA", scope: !32, file: !3, line: 54, type: !129)
!129 = !DIDerivedType(tag: DW_TAG_typedef, name: "responsea_datatype", file: !53, line: 67, baseType: !130)
!130 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_responsea_datatype", file: !53, line: 64, size: 192, elements: !131)
!131 = !{!132, !133}
!132 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !130, file: !53, line: 65, baseType: !35, size: 64)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "trailer", scope: !130, file: !53, line: 66, baseType: !63, size: 128, offset: 64)
!134 = !DILocation(line: 54, column: 24, scope: !32)
!135 = !DILocation(line: 54, column: 5, scope: !32)
!136 = !DILocation(line: 58, column: 10, scope: !32)
!137 = !DILocation(line: 58, column: 12, scope: !32)
!138 = !DILocation(line: 59, column: 5, scope: !32)
!139 = !DILocation(line: 60, column: 5, scope: !32)
!140 = !DILocation(line: 62, column: 10, scope: !141)
!141 = distinct !DILexicalBlock(scope: !32, file: !3, line: 62, column: 9)
!142 = !DILocation(line: 62, column: 9, scope: !32)
!143 = !DILocation(line: 63, column: 14, scope: !144)
!144 = distinct !DILexicalBlock(scope: !141, file: !3, line: 62, column: 18)
!145 = !DILocation(line: 64, column: 17, scope: !144)
!146 = !DILocation(line: 64, column: 15, scope: !144)
!147 = !DILocation(line: 65, column: 17, scope: !144)
!148 = !DILocation(line: 65, column: 15, scope: !144)
!149 = !DILocation(line: 66, column: 7, scope: !144)
!150 = !DILocation(line: 67, column: 5, scope: !144)
!151 = !DILocation(line: 70, column: 19, scope: !32)
!152 = !DILocation(line: 70, column: 28, scope: !32)
!153 = !DILocation(line: 70, column: 5, scope: !32)
!154 = !DILocation(line: 71, column: 23, scope: !32)
!155 = !DILocation(line: 71, column: 32, scope: !32)
!156 = !DILocation(line: 71, column: 5, scope: !32)
!157 = !DILocation(line: 73, column: 18, scope: !32)
!158 = !DILocation(line: 73, column: 5, scope: !32)
!159 = distinct !DISubprogram(name: "_hal_init", scope: !3, file: !3, line: 76, type: !160, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !19, retainedNodes: !20)
!160 = !DISubroutineType(types: !161)
!161 = !{null, !22, !22}
!162 = !DILocalVariable(name: "inuri", arg: 1, scope: !159, file: !3, line: 76, type: !22)
!163 = !DILocation(line: 76, column: 22, scope: !159)
!164 = !DILocalVariable(name: "outuri", arg: 2, scope: !159, file: !3, line: 76, type: !22)
!165 = !DILocation(line: 76, column: 35, scope: !159)
!166 = !DILocation(line: 78, column: 14, scope: !159)
!167 = !DILocation(line: 78, column: 3, scope: !159)
!168 = !DILocation(line: 79, column: 15, scope: !159)
!169 = !DILocation(line: 79, column: 3, scope: !159)
!170 = !DILocation(line: 80, column: 3, scope: !159)
!171 = !DILocation(line: 81, column: 3, scope: !159)
!172 = !DILocation(line: 82, column: 3, scope: !159)
!173 = !DILocation(line: 83, column: 3, scope: !159)
!174 = !DILocation(line: 84, column: 1, scope: !159)
!175 = distinct !DISubprogram(name: "_master_rpc_init", scope: !3, file: !3, line: 86, type: !176, scopeLine: 86, spFlags: DISPFlagDefinition, unit: !19, retainedNodes: !20)
!176 = !DISubroutineType(types: !177)
!177 = !{null}
!178 = !DILocation(line: 87, column: 5, scope: !175)
!179 = !DILocation(line: 88, column: 1, scope: !175)

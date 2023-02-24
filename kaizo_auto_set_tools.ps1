###############################################################################
# 
# 改造ソフト自動生成ツール 
# 
###############################################################################
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"


try {
    #必要な情報を収集する
    ###############################################################################
    #バリエーションを入力する
    Write-Host "===================================================================="
    Write-Host "| 改造ソフト作業を開始します。|"
    Write-Host "===================================================================="
    Write-Host "| ファイルをコピー中です。|"
    Copy-Item "..\..\main_micro\sources\" "kaizoA" -Recurse -Force
    $SOURCES_PATH = "..\..\main_micro\sources" 
    [string]$VARI = Read-Host -Prompt '改造要ソフトのソフトバリエーションを入力してください'
    if (($VARI -ne 1000) -and ($VARI -ne 1100 )){
        Write-Host "バリエーションが不存在"
        "Any key to exit"  ;Read-Host | Out-Null ;Exit
    }
    #実施者の名前を入力する
    [string]$Implement_Name = Read-Host -Prompt '改造実施者の名前を入力してください'
    #従業員コードを入力
    [string]$Implement_code = Read-Host -Prompt '改造実施者の従業員コードを入力してください'
    $Target_PATH = "\\APLTMCECUBUZZ2\elec\user\" + $Implement_code +"\solar_test\main\rom"
    #時期を入力する
    [string]$Implement_time = Read-Host -Prompt '改造時期を入力してください（例:230124）'
    #実施部署
    [string]$Implement_department = Read-Host -Prompt '改造実施者の部署を入力してください'
    $set_title_start ="/*" + " "+ "debug"+" "+"s"+" "+ $Implement_department+" " + $Implement_Name+ " " +$Implement_time+ " "+"*/" 
    $set_title_end = "/*" + " "+"debug"+" "+"e"+" "+ $Implement_department+" " + $Implement_Name+ " " +$Implement_time+ " "+"*/" 
    [String]$kaizo_type = Read-Host -Prompt '
    B：スタック計測用改造ソフト
    C：処理負荷計測用改造ソフト
    D：EEPROMキューサイズ計測用改造ソフト
    E：センサ値RAMWrite有効化改造ソフト
    F：パワーオン・タスク周期確認用改造ソフト
    G：スタック計測用(机上)改造ソフト
    H：以上のソフト（all　時間がかかる）
    改造ソフトの番号を選びください'
    ###############################################################################
    #改造ソフト開始
    #改造ソフトB
    function kaizo_B {
        Write-Host "===================================================================="
        Write-Host "| 改造ソフトB作業を開始します。|"
        Write-Host "===================================================================="     
        # sourcesフォルダのパス
        $SOURCES_file1_B ="\src\id\giprogramid_c.h"  
        $SOURCES_file2_B ="\src\spf_p\ss\spp_sdbg\spp_sdbginfo_c.h"  
        $SOURCES_file3_B ="\src\spf_p\ss\spp_sevent\spp_sttrevt.h"
        $SOURCES_file4_B ="\src\spf_p\ss\spp_sevent\spp_sttrevt_l_mat.c"
#file1の改造
        function file1_set_B {
            $file1_PATH =$SOURCES_PATH + $SOURCES_file1_B 
            [string[]]$write_data_file1_before = @()
            $write_data_file1_before += ,$set_title_start
            $write_data_file1_before += "   #if 0"
            [string[]]$write_data_file1_after = @()
            $write_data_file1_after += "    #endif"
            $write_data_file1_after +=" 	    #define  PROGRAMID  `"894BF-K00A0-1   `""
            $write_data_file1_after += ,$set_title_end
            if ($VARI -eq 1000) {
                $src_file_id= (Get-Content $file1_PATH -TotalCount 49)[-1]
            }else {
                $src_file_id= (Get-Content $file1_PATH -TotalCount 53)[-1]
            }
            $src_file_id = "    " + $src_file_id 
            #書込み内容
            $write_data_file1 = $write_data_file1_before + $src_file_id + $write_data_file1_after 
            
            #一時ファイルの作成
            if (Test-Path($file1_PATH + ".new")) {
                Remove-Item ($file1_PATH + ".new")
            }
            $src_file = Get-Content $file1_PATH
            [bool]$is_target_section = $false # 処理対象区間か
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
                if ($line.Contains("#if ( JGVARI == 1000 )")) {
                        $is_target_section = $true
                        #% {} は foreach（Foreach-Object）を意味します
                        # |符号の意味：パイプライン
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
            
                        $write_data_file1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    }
                    elseif ($line.Contains("#elif ( JGVARI == 1100 )")) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                        $is_target_section = $false
                    }
                    else {
                        if ($is_target_section -eq $false) {
                            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                        }
                    }
            }
        }else{
            foreach ($line in $src_file) {
                # 処理対象の開始行より前はそのまま出力
                # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#elif ( JGVARI == 1100 )")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
        
                    $write_data_file1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                }
                elseif ($line.Contains("#else")) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    $is_target_section = $false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    }
                }
        }

        }
        Remove-Item $file1_PATH
        Move-Item ($file1_PATH + ".new") $file1_PATH
}
#file2の改造
        function file2_set_B {
            $file2_PATH =$SOURCES_PATH + $SOURCES_file2_B 
            [string[]]$write_data_file2_before = @()
            $write_data_file2_before += ,$set_title_start
            $write_data_file2_before += "   #if 0"
            [string[]]$write_data_file2_after = @()
            $write_data_file2_after += "    #endif"
            $write_data_file2_after += "        #define u4s_SPP_SDBGINFO_VER     ((u4)0xFF010A00U)"
            $write_data_file2_after += ,$set_title_end
            if ($VARI -eq 1000) {
                $src_file_id= (Get-Content $file2_PATH -TotalCount 118)[-1]
            }else {
                $src_file_id= (Get-Content $file2_PATH -TotalCount 122)[-1]
            }
            $src_file_id = "    " + $src_file_id 
            #書込み内容
            $write_data_file2 = $write_data_file2_before + $src_file_id + $write_data_file2_after 
            
            #一時ファイルの作成
            if (Test-Path($file2_PATH + ".new")) {
                Remove-Item ($file2_PATH + ".new")
            }
            $src_file = Get-Content $file2_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
                if ($line.Contains("#if ( JGVARI == 1000 )") -and $num -eq 116) {
                        $is_target_section = $true
                        #% {} は foreach（Foreach-Object）を意味します
                        # |符号の意味：パイプライン
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
            
                        $write_data_file2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    }
                    elseif ($line.Contains("#elif ( JGVARI == 1100 )") ) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                        $is_target_section = $false
                    }
                    else {
                        if ($is_target_section -eq $false) {
                            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                        }
                    }
                    $num =$num +1
                    
            }
        }else{
            foreach ($line in $src_file) {
                # 処理対象の開始行より前はそのまま出力
                # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#elif ( JGVARI == 1100 )") -and $num -eq 120 ) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
        
                    $write_data_file2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                }
                elseif ($line.Contains("#else")) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    $is_target_section = $false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    }
                }
                $num =$num +1
        }
}
        Remove-Item $file2_PATH
        Move-Item ($file2_PATH + ".new") $file2_PATH

            
        }
#file3の改造
        function file3_set_B {
            $file3_PATH =$SOURCES_PATH + $SOURCES_file3_B 
            [string[]]$write_data_file3_before = @()
            $write_data_file3_before += ,""
            $write_data_file3_before += ,$set_title_start
            [string[]]$write_data_file3_after = @()
            $write_data_file3_after += ,$set_title_end
            $src_file_id = "extern char __ghsend_stack[];            /* スタックアドレス */"
            #書込み内容
            $write_data_file3 = $write_data_file3_before + $src_file_id + $write_data_file3_after    
            #一時ファイルの作成
            if (Test-Path($file3_PATH + ".new")) {
                Remove-Item ($file3_PATH + ".new")
            }
            $src_file = Get-Content $file3_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  

            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("extern u2  u2g_spp_sttrevt_8mslcnt;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
            
                    $write_data_file3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    }
                elseif ($line.Contains("/*-------------------------------------------------------------------*/") ) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file3_PATH
        Move-Item ($file3_PATH + ".new") $file3_PATH
        }
        function file4_set_B {
            $file4_PATH =$SOURCES_PATH + $SOURCES_file4_B 
            [string[]]$write_data_file4_before = @()
            $write_data_file4_before += ,$set_title_start
            [string[]]$write_data_file4_after = @()
            $write_data_file4_after += ,$set_title_end
            $src_file_id1 = 
"#define STACK_SIZE ((u4)0x1FF8)                                         /* スタックサイズ */
#define u4s_dbg_stack_top ( (u4 *)((u4)&__ghsend_stack - STACK_SIZE) )  /* スタック先頭アドレス */
#define u4s_dbg_stack_end ( (u4)(&__ghsend_stack) )                     /* スタック最終アドレス */
static u4 u4s_dbg_stack_adr;                                            /* 現在スタックアドレス */
static u1 u1s_dbg_stack_val;                                            /* 現在スタックアドレスのデータ */
static u4 *pts_dbg_stack_chk_adr;                                       /* チェックするスタックアドレス */
static u4 u4s_dbg_stack_adr_max;                                        /* スタック使用アドレス最大値 */"
            #書込み内容
            $write_data_file4_N1 = $write_data_file4_before + $src_file_id1 + $write_data_file4_after
            $src_file_id2 = "    pts_dbg_stack_chk_adr = u4s_dbg_stack_top;      /* チェックアドレスの初期化 */
    u4s_dbg_stack_adr_max = u4s_dbg_stack_end;      /* スタック使用アドレス最大値の初期化 */"
            $write_data_file4_N2 = $write_data_file4_before + $src_file_id2 + $write_data_file4_after
            $src_file_id3 ="
    if( (u4)pts_dbg_stack_chk_adr < u4s_dbg_stack_end )
    {
        u4s_dbg_stack_adr = (u4)( pts_dbg_stack_chk_adr );  /* 現在アドレスを取得 */
        u1s_dbg_stack_val = (u1)( *pts_dbg_stack_chk_adr ); /* 現在アドレスのデータを取得 */
        pts_dbg_stack_chk_adr++;                            /* チェックアドレスのインクリメント処理 */
        if( u1s_dbg_stack_val != 0 )
        {
            /* スタック使用アドレス最大値の更新 */
            if( u4s_dbg_stack_adr < u4s_dbg_stack_adr_max )
            {
                u4s_dbg_stack_adr_max = u4s_dbg_stack_adr;
            }
        }
    }
    else
    {
        pts_dbg_stack_chk_adr = u4s_dbg_stack_top;          /* チェックアドレスの初期化 */
    }"
            $write_data_file4_N3 = $write_data_file4_before + $src_file_id3 + $write_data_file4_after

            #一時ファイルの作成
            if (Test-Path($file4_PATH + ".new")) {
                Remove-Item ($file4_PATH + ".new")
            }
            $src_file = Get-Content $file4_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("u2  u2g_spp_sttrevt_8mslcnt;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
            
                    $write_data_file4_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
                    $is_target_section =$false
                    }
                elseif ($line.Contains("/*     u2g_spp_sttrevt_8mslcnt   = (u2)0;              */")) {
                    $is_target_section = $true
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
                    $write_data_file4_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
                    $is_target_section =$false  
                    }
                elseif ($line.Contains("u2g_spp_sttrevt_8mslcnt = u2t_8mslcnt;")) {
                    $is_target_section = $true
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
                    $write_data_file4_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
                    $is_target_section =$false
                }

                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file4_PATH
        Move-Item ($file4_PATH + ".new") $file4_PATH   
        }
        file1_set_B
        file2_set_B
        file3_set_B
        file4_set_B
        Write-Host "ソフトB改造成功"
        Write-Host "ソースを保存中--------"
        Copy-Item "..\..\main_micro\sources\" "kaizoB" -Recurse -Force
        
        Write-Host "改造ソフトBのビルド開始いたします。"
        Start-Process -Filepath "test_build.bat" -Wait -NoNewWindow 
        Write-Host "改造ソフトBのビルド結果物(Romフォルダ)を保存しています。"
        Copy-Item $Target_PATH "kaizoB" -Recurse -Force
        #ファイルを復元
        Remove-Item "..\..\main_micro\sources" -Recurse
        Copy-Item  "kaizoA\" "..\..\main_micro\sources" -Recurse -Force
        Write-Host "===================================================================="
        Write-Host "| 改造ソフトB作業を終わりました。|"
        Write-Host "===================================================================="    
}
    function kaizo_C {
        Write-Host "===================================================================="
        Write-Host "| 改造ソフトC作業を開始します。|"
        Write-Host "===================================================================="     
        # sourcesフォルダのパス
        $SOURCES_file1_C ="\src\id\giprogramid_c.h"  
        $SOURCES_file2_C ="\src\spf_p\ios\fnc\spp_iadrcv_c_mat.c"  
        $SOURCES_file3_C ="\src\spf_p\ss\spp_sbosht\spp_sboot_l_mat.c"
        $SOURCES_file4_C ="\src\spf_p\ss\spp_sdbg\spp_sdbginfo_c.h"
        $SOURCES_file5_C ="\src\spf_p\ss\spp_sdbg\spp_shdrmon_c.h"  
        $SOURCES_file6_C ="\src\spf_p\ss\spp_sevent\spp_sttrevt.h"
        $SOURCES_file7_C ="\src\spf_p\ss\spp_sevent\spp_sttrevt_l_mat.c"
        function file1_set_C {
            $file1_PATH =$SOURCES_PATH + $SOURCES_file1_C 
            [string[]]$write_data_file1_before = @()
            $write_data_file1_before += ,$set_title_start
            $write_data_file1_before += "   #if 0"
            [string[]]$write_data_file1_after = @()
            $write_data_file1_after += "    #endif"
            $write_data_file1_after +=" 	    #define  PROGRAMID  `"894BF-K00A0-2   `""
            $write_data_file1_after += ,$set_title_end
            if ($VARI -eq 1000) {
                $src_file_id= (Get-Content $file1_PATH -TotalCount 49)[-1]
            }else {
                $src_file_id= (Get-Content $file1_PATH -TotalCount 53)[-1]
            }
            $src_file_id = "    " + $src_file_id 
            #書込み内容
            $write_data_file1 = $write_data_file1_before + $src_file_id + $write_data_file1_after 
            
            #一時ファイルの作成
            if (Test-Path($file1_PATH + ".new")) {
                Remove-Item ($file1_PATH + ".new")
            }
            $src_file = Get-Content $file1_PATH
            [bool]$is_target_section = $false # 処理対象区間か
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
                if ($line.Contains("#if ( JGVARI == 1000 )")) {
                        $is_target_section = $true
                        #% {} は foreach（Foreach-Object）を意味します
                        # |符号の意味：パイプライン
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
            
                        $write_data_file1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    }
                    elseif ($line.Contains("#elif ( JGVARI == 1100 )")) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                        $is_target_section = $false
                    }
                    else {
                        if ($is_target_section -eq $false) {
                            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                        }
                    }
            }
        }else{
            foreach ($line in $src_file) {
                # 処理対象の開始行より前はそのまま出力
                # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#elif ( JGVARI == 1100 )")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
        
                    $write_data_file1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                }
                elseif ($line.Contains("#else")) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    $is_target_section = $false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    }
                }
        }

        }
        Remove-Item $file1_PATH
        Move-Item ($file1_PATH + ".new") $file1_PATH
}
        function file2_set_C{
            $file2_PATH =$SOURCES_PATH + $SOURCES_file2_C 
            [string[]]$write_data_file2_before = @()
            $write_data_file2_before += ,$set_title_start
            [string[]]$write_data_file2_after = @()
            $write_data_file2_after += ,$set_title_end
            $src_file_id1 ="#include `"../../ss/spp_stmr/spp_ssysclk.h`" /* u4g_spp_ssysclk_clk_250ns() */"
            #書込み内容
            $write_data_file2_N1 = $write_data_file2_before + $src_file_id1 + $write_data_file2_after
            $src_file_id2 = 
"static u4 u4s_dbg_vdg_spp_iadrcv_alladtrg_time_max;    /* lsb=250,unit=ns:関数処理実行時間最大値 */ 
static u4 u4s_dbg_vdg_spp_iadrcv_alladtrg_time_now;    /* lsb=250,unit=ns:関数処理実行時間現在値 */ "
            $write_data_file2_N2 = $write_data_file2_before + $src_file_id2 + $write_data_file2_after
            $src_file_id3 =
"   u4 u4t_time_now; /* lsb=250,unit=ns:1msh周期処理時間_現在値 */
 	 	 
    u4 u4t_gtm;
    u4t_gtm= u4g_spp_ssysclk_clk_250ns();  /* 開始時間取得 */"
            $write_data_file2_N3 = $write_data_file2_before + $src_file_id3 + $write_data_file2_after
            $src_file_id4 =
"    u4t_time_now = u4g_spp_ssysclk_sub_250ns(u4g_spp_ssysclk_clk_250ns(),u4t_gtm); /* 処理時間算出 */
    u4s_dbg_vdg_spp_iadrcv_alladtrg_time_now = u4t_time_now;                                  /* 現在値更新 */
    if (u4t_time_now > u4s_dbg_vdg_spp_iadrcv_alladtrg_time_max)                              /* 最大値更新 */
        {
            u4s_dbg_vdg_spp_iadrcv_alladtrg_time_max = u4t_time_now;
        }"
            $write_data_file2_N4 = $write_data_file2_before + $src_file_id4 + $write_data_file2_after
            #一時ファイルの作成
            if (Test-Path($file2_PATH + ".new")) {
                Remove-Item ($file2_PATH + ".new")
            }
            $src_file = Get-Content $file2_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1 
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#include `"../../../aplmng/apllmng.h`" /* vdg_apllmng_adtrg() */")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
            
                    $write_data_file2_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    $is_target_section =$false
                    }
                elseif ($line.Contains("/*-------------------------------------------------------------------*/") -and $num -eq 82) {
                    $is_target_section = $true
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    $write_data_file2_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    $is_target_section =$false  
                    }
                elseif ($line.Contains("/* ▼▼▼ 必要に応じて関数を差し込むこと ▼▼▼ */")) {
                    $is_target_section = $true
                    $write_data_file2_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    $is_target_section =$false
                }
                elseif ($line.Contains("/* ▲▲▲ 必要に応じて関数を差し込むこと ▲▲▲ */")) {
                    $is_target_section = $true                  
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    $write_data_file2_N4 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    $is_target_section =$false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file2_PATH
        Move-Item ($file2_PATH + ".new") $file2_PATH   
}   
        function file3_set_C {
            $file3_PATH =$SOURCES_PATH + $SOURCES_file3_C 
            [string[]]$write_data_file3_before = @()
            $write_data_file3_before += ,$set_title_start
            [string[]]$write_data_file3_after = @()
            $write_data_file3_after += ,$set_title_end
            $src_file_id1 ="#include `"../spp_stmr/spp_ssysclk.h`" /* u4g_spp_ssysclk_clk_250ns    */"
            #書込み内容
            $write_data_file3_N1 = $write_data_file3_before + $src_file_id1 + $write_data_file3_after
            $src_file_id2 = 
"static u4 u4s_spp_sttrevt_idle_time_now;                   /* lsb=250,unit=ns:idle処理時間_現在値 */
    u4 u4s_spp_sttrevt_idle_time_min;                   /* lsb=250,unit=ns:idle処理時間_最小値 */
    u4 u4s_idle_8ms_sum_cnt;                            /* lsb=250,unit=ns:idle処理時間_8ms合計カウント値 */"
            $write_data_file3_N2 = $write_data_file3_before + $src_file_id2 + $write_data_file3_after
            $src_file_id3 ="    u4 u4t_gtm;"
            $write_data_file3_N3 = $write_data_file3_before + $src_file_id3 + $write_data_file3_after
            $src_file_id4 ="#if 0"
            $write_data_file3_N4 = $write_data_file3_before + $src_file_id4 
            $src_file_id5 =
"#endif
 	 	        
    glint_di();   
    u4t_gtm = u4g_spp_ssysclk_clk_250ns(); 
    vdg_spp_seventif_idle();

    u4s_spp_sttrevt_idle_time_now = u4g_spp_ssysclk_sub_250ns(u4g_spp_ssysclk_clk_250ns(),u4t_gtm); /* 処理時間算出 */

    glint_ei();
    if (u4s_spp_sttrevt_idle_time_now < u4s_spp_sttrevt_idle_time_min)                              /* 最大値更新 */
    {
        u4s_spp_sttrevt_idle_time_min = u4s_spp_sttrevt_idle_time_now;
    }
    
    u4s_idle_8ms_sum_cnt = u4s_idle_8ms_sum_cnt + u4s_spp_sttrevt_idle_time_now;                    /* idol実行時間合計値算出 */
    
    if ( u4g_spp_sttrevt_idle_cnt_mon < u4g_U4MAX )
    {
        u4g_spp_sttrevt_idle_cnt_mon++;
    }"
        $write_data_file3_N5 =  $src_file_id5 + $write_data_file3_after

            #一時ファイルの作成
            if (Test-Path($file3_PATH + ".new")) {
                Remove-Item ($file3_PATH + ".new")
            }
            $src_file = Get-Content $file3_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1 
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#include `"../spp_sboshtif.h`"         /* vdg_spp_sbosht_pwonctrl()    */")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
            
                    $write_data_file3_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    $is_target_section =$false
                    }
                elseif ($line.Contains("/*-------------------------------------------------------------------*/") -and $num -eq 76) {
                    $is_target_section = $true
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    $write_data_file3_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    $is_target_section =$false  
                    }
                elseif ($line.Contains("/* ソフトウェアパワーオン順序制御要求への通知 */")) {
                    $is_target_section = $true
                    $write_data_file3_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    $is_target_section =$false
                }
                elseif ($line.Contains("vdg_spp_seventif_idle();")) {
                    $is_target_section = $true
                    $write_data_file3_N4 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    $write_data_file3_N5 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    $is_target_section =$false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file3_PATH
        Move-Item ($file3_PATH + ".new") $file3_PATH
        }
        function file4_set_C {
            $file4_PATH =$SOURCES_PATH + $SOURCES_file4_C 
            [string[]]$write_data_file4_before = @()
            $write_data_file4_before += ,$set_title_start
            $write_data_file4_before += "   #if 0"
            [string[]]$write_data_file4_after = @()
            $write_data_file4_after += "    #endif"
            $write_data_file4_after += "        #define u4s_SPP_SDBGINFO_VER ((u4)0xFF020A00U)"
            $write_data_file4_after += ,$set_title_end
            if ($VARI -eq 1000) {
                $src_file_id= (Get-Content $file4_PATH -TotalCount 138)[-1]
            }else {
                $src_file_id= (Get-Content $file4_PATH -TotalCount 142)[-1]
            }
            $src_file_id = "    " + $src_file_id 
            #書込み内容
            $write_data_file4 = $write_data_file4_before + $src_file_id + $write_data_file4_after 
            
            #一時ファイルの作成
            if (Test-Path($file4_PATH + ".new")) {
                Remove-Item ($file4_PATH + ".new")
            }
            $src_file = Get-Content $file4_PATH
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
                if ($line.Contains("#if ( JGVARI == 1000 )") -and $num -eq 116) {
                        $is_target_section = $true
                        #% {} は foreach（Foreach-Object）を意味します
                        # |符号の意味：パイプライン
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
            
                        $write_data_file4 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
                        $is_target_section = $false
                    }
                    else {
                        if ($is_target_section -eq $false) {
                            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
                        }
                    }
                    $num =$num +1      
            }
        }else{
            foreach ($line in $src_file) {
                # 処理対象の開始行より前はそのまま出力
                # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#elif ( JGVARI == 1100 )") -and $num -eq 120 ) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
        
                    $write_data_file4 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
                    $is_target_section = $false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
                    }
                }
                $num =$num +1
        }
}
        Remove-Item $file4_PATH
        Move-Item ($file4_PATH + ".new") $file4_PATH 
        }
        function file5_set_C {
            $file5_PATH =$SOURCES_PATH + $SOURCES_file5_C
            [string[]]$write_data_file5_before = @()
            $write_data_file5_before += ,$set_title_start
            [string[]]$write_data_file5_after = @()
            $write_data_file5_after += ,$set_title_end
            $src_file_id_N1 = "#if 0"
            #書込み内容
            $write_data_file5_N1 = $write_data_file5_before + $src_file_id_N1  
            $src_file_id_N2 =
"#endif
#define SPP_SHDRMON_EXEC_ALL       SPP_SHDRMON_USE  /* 割り込みモニタ機能切り替え         NOUSE:非使用   USE:使用     */
#define SPP_SHDRMON_EXEC_END2START SPP_SHDRMON_USE  /* 終了から開始までの時間計測切り替え NOUSE:計測無し USE:計測有り */
#define SPP_SHDRMON_EXEC_START2END SPP_SHDRMON_USE  /* 開始から終了までの時間計測切り替え NOUSE:計測無し USE:計測有り */"

            $write_data_file5_N2 = $src_file_id_N2 + $write_data_file5_after
            #一時ファイルの作成
            if (Test-Path($file5_PATH + ".new")) {
                Remove-Item ($file5_PATH + ".new")
            }
            $src_file = Get-Content $file5_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("/* コンパイルSW */")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file5_PATH + ".new") -Append    
                    $write_data_file5_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file5_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("#define SPP_SHDRMON_EXEC_START2END SPP_SHDRMON_NOUSE") ) {
                    $is_target_section = $true
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file5_PATH + ".new") -Append
                    $write_data_file5_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file5_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file5_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file5_PATH
        Move-Item ($file5_PATH + ".new") $file5_PATH
        }
        function file6_set_C {
            $file6_PATH =$SOURCES_PATH + $SOURCES_file6_C
            [string[]]$write_data_file6_before = @()
            $write_data_file6_before += ,$set_title_start
            [string[]]$write_data_file6_after = @()
            $write_data_file6_after += ,$set_title_end
            $src_file_id_N1 = "extern u4 u4g_spp_sttrevt_idle_cnt_mon; /* lsb=1,unit=回 : アイドル実行回数 */"
            #書込み内容
            $write_data_file6_N1 = $write_data_file6_before + $src_file_id_N1 + $write_data_file6_after

            #一時ファイルの作成
            if (Test-Path($file6_PATH + ".new")) {
                Remove-Item ($file6_PATH + ".new")
            }
            $src_file = Get-Content $file6_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
                if ($line.Contains("extern u2  u2g_spp_sttrevt_8mslcnt;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append    
                    $write_data_file6_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append
                    }
                }
                $num =$num +1                  
        } 
        Remove-Item $file6_PATH
        Move-Item ($file6_PATH + ".new") $file6_PATH
                          
    }
        function file7_set_C {
            $file7_PATH =$SOURCES_PATH + $SOURCES_file7_C
            [string[]]$write_data_file7_before = @()
            $write_data_file7_before += ,$set_title_start
            [string[]]$write_data_file7_after = @()
            $write_data_file7_after += ,$set_title_end
            $src_file_id_N1 = 
"/* 処理負荷計測用RAM定義 */
u4 u4g_spp_sttrevt_idle_cnt_mon;                   /* lsb=1,unit=回  :アイドル実行回数演算用  */
    
static u4 u4s_spp_sttrevt_idle_cnt_min;            /* lsb=1,unit=回  :アイドル実行回数_最小値 */
static u4 u4s_spp_sttrevt_idle_cnt_now_mon;        /* lsb=1,unit=回  :アイドル実行回数_現在値 */
static u4 u4s_spp_sttrevt_idle_miss_cnt;           /* lsb=1,unit=回  :アイドル抜け回数 */
    
static u4 u4s_spp_sttrevt_1msh_time_max;           /* lsb=250,unit=ns:1msh周期処理時間_最大値 */
static u4 u4s_spp_sttrevt_1msh_time_now;           /* lsb=250,unit=ns:1msh周期処理時間_現在値 */
static u4 u4s_spp_sttrevt_4msm_time_max;           /* lsb=250,unit=ns:4msm周期処理時間_最大値 */
static u4 u4s_spp_sttrevt_4msm_time_now;           /* lsb=250,unit=ns:4msm周期処理時間_現在値 */
static u4 u4s_spp_sttrevt_8msl_time_max;           /* lsb=250,unit=ns:8msl周期処理時間_最大値 */
static u4 u4s_spp_sttrevt_8msl_time_now;           /* lsb=250,unit=ns:8msl周期処理時間_現在値 */
    
static u4 u4s_spp_sttrevt_idle_8ms_sum_time_now;   /* lsb=250,unit=ns:idle処理時間_8ms合計_現在値 */
static u4 u4s_spp_sttrevt_idle_8ms_sum_time_min;   /* lsb=250,unit=ns:idle処理時間_8ms合計_最小値 */
    
extern u4 u4s_spp_sttrevt_idle_time_min;           /* lsb=250,unit=ns:アイドルタスク処理時間最小値   */
extern u4 u4s_idle_8ms_sum_cnt;                    /* lsb=250,unit=ns:idle処理時間_8ms合計カウント値 */"
            #書込み内容
            $write_data_file7_N1 = $write_data_file7_before + $src_file_id_N1 + $write_data_file7_after
            $src_file_id_N2 =
"   /* 最小値を確認したいのでイニシャルで最大値を入れる */
    u4s_spp_sttrevt_idle_cnt_now_mon = u4g_U4MAX;
    u4s_spp_sttrevt_idle_cnt_min = u4g_U4MAX;
    u4s_spp_sttrevt_idle_time_min = u4g_U4MAX;
    u4s_spp_sttrevt_idle_8ms_sum_time_min = u4g_U4MAX;"
            $write_data_file7_N2 = $write_data_file7_before + $src_file_id_N2 + $write_data_file7_after
            $src_file_id_N3 =
"   u4 u4t_time_now; /* lsb=250,unit=ns:1msh周期処理時間_現在値 */

    u4 u4t_gtm;
    u4t_gtm= u4g_spp_ssysclk_clk_250ns();  /* 開始時間取得 */ "
            $write_data_file7_N3 = $write_data_file7_before + $src_file_id_N3 + $write_data_file7_after
            $src_file_id_N4 = "#if 0 "
            $write_data_file7_N4 =$write_data_file7_before + $src_file_id_N4
            $src_file_id_N5 = "	#endif 
"
            $write_data_file7_N5 = $src_file_id_N5 + $write_data_file7_after
            $src_file_id_N6 =
"   u4t_time_now = u4g_spp_ssysclk_sub_250ns(u4g_spp_ssysclk_clk_250ns(),u4t_gtm); /* 処理時間算出 */
    u4s_spp_sttrevt_1msh_time_now = u4t_time_now;                                  /* 現在値更新 */
    if (u4t_time_now > u4s_spp_sttrevt_1msh_time_max)                              /* 最大値更新 */
    {
        u4s_spp_sttrevt_1msh_time_max = u4t_time_now;
    }
    /* タスクの終了(TerminateTask())は時間周期タスク実体定義(CREATE_TASK( spp_sttrevt_1msh ))内部で発行するため、発行不要 */

"
            $write_data_file7_N6 = $write_data_file7_before + $src_file_id_N6 + $write_data_file7_after
            $src_file_id_N7 = 
"   u4 u4t_time_now;    /* lsb=250,unit=ns:4msm周期処理時間_現在値 */
    u4 u4t_gtm;

    u4t_gtm = u4g_spp_ssysclk_clk_250ns();   /* 処理負荷計測時はタスク単体の時間を計測 */"
            $write_data_file7_N7 = $write_data_file7_before + $src_file_id_N7 + $write_data_file7_after
            $src_file_id_N8 =
"   u4t_time_now = u4g_spp_ssysclk_sub_250ns(u4g_spp_ssysclk_clk_250ns(),u4t_gtm); /* 処理時間算出 */
 	 	    
    u4s_spp_sttrevt_4msm_time_now = u4t_time_now;                                  /* 現在値更新 */
    if (u4t_time_now > u4s_spp_sttrevt_4msm_time_max)                              /* 最大値更新 */
    {
        u4s_spp_sttrevt_4msm_time_max = u4t_time_now;
    }"
        $write_data_file7_N8 = $write_data_file7_before + $src_file_id_N8 + $write_data_file7_after
        $src_file_id_N9 = 
"   u4 u4t_time_now;    /* lsb=250,unit=ns:8msl周期処理時間_現在値 */
 	 	 
    u4 u4t_gtm;

    u4t_gtm = u4g_spp_ssysclk_clk_250ns();   /* 処理負荷計測時はタスク単体の時間を計測 */
    u4s_spp_sttrevt_idle_8ms_sum_time_now = u4s_idle_8ms_sum_cnt;   /* 8msのidol実行時間を登録 */

    /* アイドル抜け判定処理 (8msl毎にidle処理出来ているか)*/
    if ( u4g_spp_sttrevt_idle_cnt_mon == 0 )
    {
        if ( u4s_spp_sttrevt_idle_miss_cnt < u4g_U4MAX )
        {
            u4s_spp_sttrevt_idle_miss_cnt++;
        }
    }
    else  /* 最小回数取得処理 */
    {
        if (u4g_spp_sttrevt_idle_cnt_mon < u4s_spp_sttrevt_idle_cnt_min)
        {
            u4s_spp_sttrevt_idle_cnt_min = u4g_spp_sttrevt_idle_cnt_mon;                        /* idle実行回数最小値更新 */
        }
        if (u4s_idle_8ms_sum_cnt < u4s_spp_sttrevt_idle_8ms_sum_time_min)
        {
            u4s_spp_sttrevt_idle_8ms_sum_time_min = u4s_idle_8ms_sum_cnt;                       /* idle処理時間_8ms_合計値_最小時間更新 */
        }
    }

    u4s_spp_sttrevt_idle_cnt_now_mon = u4g_spp_sttrevt_idle_cnt_mon;                             /* idle回数_カウント現在値更新 */
    u4s_spp_sttrevt_idle_8ms_sum_time_now = u4s_idle_8ms_sum_cnt;                                /* idle処理時間_8ms合計カウント現在値更新 */
    u4g_spp_sttrevt_idle_cnt_mon = 0;                                                            /* idle回数_カウント値初期化(8msごとに初期化する) */
    u4s_idle_8ms_sum_cnt = 0;                                                                    /* idle処理時間_8ms合計カウント値初期化(8msごとに初期化する) */
"
            $write_data_file7_N9 = $write_data_file7_before + $src_file_id_N9 + $write_data_file7_after
            $src_file_id_N10 = 
"   u4t_time_now = u4g_spp_ssysclk_sub_250ns(u4g_spp_ssysclk_clk_250ns(),u4t_gtm); /* 処理時間算出 */

    u4s_spp_sttrevt_8msl_time_now = u4t_time_now;                                  /* 現在値更新 */
    if (u4t_time_now > u4s_spp_sttrevt_8msl_time_max)                              /* 最大値更新 */
    {
        u4s_spp_sttrevt_8msl_time_max = u4t_time_now;
    }
    /* タスクの終了(TerminateTask())は時間周期タスク実体定義(CREATE_TASK( spp_sttrevt_8msl ))内部で発行するため、発行不要 */"
            $write_data_file7_N10 = $write_data_file7_before + $src_file_id_N10 + $write_data_file7_after
            #一時ファイルの作成
            if (Test-Path($file7_PATH + ".new")) {
                Remove-Item ($file7_PATH + ".new")
            }
            $src_file = Get-Content $file7_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
                if ($line.Contains("u2  u2g_spp_sttrevt_8mslcnt;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("/*     u2g_spp_sttrevt_8mslcnt   = (u2)0;              */")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("u4 u4t_pc;   /* プログラムカウンタ     */")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("u4t_pc = u4g_spp_mmcalif_msupgetpc();")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N4 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    } 
                elseif ($line.Contains("vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_RTOS, u4t_pc );")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N5 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("u1g_spp_sttrevt_1mshcnt = u1t_1mshcnt;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N6 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }  
                elseif ($line.Contains("u2 u2t_4msmcnt;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N7 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    } 
                elseif ($line.Contains("u2g_spp_sttrevt_4msmcnt = u2t_4msmcnt;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N8 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("u2 u2t_8mslcnt;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N9 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("2g_spp_sttrevt_8mslcnt = u2t_8mslcnt;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N10 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    }
                }
                $num =$num +1                  
        } 
        Remove-Item $file7_PATH
        Move-Item ($file7_PATH + ".new") $file7_PATH
        }
    file1_set_C
    file2_set_C
    file3_set_C
    file4_set_C
    file5_set_C
    file6_set_C
    file7_set_C
    Write-Host "ソフトC改造成功"
    Write-Host "ソースを保存中--------"
    Copy-Item "..\..\main_micro\sources\" "kaizoC" -Recurse -Force
    Write-Host "改造ソフトCのビルド開始いたします。"
    Start-Process -Filepath "test_build.bat" -Wait -NoNewWindow 
    Write-Host "改造ソフトCのビルド結果物(Romフォルダ)を保存しています。"
    Copy-Item $Target_PATH "kaizoC" -Recurse -Force
    #ファイルを復元
    Remove-Item "..\..\main_micro\sources" -Recurse
    Copy-Item  "kaizoA\" "..\..\main_micro\sources" -Recurse -Force
    Write-Host "===================================================================="
    Write-Host "| 改造ソフトC作業を終わりました。|"
    Write-Host "====================================================================" 
}
    function kaizo_D {
        Write-Host "===================================================================="
        Write-Host "| 改造ソフトD作業を開始します。|"
        Write-Host "===================================================================="     
        # sourcesフォルダのパス
        $SOURCES_file1_D ="\src\aplmng\apllmng_c_mat.c"
        $SOURCES_file2_D ="\src\aps\cmem\ceeprom.h"  
        $SOURCES_file3_D ="\src\aps\cmem\ceeprom_l_mat.c"
        $SOURCES_file4_D ="\src\aps\cmem\cmem_l_mat.c"
        $SOURCES_file5_D ="\inc\common.h"  
        $SOURCES_file6_D ="\src\id\giprogramid_c.h"
        $SOURCES_file7_D ="\src\hsol\hsbstdcdvi.c"
        $SOURCES_file8_D ="\src\hsol\hsecucomi.c"
        $SOURCES_file9_D ="\src\hsol\hsmiddvi.c"
        $SOURCES_file10_D ="\src\hsol\hsrob.c"
        $SOURCES_file11_D ="\src\spf_p\ss\spp_sdbg\spp_sdbginfo_c.h"
        $SOURCES_file12_D ="\src\obd\wfd\wnmrewkup_l_mat.c"
        $SOURCES_file13_D ="\src\obd\wfd\wnmslpng_l_mat.c"
        $SOURCES_file14_D ="\src\obd\wfd\wslprewkup_l_mat.c"
        $SOURCES_file15_D ="\src\obd\wfd\wslpslpng_l_mat.c"
        function file1_set_D {
            $file1_PATH =$SOURCES_PATH + $SOURCES_file1_D
            [string[]]$write_data_file1_before = @()
            $write_data_file1_before += ,$set_title_start
            [string[]]$write_data_file1_after = @()
            $write_data_file1_after += ,$set_title_end
            $src_file_id_N1 = 
"#include  `"../hsol/hsbstdcdvi.h`"
#include  `"../hsol/hsecucomi.h`"
#include  `"../hsol/hsmiddvi.h`""
            #書込み内容
            $write_data_file1_N1 = $write_data_file1_before + $src_file_id_N1 + $write_data_file1_after
            $src_file_id_N2 =
"#define  ROB_MODE_DEF    ((u1)(0))                      /* 通常モード */
#define  ROB_MODE_1      ((u1)(1))                      /* RoB同時発生モード */
#define  ROB_MODE_2      ((u1)(2))                      /* RoB発生モード(補機) */
#define  ROB_MODE_3      ((u1)(3))                      /* RoB発生モード(NM) */"
            $write_data_file1_N2 = $write_data_file1_before + $src_file_id_N2 + $write_data_file1_after
            $src_file_id_N3 =
"u1 u1g_dbg_mode;         /* デバックモード切替用フラグ_0:通常制御モード_1:デバックモード */
u1 u1g_dbg_RoBmode;      /* RoBモード切り替えフラグ_0:通常モード_1:RoB同時発生_2:RoB発生(補機)_RoB発生(NM) */"
            $write_data_file1_N3 = $write_data_file1_before + $src_file_id_N3 + $write_data_file1_after
            $src_file_id_N4 =
"   switch(u1g_dbg_RoBmode)
    {
        case ROB_MODE_1:
            u1g_hsmiddvi_xovsf = (u1)1;                         /* RoB(SOL発電取り下げ(DDC要因)(0x056DU))発生トリガ */
            u2g_dbg_write_hsrob_soldc1winor_cnt = (u2)126;      /* RoB(定格外 RoB設定情報部品(0x0002U))発生トリガ  */
            u1g_hsbstdcdvi_xthng = (u1)1;                       /* RoB(主電池充電取り下げ(DDC要因)(0x056BU))発生トリガ */
            u1g_hsecucomi_soljdg = (u1)4;                       /* RoB(主電池充電不許可(HVシステム)(0x0567U))発生トリガ */
            u1g_hsbstdcdvi_xovsf = (u1)1;                       /* RoB(主電池取下げ(過電圧要因)(0x0001U))発生トリガ */
            break;
        
        case ROB_MODE_2:
            u2g_dbg_write_hsrob_auxdcthng_cnt = (u2)126;        /* RoB(補機給電取り下げ(DDC要因)(0x0569U))発生トリガ */
            break;
        
        case ROB_MODE_3:
            u4g_dbg_write_wnmrewkup_cwkupcnt = (u4)450001;      /* RoB(過剰ウェイクアップ(0xF001U))発生トリガ */
            u1g_dbg_write_wnmrewkup_wkupcnt = (u1)23;           /* RoB(過剰ウェイクアップ(0xF001U))発生トリガ */
            u4g_dbg_write_wnmslpng_cslpngcnt = (u4)450001;      /* RoB(スリープNG(0xF002U))発生トリガ */
            u1g_dbg_write_aplawkfctigb = (u1)1;                 /* RoB(スリープNG(0xF002U))発生トリガ */
            u4g_dbg_write_wslprewkup_cwkupcnt = (u4)525001;     /* RoB(過剰ウェイクアップ(0xF009U))発生トリガ */
            u1g_dbg_write_wslprewkup_wkupcnt = (u1)51;          /* RoB(過剰ウェイクアップ)(0xF009U))発生トリガ */
            u4g_dbg_write_wslpslpng_cslpngcnt = (u4)525001;     /* RoB(スリープNG(0xF00AU))発生トリガ */
            break;

        default :
            /* 処理なし */
            break;
    }"
        $write_data_file1_N4 = $write_data_file1_before + $src_file_id_N4 + $write_data_file1_after
            #一時ファイルの作成
            if (Test-Path($file1_PATH + ".new")) {
                Remove-Item ($file1_PATH + ".new")
            }
            $src_file = Get-Content $file1_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("/* ▲▲▲ イベントに差し込む部品のヘッダファイルインクルード(機種毎に編集) ▲▲▲ */")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $write_data_file1_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append    
                    $is_target_section = $false
                    }
                elseif ($line.Contains("/*-------------------------------------------------------------------*/") -and $num -eq 62) {
                    $is_target_section = $true
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    $write_data_file1_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("u1 u1g_apllmng_cnt_4sl;")) {
                    $is_target_section = $true
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    $write_data_file1_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("/* ▲▲▲ 必要に応じて関数を差し込むこと ▲▲▲ */") -and $num -eq 186) {
                    $is_target_section = $true
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    $write_data_file1_N4 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file1_PATH
        Move-Item ($file1_PATH + ".new") $file1_PATH
        }
        function file2_set_D {
            $file2_PATH =$SOURCES_PATH + $SOURCES_file2_D
            [string[]]$write_data_file2_before = @()
            $write_data_file2_before += ,$set_title_start
            [string[]]$write_data_file2_after = @()
            $write_data_file2_after += ,$set_title_end
            $src_file_id_N1 = 
"
void vdg_chkquesizeinit( void );              /* EEPROM使用キューサイズ確認用              */
"
            #書込み内容
            $write_data_file2_N1 = $write_data_file2_before + $src_file_id_N1 + $write_data_file2_after
            $src_file_id_N2 =
"u1   u1g_ceeprom_calc_quesize( u1, u1, u1 );/* EEPROM使用キューサイズ確認用 */
                                            /* EEPROM使用キューサイズ確認用 */
#define u1g_CEEPROM_WRITE    0              /* EEPROM使用キューサイズ確認用 */
#define u1g_CEEPROM_READ     1              /* EEPROM使用キューサイズ確認用 */
#define u1g_CEEPROM_MEMERR   2              /* EEPROM使用キューサイズ確認用 */"
            $write_data_file2_N2 = $write_data_file2_before + $src_file_id_N2 + $write_data_file2_after

            #一時ファイルの作成
            if (Test-Path($file2_PATH + ".new")) {
                Remove-Item ($file2_PATH + ".new")
            }
            $src_file = Get-Content $file2_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains(" /* 注意事項 :") -and $num -eq 115) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                    $write_data_file2_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
            elseif ($line.Contains("(書き込み要求にて実施のこと)")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                $write_data_file2_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                $is_target_section = $false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file2_PATH
        Move-Item ($file2_PATH + ".new") $file2_PATH
        }
        
        function file3_set_D {
            $file3_PATH =$SOURCES_PATH + $SOURCES_file3_D
            [string[]]$write_data_file3_before = @()
            $write_data_file3_before += ,$set_title_start
            [string[]]$write_data_file3_after = @()
            $write_data_file3_after += ,$set_title_end
            $src_file_id_N1 = 
"#pragma     SECTION bss spp_msram                                    /* EEPROM使用キューサイズ確認用 */
static u1   u1s_ceeprom_dummy;                                       /* EEPROM使用キューサイズ確認用 */
static u1   u1s_ceeprom_wque_maxuse;                                 /* EEPROM使用キューサイズ確認用 */
static u1   u1s_ceeprom_rque_maxuse;                                 /* EEPROM使用キューサイズ確認用 */
static u1   u1s_ceeprom_eque_maxuse;                                 /* EEPROM使用キューサイズ確認用 */
static u1   u1s_ceeprom_wque_use;                                    /* EEPROM使用キューサイズ確認用 */
static u1   u1s_ceeprom_rque_use;                                    /* EEPROM使用キューサイズ確認用 */
static u1   u1s_ceeprom_eque_use;                                    /* EEPROM使用キューサイズ確認用 */
#pragma     SECTION bss      bss   /* デフォルトのセクションに戻す *//* EEPROM使用キューサイズ確認用 */
static u2   u2s_ceeprom_wque_count;                                  /* EEPROM使用キューサイズ確認用 */
static u2   u2s_ceeprom_rque_count;                                  /* EEPROM使用キューサイズ確認用 */"
            #書込み内容
            $write_data_file3_N1 = $write_data_file3_before + $src_file_id_N1 + $write_data_file3_after

            $src_file_id_N2 =
"void                              /* EEPROM使用キューサイズ確認用 */
vdg_chkquesizeinit( void )        /* EEPROM使用キューサイズ確認用 */
{                                 /* EEPROM使用キューサイズ確認用 */
    u1s_ceeprom_wque_maxuse = 0;  /* EEPROM使用キューサイズ確認用 */
    u1s_ceeprom_rque_maxuse = 0;  /* EEPROM使用キューサイズ確認用 */
    u1s_ceeprom_eque_maxuse = 0;  /* EEPROM使用キューサイズ確認用 */
    u1s_ceeprom_wque_use = 0;     /* EEPROM使用キューサイズ確認用 */
    u1s_ceeprom_rque_use = 0;     /* EEPROM使用キューサイズ確認用 */
    u1s_ceeprom_eque_use = 0;     /* EEPROM使用キューサイズ確認用 */
    u2s_ceeprom_wque_count = 0;   /* EEPROM使用キューサイズ確認用 */
    u2s_ceeprom_rque_count = 0;   /* EEPROM使用キューサイズ確認用 */
}"
            $write_data_file3_N2 = $write_data_file3_before + $src_file_id_N2 + $write_data_file3_after
            $src_file_id_N3 = 
"   u1s_ceeprom_wque_use = u1g_ceeprom_calc_quesize( u1s_ceeprom_wque_idxw, u1s_ceeprom_wque_idxr, u1g_CEEPROM_WRITE );/* EEPROM使用キューサイズ確認用 */
    if ( u1s_ceeprom_wque_use > u1s_ceeprom_wque_maxuse )                                                              /* EEPROM使用キューサイズ確認用 */
{                                                                                                                  /* EEPROM使用キューサイズ確認用 */
        u1s_ceeprom_wque_maxuse = u1s_ceeprom_wque_use;                                                               /* EEPROM使用キューサイズ確認用 */
}                                                                                                                  /* EEPROM使用キューサイズ確認用 */
        u2s_ceeprom_wque_count++;                                                                                          /* EEPROM使用キューサイズ確認用 */ "
            $write_data_file3_N3 = $write_data_file3_before + $src_file_id_N3 + $write_data_file3_after
            $src_file_id_N4 = 
"   u1s_ceeprom_rque_use = u1g_ceeprom_calc_quesize( u1s_ceeprom_rque_idxw, u1s_ceeprom_rque_idxr, u1g_CEEPROM_READ );/* EEPROM使用キューサイズ確認用 */
    if ( u1s_ceeprom_rque_use > u1s_ceeprom_rque_maxuse )                                                             /* EEPROM使用キューサイズ確認用 */
    {                                                                                                                 /* EEPROM使用キューサイズ確認用 */
        u1s_ceeprom_rque_maxuse = u1s_ceeprom_rque_use;                                                              /* EEPROM使用キューサイズ確認用 */
    }                                                                                                                 /* EEPROM使用キューサイズ確認用 */
    u2s_ceeprom_rque_count++;                                                                                         /* EEPROM使用キューサイズ確認用 */"
            $write_data_file3_N4 = $write_data_file3_before + $src_file_id_N4 + $write_data_file3_after
            $src_file_id_N5 = 
"   u1s_ceeprom_eque_use = u1g_ceeprom_calc_quesize( u1s_ceeprom_eque_idxw, u1s_ceeprom_eque_idxr, u1g_CEEPROM_MEMERR );/* EEPROM使用キューサイズ確認用 */
    if ( u1s_ceeprom_eque_use > u1s_ceeprom_eque_maxuse )                                                               /* EEPROM使用キューサイズ確認用 */
    {                                                                                                                   /* EEPROM使用キューサイズ確認用 */
        u1s_ceeprom_eque_maxuse = u1s_ceeprom_eque_use;                                                                 /* EEPROM使用キューサイズ確認用 */
    }                                                                                                                   /* EEPROM使用キューサイズ確認用 */
    u2s_ceeprom_rque_count++;                                                                                           /* EEPROM使用キューサイズ確認用 *"
            $write_data_file3_N5 = $write_data_file3_before + $src_file_id_N5 + $write_data_file3_after
            $src_file_id_N6 =
"   u1s_ceeprom_wque_use = u1g_ceeprom_calc_quesize( u1s_ceeprom_wque_idxw, u1s_ceeprom_wque_idxr, u1g_CEEPROM_WRITE );/* EEPROM使用キューサイズ確認用 */
    if ( u1s_ceeprom_wque_use > u1s_ceeprom_wque_maxuse )                                                              /* EEPROM使用キューサイズ確認用 */
    {                                                                                                                  /* EEPROM使用キューサイズ確認用 */
        u1s_ceeprom_wque_maxuse = u1s_ceeprom_wque_use;                                                                /* EEPROM使用キューサイズ確認用 */
    }                                                                                                                  /* EEPROM使用キューサイズ確認用 */
    u2s_ceeprom_wque_count++;                                                                                          /* EEPROM使用キューサイズ確認用 */"
            $write_data_file3_N6 = $write_data_file3_before + $src_file_id_N6 + $write_data_file3_after   
            $src_file_id_N7 = 
"   u1s_ceeprom_rque_use = u1g_ceeprom_calc_quesize( u1s_ceeprom_rque_idxw, u1s_ceeprom_rque_idxr, u1g_CEEPROM_READ );/* EEPROM使用キューサイズ確認用 */
    if ( u1s_ceeprom_rque_use > u1s_ceeprom_rque_maxuse )                                                             /* EEPROM使用キューサイズ確認用 */
    {                                                                                                                 /* EEPROM使用キューサイズ確認用 */
        u1s_ceeprom_rque_maxuse = u1s_ceeprom_rque_use;                                                               /* EEPROM使用キューサイズ確認用 */
    }                                                                                                                 /* EEPROM使用キューサイズ確認用 */
    u2s_ceeprom_rque_count++;                                                                                         /* EEPROM使用キューサイズ確認用 */"
            $write_data_file3_N7 = $write_data_file3_before + $src_file_id_N7 + $write_data_file3_after 
            $src_file_id_N8 = 
"   u1s_ceeprom_eque_use = u1g_ceeprom_calc_quesize( u1s_ceeprom_eque_idxw, u1s_ceeprom_eque_idxr, u1g_CEEPROM_MEMERR );/* EEPROM使用キューサイズ確認用 */
    if ( u1s_ceeprom_eque_use > u1s_ceeprom_eque_maxuse )                                                               /* EEPROM使用キューサイズ確認用 */
    {                                                                                                                   /* EEPROM使用キューサイズ確認用 */
        u1s_ceeprom_eque_maxuse = u1s_ceeprom_eque_use;                                                                 /* EEPROM使用キューサイズ確認用 */
    }                                                                                                                   /* EEPROM使用キューサイズ確認用 */"
            $write_data_file3_N8 = $write_data_file3_before + $src_file_id_N8 + $write_data_file3_after 
            $src_file_id_N9 =
"u1                                                                                                                    /* EEPROM使用キューサイズ確認用 */
u1g_ceeprom_calc_quesize( u1 u1t_idxw, u1 u1t_idxr, u1 u1t_mode )                                                     /* EEPROM使用キューサイズ確認用 */
{                                                                                                                     /* EEPROM使用キューサイズ確認用 */
    u1 u1t_quesize = 0;                                                                                               /* EEPROM使用キューサイズ確認用 */
    u1 u1t_maxquesize = 0;                                                                                            /* EEPROM使用キューサイズ確認用 */
    u1 u1t_que_before = 0;                                                                                            /* EEPROM使用キューサイズ確認用 */
    u1 u1t_que = 0;                                                                                                   /* EEPROM使用キューサイズ確認用 */
                                                                                                                        /* EEPROM使用キューサイズ確認用 */
    switch ( u1t_mode )                                                                                               /* EEPROM使用キューサイズ確認用 */
    {                                                                                                                 /* EEPROM使用キューサイズ確認用 */
        case u1g_CEEPROM_WRITE:                                                                                       /* EEPROM使用キューサイズ確認用 */
            u1t_maxquesize = u1s_ceeprom_wquesize;                                                                    /* EEPROM使用キューサイズ確認用 */
            /* キューが満杯かどうかチェックする */                                                                    /* EEPROM使用キューサイズ確認用 */
            /* リングバッファの現在指している読み出しインデックスの直前まで要求が埋まっていることでチェック */        /* EEPROM使用キューサイズ確認用 */
            u1t_que_before = (u1)u2g_cmemmng_sub_queidx( (u2)u1s_ceeprom_wque_idxr, (u1)1, (u2)u1s_ceeprom_wquesize );/* EEPROM使用キューサイズ確認用 */
            u1t_que = sts_ceeprom_wque[u1t_que_before].st_memid.u1_domain_id;                                         /* EEPROM使用キューサイズ確認用 */
            break;                                                                                                    /* EEPROM使用キューサイズ確認用 */
                                                                                                                        /* EEPROM使用キューサイズ確認用 */
        case u1g_CEEPROM_READ:                                                                                        /* EEPROM使用キューサイズ確認用 */
            u1t_maxquesize = u1s_ceeprom_rquesize;                                                                    /* EEPROM使用キューサイズ確認用 */
            /* キューが満杯かどうかチェックする */                                                                    /* EEPROM使用キューサイズ確認用 */
            /* リングバッファの現在指している読み出しインデックスの直前まで要求が埋まっていることでチェック */        /* EEPROM使用キューサイズ確認用 */
            u1t_que_before = (u1)u2g_cmemmng_sub_queidx( (u2)u1s_ceeprom_rque_idxr, (u1)1, (u2)u1s_ceeprom_rquesize );/* EEPROM使用キューサイズ確認用 */
            u1t_que = sts_ceeprom_rque[u1t_que_before].st_memid.u1_domain_id;                                         /* EEPROM使用キューサイズ確認用 */
            break;                                                                                                    /* EEPROM使用キューサイズ確認用 */
                                                                                                                        /* EEPROM使用キューサイズ確認用 */
        case u1g_CEEPROM_MEMERR:                                                                                      /* EEPROM使用キューサイズ確認用 */
            u1t_maxquesize = u1s_ceeprom_equesize;                                                                    /* EEPROM使用キューサイズ確認用 */
            /* キューが満杯かどうかチェックする */                                                                    /* EEPROM使用キューサイズ確認用 */
            /* リングバッファの現在指している読み出しインデックスの直前まで要求が埋まっていることでチェック */        /* EEPROM使用キューサイズ確認用 */
            u1t_que_before = (u1)u2g_cmemmng_sub_queidx( (u2)u1s_ceeprom_eque_idxr, (u1)1, (u2)u1s_ceeprom_equesize );/* EEPROM使用キューサイズ確認用 */
            u1t_que = sts_ceeprom_eque[u1t_que_before].st_memid.u1_domain_id;                                         /* EEPROM使用キューサイズ確認用 */
            break;                                                                                                    /* EEPROM使用キューサイズ確認用 */
                                                                                                                        /* EEPROM使用キューサイズ確認用 */
        default:                                                                                                      /* EEPROM使用キューサイズ確認用 */
            break;                                                                                                    /* EEPROM使用キューサイズ確認用 */
    }                                                                                                                 /* EEPROM使用キューサイズ確認用 */
                                                                                                                        /* EEPROM使用キューサイズ確認用 */
    if ( u1t_idxw - u1t_idxr < 0 )                                                                                    /* EEPROM使用キューサイズ確認用 */
    {                                                                                                                 /* EEPROM使用キューサイズ確認用 */
        u1t_quesize = u1t_maxquesize + u1t_idxw - u1t_idxr;                                                           /* EEPROM使用キューサイズ確認用 */
    }                                                                                                                 /* EEPROM使用キューサイズ確認用 */
    else if ( u1t_idxw - u1t_idxr == 0 )                                                                              /* EEPROM使用キューサイズ確認用 */
    {                                                                                                                 /* EEPROM使用キューサイズ確認用 */
        if ( u1t_que == u1g_CMEMMNG_NULL_ID )               /* キューに空がある時 */                                  /* EEPROM使用キューサイズ確認用 */
        {                                                                                                             /* EEPROM使用キューサイズ確認用 */
            u1t_quesize = 0;                                                                                          /* EEPROM使用キューサイズ確認用 */
        }                                                                                                             /* EEPROM使用キューサイズ確認用 */
        else                                                                                                          /* EEPROM使用キューサイズ確認用 */
        {                                                                                                             /* EEPROM使用キューサイズ確認用 */
            u1t_quesize = u1t_maxquesize;                                                                             /* EEPROM使用キューサイズ確認用 */
        }                                                                                                             /* EEPROM使用キューサイズ確認用 */
    }                                                                                                                 /* EEPROM使用キューサイズ確認用 */
    else                                                                                                              /* EEPROM使用キューサイズ確認用 */
    {                                                                                                                 /* EEPROM使用キューサイズ確認用 */
        u1t_quesize = u1t_idxw - u1t_idxr;                                                                            /* EEPROM使用キューサイズ確認用 */
    }                                                                                                                 /* EEPROM使用キューサイズ確認用 */
                                                                                                                        /* EEPROM使用キューサイズ確認用 */
    return u1t_quesize;                                                                                               /* EEPROM使用キューサイズ確認用 */
}                                                                                                                     /* EEPROM使用キューサイズ確認用 */"
        $write_data_file3_N9 = $write_data_file3_before + $src_file_id_N9 + $write_data_file3_after
#一時ファイルの作成
            if (Test-Path($file3_PATH + ".new")) {
                Remove-Item ($file3_PATH + ".new")
            }
            $src_file = Get-Content $file3_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("static u1   u1s_ceeprom_ref_eepsram_sts;              /**< lsb=1,unit=- :EEPROM+SRAMリフレッシュ制御状態 */")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                    $write_data_file3_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
                    
            elseif ($line.Contains("/* } */") -and $num -eq 341) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u1s_ceeprom_wque_idxw = (u1)u2g_cmemmng_add_queidx( (u2)u1t_wque_idxw, (u1)1U, (u2)u1s_ceeprom_wquesize );  /* キューインデックス加算 */")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u1s_ceeprom_rque_idxw = (u1)u2g_cmemmng_add_queidx( (u2)u1t_rque_idxw, (u1)1U, (u2)u1s_ceeprom_rquesize );  /* キューインデックス加算 */")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N4 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains(" u1s_ceeprom_eque_idxw = (u1)u2g_cmemmng_add_queidx( (u2)u1t_eque_idxw, (u1)1U, (u2)u1s_ceeprom_equesize );  /* キューインデックス加算 */")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N5 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("データ値は消去不要なのでそのまま")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N6 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("データ領域は消去不要なのでそのまま")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N7 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u1s_ceeprom_eque_idxr = (u1)u2g_cmemmng_add_queidx( (u2)u1t_eque_idxr, (u1)1U, (u2)u1s_ceeprom_equesize );     /* 読み出しidx次へ */")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N8 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u1s_ceeprom_eque_idxr = (u1)u2g_cmemmng_add_queidx( (u2)u1t_eque_idxr, (u1)1U, (u2)u1s_ceeprom_equesize );    /* 読み出しidx次へ */")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N8 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("}") -and $num -eq 3266) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N9 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }

                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file3_PATH
        Move-Item ($file3_PATH + ".new") $file3_PATH
        }
        function file4_set_D {
            $file4_PATH =$SOURCES_PATH + $SOURCES_file4_D
            [string[]]$write_data_file4_before = @()
            $write_data_file4_before += ,$set_title_start
            [string[]]$write_data_file4_after = @()
            $write_data_file4_after += ,$set_title_end
            $src_file_id_N1 =
"   vdg_chkquesizeinit();            /* EEPROM使用キューサイズ確認用 */"
            #書込み内容
            $write_data_file4_N1 = $write_data_file4_before + $src_file_id_N1 + $write_data_file4_after
            #一時ファイルの作成
            if (Test-Path($file4_PATH + ".new")) {
                Remove-Item ($file4_PATH + ".new")
            }
            $src_file = Get-Content $file4_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("vdg_cmemmng_pwon();")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                    $write_data_file4_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file4_PATH
        Move-Item ($file4_PATH + ".new") $file4_PATH
        }
        function file5_set_D {
            $file5_PATH =$SOURCES_PATH + $SOURCES_file5_D
            [string[]]$write_data_file5_before = @()
            $write_data_file5_before += ,$set_title_start
            [string[]]$write_data_file5_after = @()
            $write_data_file5_after += ,$set_title_end
            $write_data_file5_after += ,""
            $src_file_id_N1 =
"extern u1 u1g_dbg_mode;                              /* デバックモード切替用フラグ_0:通常制御モード_1:デバックモード */
extern u1 u1g_dbg_RoBmode;                           /* RoBモード切り替えフラグ_0:通常モード_1:RoB同時発生_2:RoB発生(補機)_RoB発生(NM) */
extern u2 u2g_dbg_write_hsrob_soldc1winor_cnt;       /* m=hsrob, lsb=8, ofs=0 ,unit=ms：ソーラーDDC1入力電力定格外継続カウンタ操作用RAM */
extern u2 u2g_dbg_write_hsrob_auxdcthng_cnt;         /* m=hsrob, lsb=8, ofs=0 ,unit=ms：補機DDC高温異常継続カウンタ操作用RAM */
extern u4 u4g_dbg_write_wnmrewkup_cwkupcnt;          /* RAM値操作用RAM(u4s_wnmrewkup_cwkupcnt) */
extern u1 u1g_dbg_write_wnmrewkup_wkupcnt;           /* RAM値操作用RAM(u1s_wnmrewkup_wkupcnt) */
extern u4 u4g_dbg_write_wnmslpng_cslpngcnt;          /* RAM値操作用RAM(u4s_wnmslpng_cslpngcnt) */
extern u1 u1g_dbg_write_aplawkfctigb;                /* RAM値操作用RAM(u1t_aplawkfctigb) */
extern u4 u4g_dbg_write_wslprewkup_cwkupcnt;         /* RAM値操作用RAM(u4s_wslprewkup_cwkupcnt) */
extern u1 u1g_dbg_write_wslprewkup_wkupcnt;          /* RAM値操作用RAM(u1s_wslprewkup_wkupcnt) */
extern u4 u4g_dbg_write_wslpslpng_cslpngcnt;         /* RAM値操作用RAM(u4s_wslpslpng_cslpngcnt) */"
            #書込み内容
            $write_data_file5_N1 = $write_data_file5_before + $src_file_id_N1 + $write_data_file5_after
            #一時ファイルの作成
            if (Test-Path($file5_PATH + ".new")) {
                Remove-Item ($file5_PATH + ".new")
            }
            $src_file = Get-Content $file5_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#endif  /* COMMON_H */")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $write_data_file5_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file5_PATH + ".new") -Append   
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file5_PATH + ".new") -Append 
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file5_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file5_PATH
        Move-Item ($file5_PATH + ".new") $file5_PATH
        }
        function file6_set_D {
            $file6_PATH =$SOURCES_PATH + $SOURCES_file6_D 
            [string[]]$write_data_file6_before = @()
            $write_data_file6_before += ,$set_title_start
            $write_data_file6_before += "   #if 0"
            [string[]]$write_data_file6_after = @()
            $write_data_file6_after += "    #endif"
            $write_data_file6_after +=" 	    #define  PROGRAMID  `"894BF-K00A0-3   `""
            $write_data_file6_after += ,$set_title_end
            if ($VARI -eq 1000) {
                $src_file_id= (Get-Content $file6_PATH -TotalCount 49)[-1]
            }else {
                $src_file_id= (Get-Content $file6_PATH -TotalCount 53)[-1]
            }
            $src_file_id = "    " + $src_file_id 
            #書込み内容
            $write_data_file6 = $write_data_file6_before + $src_file_id + $write_data_file6_after 
            
            #一時ファイルの作成
            if (Test-Path($file6_PATH + ".new")) {
                Remove-Item ($file6_PATH + ".new")
            }
            $src_file = Get-Content $file6_PATH
            [bool]$is_target_section = $false # 処理対象区間か
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
                if ($line.Contains("#if ( JGVARI == 1000 )")) {
                        $is_target_section = $true
                        #% {} は foreach（Foreach-Object）を意味します
                        # |符号の意味：パイプライン
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append
            
                        $write_data_file6 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append
                    }
                    elseif ($line.Contains("#elif ( JGVARI == 1100 )")) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append
                        $is_target_section = $false
                    }
                    else {
                        if ($is_target_section -eq $false) {
                            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append
                        }
                    }
            }
        }else{
            foreach ($line in $src_file) {
                # 処理対象の開始行より前はそのまま出力
                # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#elif ( JGVARI == 1100 )")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append
        
                    $write_data_file6 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append
                }
                elseif ($line.Contains("#else")) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append
                    $is_target_section = $false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append
                    }
                }
        }
        }
        Remove-Item $file6_PATH
        Move-Item ($file6_PATH + ".new") $file6_PATH
}
        function file7_set_D {
            $file7_PATH =$SOURCES_PATH + $SOURCES_file7_D
            [string[]]$write_data_file7_before = @()
            $write_data_file7_before += ,$set_title_start
            $write_data_file7_before +="#if 0"
            [string[]]$write_data_file7_after = @()
            $write_data_file7_after +=
"#endif
    /* RoB発生条件更新停止処理 */
    if(u1g_dbg_mode == (u1)1)
    {
        /* 更新処理なし */
    }
    else
    {
        u1g_hsbstdcdvi_xthng = u1t_tmp;
    }
    "
            $write_data_file7_after += ,$set_title_end
            #一時ファイルの作成
            if (Test-Path($file7_PATH + ".new")) {
                Remove-Item ($file7_PATH + ".new")
            }
            $src_file = Get-Content $file7_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("u1g_hsbstdcdvi_xthng = u1t_tmp;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $write_data_file7_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append   
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append 
                    $write_data_file7_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file7_PATH
        Move-Item ($file7_PATH + ".new") $file7_PATH
        }
        function file8_set_D {
            $file8_PATH =$SOURCES_PATH + $SOURCES_file8_D
            [string[]]$write_data_file8_before = @()
            $write_data_file8_before += ,$set_title_start
            $write_data_file8_before +="#if 0"
            [string[]]$write_data_file8_after = @()
            $write_data_file8_after +=
"#endif
/* RoB発生条件更新停止処理 */
    if(u1g_dbg_mode == (u1)1)
    {
        /* 更新処理なし */
    }
    else
    {
        u1g_hsecucomi_soljdg = u1g_zcandat_soljdg;
    }"
            $write_data_file8_after += ,$set_title_end
            #一時ファイルの作成
            if (Test-Path($file8_PATH + ".new")) {
                Remove-Item ($file8_PATH + ".new")
            }
            $src_file = Get-Content $file8_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("u1g_hsecucomi_soljdg = u1g_zcandat_soljdg;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $write_data_file8_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append   
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append 
                    $write_data_file8_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file8_PATH
        Move-Item ($file8_PATH + ".new") $file8_PATH
        }
        function file9_set_D {
            $file9_PATH =$SOURCES_PATH + $SOURCES_file9_D
            [string[]]$write_data_file9_before = @()
            $write_data_file9_before += ,$set_title_start
            $write_data_file9_before +="#if 0"
            [string[]]$write_data_file9_after = @()
            $write_data_file9_after +=
"#endif
/* RoB発生条件更新停止処理 */
    if(u1g_dbg_mode == (u1)1)
    {
        /* 更新処理なし */
    }
    else
    {
        u1g_hsmiddvi_xovsf = u1t_tmp4;
    }"
            $write_data_file9_after += ,$set_title_end
            #一時ファイルの作成
            if (Test-Path($file9_PATH + ".new")) {
                Remove-Item ($file9_PATH + ".new")
            }
            $src_file = Get-Content $file9_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("u1g_hsmiddvi_xovsf = u1t_tmp4;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $write_data_file9_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file9_PATH + ".new") -Append   
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file9_PATH + ".new") -Append 
                    $write_data_file9_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file9_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file9_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file9_PATH
        Move-Item ($file9_PATH + ".new") $file9_PATH
        }
        function file10_set_D {
            $file10_PATH =$SOURCES_PATH + $SOURCES_file10_D
            [string[]]$write_data_file10_before = @()
            $write_data_file10_before += ,$set_title_start
            [string[]]$write_data_file10_after = @()
            $write_data_file10_after += ,$set_title_end
            $src_file_id_N1 = 
"u2 u2g_dbg_write_hsrob_soldc1winor_cnt;  /* m=hsrob, lsb=8, ofs=0 ,unit=ms：ソーラーDDC1入力電力定格外継続カウンタ操作用RAM */
u2 u2g_dbg_write_hsrob_auxdcthng_cnt;    /* m=hsrob, lsb=8, ofs=0 ,unit=ms：補機DDC高温異常継続カウンタ操作用RAM */"
            #書込み内容
            $write_data_file10_N1 = $write_data_file10_before + $src_file_id_N1 + $write_data_file10_after

            $src_file_id_N2 =
"   /* u2s_hsrob_auxdcthng_cnt更新処理 */
    if(u1g_dbg_mode == (u1)1)
    {
        u2s_hsrob_auxdcthng_cnt = u2g_dbg_write_hsrob_auxdcthng_cnt;
    }"
            $write_data_file10_N2 = $write_data_file10_before + $src_file_id_N2 + $write_data_file10_after
            $src_file_id_N3 = 
"   /* u2s_hsrob_soldc1winor_cnt更新処理 */
    if(u1g_dbg_mode == (u1)1)
    {
        u2s_hsrob_soldc1winor_cnt = u2g_dbg_write_hsrob_soldc1winor_cnt;
    }"
            $write_data_file10_N3 = $write_data_file10_before + $src_file_id_N3 + $write_data_file10_after

            $src_file_id_N4_before = $write_data_file10_before
            $src_file_id_N4_before += ,"#if 0"

            $src_file_id_N4_after = 
"#endif
        /* RoB発生条件更新停止処理 */
        if(u1g_dbg_mode == (u1)1)
        {
            /* 更新処理なし */
        }
        else
        {
            u2t_tmp3 = 0U;
        }
"
            $src_file_id_N4_after += ,$set_title_end

            $src_file_id_N5_before = $write_data_file10_before
            $src_file_id_N5_before += ,"#if 0"

            $src_file_id_N5_after = 
"#endif
        /* RoB発生条件更新停止処理 */
        if(u1g_dbg_mode == (u1)1)
        {
            /* 更新処理なし */
        }
        else
        {
            u2t_tmp3 = 0U;
        }
"
            $src_file_id_N5_after += ,$set_title_end

            $src_file_id_N6_before = $write_data_file10_before
            $src_file_id_N6_before += ,"#if 0"

            $src_file_id_N6_after = 
"#endif
    /* RoB発生条件更新停止処理 */
    if(u1g_dbg_mode == (u1)1)
    {
        /* 更新処理なし */
    }
    else
    {
        u2s_hsrob_soldc1winor_cnt = u2t_tmp;
        u2g_dbg_write_hsrob_soldc1winor_cnt = u2t_tmp; /* 操作用RAM上書き処理 */
    }
"
            $src_file_id_N6_after +=, $write_data_file10_after

            $src_file_id_N7_before = $write_data_file10_before
            $src_file_id_N7_before += ,"#if 0"

            $src_file_id_N7_after = 
"#endif
    /* RoB発生条件更新停止処理 */
    if(u1g_dbg_mode == (u1)1)
    {
        /* 更新処理なし */
    }
    else
    {
        u2s_hsrob_auxdcthng_cnt = u2t_tmp3;
        u2g_dbg_write_hsrob_auxdcthng_cnt = u2t_tmp3; /* 操作用RAM上書き処理 */
    }
"
            $src_file_id_N7_after += ,$set_title_end
    


#一時ファイルの作成
            if (Test-Path($file10_PATH + ".new")) {
                Remove-Item ($file10_PATH + ".new")
            }
            $src_file = Get-Content $file10_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("u1 u1g_hsrob_xsolgnstp_ddc;       /* m=hsrob, lsb=1, ofs=0, unit=-:SOL発電取り下げ(DDC)RoB */")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append 
                    $write_data_file10_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
                    
            elseif ($line.Contains("u2t_tmp3 = u2s_hsrob_auxdcthng_cnt;")) {
                $is_target_section = $true
                $write_data_file10_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u2t_tmp = u2s_hsrob_soldc1winor_cnt;")) {
                $is_target_section = $true
                $write_data_file10_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u2t_tmp3 = 0U;") -and $num -eq 395) {
                $is_target_section = $true
                $src_file_id_N4_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $src_file_id_N4_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u2t_tmp = 0U;") -and $num -eq 521) {
                $is_target_section = $true
                $src_file_id_N5_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $src_file_id_N5_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u2s_hsrob_soldc1winor_cnt = u2t_tmp;")) {
                $is_target_section = $true
                $src_file_id_N6_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $src_file_id_N6_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u2s_hsrob_auxdcthng_cnt = u2t_tmp3;")) {
                $is_target_section = $true
                $src_file_id_N7_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $src_file_id_N7_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                $is_target_section = $false
                }
            
            else {
                if ($is_target_section -eq $false) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                }
            }
                $num =$num +1                   
        }     
        Remove-Item $file10_PATH
        Move-Item ($file10_PATH + ".new") $file10_PATH
        }
        function file11_set_D {
            $file11_PATH =$SOURCES_PATH + $SOURCES_file11_D 
            [string[]]$write_data_file11_before = @()
            $write_data_file11_before += ,$set_title_start
            $write_data_file11_before += "   #if 0"
            [string[]]$write_data_file11_after = @()
            $write_data_file11_after += "    #endif"
            $write_data_file11_after += "        #define u4s_SPP_SDBGINFO_VER     ((u4)0xFF030A00U))"
            $write_data_file11_after += ,$set_title_end
            if ($VARI -eq 1000) {
                $src_file_id= (Get-Content $file11_PATH -TotalCount 118)[-1]
            }else {
                $src_file_id= (Get-Content $file11_PATH -TotalCount 122)[-1]
            }
            $src_file_id = "    " + $src_file_id 
            #書込み内容
            $write_data_file11 = $write_data_file11_before + $src_file_id + $write_data_file11_after 
            
            #一時ファイルの作成
            if (Test-Path($file11_PATH + ".new")) {
                Remove-Item ($file11_PATH + ".new")
            }
            $src_file = Get-Content $file11_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
                if ($line.Contains("#if ( JGVARI == 1000 )") -and $num -eq 116) {
                        $is_target_section = $true
                        #% {} は foreach（Foreach-Object）を意味します
                        # |符号の意味：パイプライン
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
            
                        $write_data_file11 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
                    }
                    elseif ($line.Contains("#elif ( JGVARI == 1100 )") ) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
                        $is_target_section = $false
                    }
                    else {
                        if ($is_target_section -eq $false) {
                            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
                        }
                    }
                    $num =$num +1
                    
            }
        }else{
            foreach ($line in $src_file) {
                # 処理対象の開始行より前はそのまま出力
                # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#elif ( JGVARI == 1100 )") -and $num -eq 120 ) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
        
                    $write_data_file11 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
                }
                elseif ($line.Contains("#else")) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
                    $is_target_section = $false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
                    }
                }
                $num =$num +1
        }
}
        Remove-Item $file11_PATH
        Move-Item ($file11_PATH + ".new") $file11_PATH  
        }
        function file12_set_D {
            $file12_PATH =$SOURCES_PATH + $SOURCES_file12_D
            [string[]]$write_data_file12_before = @()
            $write_data_file12_before += ,$set_title_start
            [string[]]$write_data_file12_after = @()
            $write_data_file12_after += ,$set_title_end
            $src_file_id_N1 = 
"u4 u4g_dbg_write_wnmrewkup_cwkupcnt;      /* RAM値操作用RAM(u4s_wnmrewkup_cwkupcnt) */
u1 u1g_dbg_write_wnmrewkup_wkupcnt;       /* RAM値操作用RAM(u1s_wnmrewkup_wkupcnt) */"
            #書込み内容
            $write_data_file12_N1 = $write_data_file12_before + $src_file_id_N1 + $write_data_file12_after
            $src_file_id_N2 =
"   /* 更新処理 */
    if(u1g_dbg_mode == (u1)1)
    {
        u4s_wnmrewkup_cwkupcnt = u4g_dbg_write_wnmrewkup_cwkupcnt;
        u1s_wnmrewkup_wkupcnt = u1g_dbg_write_wnmrewkup_wkupcnt;
    }"
            $write_data_file12_N2 = $write_data_file12_before + $src_file_id_N2 + $write_data_file12_after

            $src_file_id_N3_before = $write_data_file12_before
            $src_file_id_N3_before += ,"#if 0"
            $src_file_id_N3_after = 
"#endif
            /* RoB発生条件更新停止処理 */
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                u4s_wnmrewkup_cwkupcnt = u4g_gladdst_u4u4( u4s_wnmrewkup_cwkupcnt, (u4)1 );               /* ウェイクアップカウンタカウントアップ */
            }
"
            $src_file_id_N3_after += ,$set_title_end

            $src_file_id_N4_before = $write_data_file12_before
            $src_file_id_N4_before += ,"#if 0"

            $src_file_id_N4_after = 
"#endif
            /* RoB発生条件更新停止処理 */
            if(u1g_dbg_mode == (u1)1)
                    {
                        /* 更新処理なし */
                    }
                    else
                    {
                        u1s_wnmrewkup_wkupcnt = u1g_gladdst_u1u1( u1s_wnmrewkup_wkupcnt, (u1)1 );    /* ウェイクアップ回数カウントアップ */
                    }
"
            $src_file_id_N4_after += ,$set_title_end

            $src_file_id_N5_before = $write_data_file12_before
            $src_file_id_N5_before += ,"#if 0"

            $src_file_id_N5_after = 
"#endif
            /* RoB発生条件更新停止処理 */
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                u1s_wnmrewkup_wkupcnt = (u1)0;                                                    /* ウェイクアップ回数クリア */
                u4s_wnmrewkup_cwkupcnt = (u4)0;                                                   /* ウェイクアップカウンタクリア */
            }
"
            $src_file_id_N5_after += ,$set_title_end

            $src_file_id_N6_before = $write_data_file12_before
            $src_file_id_N6_before += ,"#if 0"

            $src_file_id_N6_after = 
"#endif
            /* RoB発生条件更新停止処理 */
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                vdg_cboshtif_slp_enable( u2g_OBD_WROBGRP_SLPID );                                     /* スリープ許可要求 */
            }
"
            $src_file_id_N6_after += ,$set_title_end

            $src_file_id_N7_before = $write_data_file12_before
            $src_file_id_N7_before += ,"#if 0"

            $src_file_id_N7_after = 
"#endif
            /* RoB発生条件更新停止処理 */
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_REWKUP, (u4)0U );                             /* リセット要求 */
            }
"
            $src_file_id_N7_after += ,$set_title_end


            $src_file_id_N8 =
"
    /* 更新処理 */
if(u1g_dbg_mode == (u1)0)
    {
        u4g_dbg_write_wnmrewkup_cwkupcnt = u4s_wnmrewkup_cwkupcnt;
        u1g_dbg_write_wnmrewkup_wkupcnt = u1s_wnmrewkup_wkupcnt;
    }"
            $write_data_file12_N8 = $write_data_file12_before + $src_file_id_N8 + $write_data_file12_after

#一時ファイルの作成
            if (Test-Path($file12_PATH + ".new")) {
                Remove-Item ($file12_PATH + ".new")
            }
            $src_file = Get-Content $file12_PATH 
            
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#define u1s_wnmrewkup_num       (sts_wnmrewkup_data.u1_num)")) {
                    $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append 
                $write_data_file12_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append   
                $is_target_section = $false
                }
                    
            elseif ($line.Contains("u1 u1t_aplawkfcttime;")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $write_data_file12_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u4s_wnmrewkup_cwkupcnt = u4g_gladdst_u4u4( u4s_wnmrewkup_cwkupcnt, (u4)1 );")) {
                $is_target_section = $true
                $src_file_id_N3_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $src_file_id_N3_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains(" u1s_wnmrewkup_wkupcnt = u1g_gladdst_u1u1( u1s_wnmrewkup_wkupcnt, (u1)1 );     /* ウェイクアップ回数カウントアップ */")) {
                $is_target_section = $true
                $src_file_id_N4_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $src_file_id_N4_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u1s_wnmrewkup_wkupcnt = (u1)0;                                                    /* ウェイクアップ回数クリア */")) {
                $is_target_section = $true
                $src_file_id_N5_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u4s_wnmrewkup_cwkupcnt = (u4)0;                                                   /* ウェイクアップカウンタクリア */")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $src_file_id_N5_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("vdg_cboshtif_slp_enable( u2g_OBD_WROBGRP_SLPID );                                     /* スリープ許可要求 */")) {
                $is_target_section = $true
                $src_file_id_N6_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $src_file_id_N6_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_REWKUP, (u4)0U );")) {
                $is_target_section = $true
                $src_file_id_N7_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $src_file_id_N7_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("(void)s4g_cmemif_write( u4g_WNMREWKUP_DATA_ST_MID, (void *)&sts_wnmrewkup_data );                 /* ウェイクアップカウンタ、要因、ウェイクアップ回数、検出制御状態、要因数書込み */ /* 戻り値は使用しない */")) {
                $is_target_section = $true
                $write_data_file12_N8 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $is_target_section = $false
                }
            else {
                if ($is_target_section -eq $false) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                }
            }
                $num =$num +1                   
        }     
        Remove-Item $file12_PATH
        Move-Item ($file12_PATH + ".new") $file12_PATH
        }
        function file13_set_D {
            $file13_PATH =$SOURCES_PATH + $SOURCES_file13_D
            [string[]]$write_data_file13_before = @()
            $write_data_file13_before += ,$set_title_start
            [string[]]$write_data_file13_after = @()
            $write_data_file13_after += ,$set_title_end
            $src_file_id_N1 = 
"u4 u4g_dbg_write_wnmslpng_cslpngcnt;      /* RAM値操作用RAM(u4s_wnmslpng_cslpngcnt) */
u1 u1g_dbg_write_aplawkfctigb;            /* RAM値操作用RAM(u1t_aplawkfctigb) */"
            #書込み内容
            $write_data_file13_N1 = $write_data_file13_before + $src_file_id_N1 + $write_data_file13_after


            $src_file_id_N2_before = $write_data_file13_before
            $src_file_id_N2_before += ,"#if 0"
            $src_file_id_N2_after = 
"#endif
    /* RoB発生条件更新停止処理 */
    if(u1g_dbg_mode == (u1)1)
    {
        u4s_wnmslpng_cslpngcnt = u4g_dbg_write_wnmslpng_cslpngcnt;
        u1t_aplawkfctigb = u1g_dbg_write_aplawkfctigb;
    }
    else
    {
        u1t_aplawkfctigb = ( u1t_aplawkfct & u1g_CCANIF_APLAWKFCT_IGBRQON );                  /* アウェイク要因をIGB要求ONでマスク */
    }
"
            $src_file_id_N2_after += ,$set_title_end

            $src_file_id_N3_before = $write_data_file13_before
            $src_file_id_N3_before += ,"#if 0"
            $src_file_id_N3_after = 
"#endif
    /* RoB発生条件更新停止処理 */
    if(u1g_dbg_mode == (u1)1)
    {
        /* 更新処理なし */
    }
    else
    {
        u4s_wnmslpng_cslpngcnt = u4g_gladdst_u4u4( u4s_wnmslpng_cslpngcnt, (u4)1 ); /* スリープNGカウンタカウントアップ */
    }
"
            $src_file_id_N3_after += ,$set_title_end

            $src_file_id_N4_before = $write_data_file13_before
            $src_file_id_N4_before += ,"#if 0"
            $src_file_id_N4_after = 
"#endif
    /* RoB発生条件更新停止処理 */
    if(u1g_dbg_mode == (u1)1)
    {
        /* 更新処理なし */
    }
    else
    {
        u4s_wnmslpng_cslpngcnt = (u4)0;                                           /* スリープNGカウンタクリア */
    }
"
            $src_file_id_N4_after += ,$set_title_end

            $src_file_id_N5_before = $write_data_file13_before
            $src_file_id_N5_before += ,"#if 0"
            $src_file_id_N5_after = 
"#endif
            /* RoB発生条件更新停止処理 */
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                vdg_cboshtif_slp_enable( u2g_OBD_WROBGRP_SLPID );                         /* スリープ許可要求 */
            }
"
            $src_file_id_N5_after += ,$set_title_end

            $src_file_id_N6_before = $write_data_file13_before
            $src_file_id_N6_before += ,"#if 0"
            $src_file_id_N6_after = 
"#endif
            /* RoB発生条件更新停止処理 */
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_SLPNG, (u4)0U );                  /* リセット要求 */
            }
"
            $src_file_id_N6_after += ,$set_title_end

            $src_file_id_N7 = 
"   /* 更新処理 */
    if(u1g_dbg_mode == (u1)0)
    {
        u4g_dbg_write_wnmslpng_cslpngcnt = u4s_wnmslpng_cslpngcnt;
        u1g_dbg_write_aplawkfctigb = u1t_aplawkfctigb;
    }"
            #書込み内容
            $write_data_file13_N7 = $write_data_file13_before + $src_file_id_N7 + $write_data_file13_after




#一時ファイルの作成
            if (Test-Path($file13_PATH + ".new")) {
                Remove-Item ($file13_PATH + ".new")
            }
            $src_file = Get-Content $file13_PATH 
            
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("u1 u1g_wnmslpng_factor;")) {
                    $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append 
                $write_data_file13_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($line.Contains("u1t_aplawkfctigb = ( u1t_aplawkfct & u1g_CCANIF_APLAWKFCT_IGBRQON );")) {
                $is_target_section = $true
                $src_file_id_N2_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $src_file_id_N2_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u4s_wnmslpng_cslpngcnt = u4g_gladdst_u4u4( u4s_wnmslpng_cslpngcnt, (u4)1 );")) {
                $is_target_section = $true
                $src_file_id_N3_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $src_file_id_N3_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u4s_wnmslpng_cslpngcnt = (u4)0;") -and $num -eq 150) {
                $is_target_section = $true
                $src_file_id_N4_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $src_file_id_N4_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("vdg_cboshtif_slp_enable( u2g_OBD_WROBGRP_SLPID );")) {
                $is_target_section = $true
                $src_file_id_N5_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $src_file_id_N5_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_SLPNG, (u4)0U );")) {
                $is_target_section = $true
                $src_file_id_N6_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $src_file_id_N6_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("}") -and $num -eq 175) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append 
                $write_data_file13_N7 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append   
                $is_target_section = $false
                }
            else {
                if ($is_target_section -eq $false) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file13_PATH + ".new") -Append
                }
            }
                $num =$num +1                   
        }    
        Remove-Item $file13_PATH
        Move-Item ($file13_PATH + ".new") $file13_PATH
        
    }
        function file14_set_D {
        $file14_PATH =$SOURCES_PATH + $SOURCES_file14_D
        [string[]]$write_data_file14_before = @()
        $write_data_file14_before += ,$set_title_start
        [string[]]$write_data_file14_after = @()
        $write_data_file14_after += ,$set_title_end
        $src_file_id_N1 = 
"u4 u4g_dbg_write_wslprewkup_cwkupcnt;        /* RAM値操作用RAM(u4s_wslprewkup_cwkupcnt) */
u1 u1g_dbg_write_wslprewkup_wkupcnt;         /* RAM値操作用RAM(u1s_wslprewkup_wkupcnt) */"
        #書込み内容
        $write_data_file14_N1 = $write_data_file14_before + $src_file_id_N1 + $write_data_file14_after

        $src_file_id_N2 = 
"   /* 更新処理 */
    if(u1g_dbg_mode == (u1)1)
    {
        u4s_wslprewkup_cwkupcnt = u4g_dbg_write_wslprewkup_cwkupcnt;
        u1s_wslprewkup_wkupcnt = u1g_dbg_write_wslprewkup_wkupcnt;
    }"
        #書込み内容
        $write_data_file14_N2 = $write_data_file14_before + $src_file_id_N2 + $write_data_file14_after

        $src_file_id_N3_before = $write_data_file14_before
        $src_file_id_N3_before += ,"#if 0"
        $src_file_id_N3_after = 
"#endif
            /* RoB発生条件更新停止処理 */
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                u4s_wslprewkup_cwkupcnt = u4g_gladdst_u4u4( u4s_wslprewkup_cwkupcnt, (u4)1 );           /* ウェイクアップカウンタカウントアップ */
            }
"
        $src_file_id_N3_after += ,$set_title_end


        $src_file_id_N4_before = $write_data_file14_before
        $src_file_id_N4_before += ,"#if 0"
        $src_file_id_N4_after = 
"#endif
                        /* RoB発生条件更新停止処理 */
                        if(u1g_dbg_mode == (u1)1)
                        {
                            /* 更新処理なし */
                        }
                        else
                        {
                            u1s_wslprewkup_wkupcnt = u1g_gladdst_u1u1( u1s_wslprewkup_wkupcnt, (u1)1 );     /* ウェイクアップ回数カウントアップ */
                        }
"
        $src_file_id_N4_after += ,$set_title_end
        
        $src_file_id_N5_before = $write_data_file14_before
        $src_file_id_N5_before += ,"#if 0"
        $src_file_id_N5_after = 
"#endif
                    /* RoB発生条件更新停止処理 */
                    if(u1g_dbg_mode == (u1)1)
                    {
                        /* 更新処理なし */
                    }
                    else
                    {
                        u1s_wslprewkup_wkupcnt = (u1)0;                                                 /* ウェイクアップ回数クリア */
                        u4s_wslprewkup_cwkupcnt = (u4)0;                                                /* ウェイクアップカウンタクリア */
                    }
"
        $src_file_id_N5_after += ,$set_title_end

        $src_file_id_N6_before = $write_data_file14_before
        $src_file_id_N6_before += ,"#if 0"
        $src_file_id_N6_after = 
"#endif
                /* RoB発生条件更新停止処理 */
                if(u1g_dbg_mode == (u1)1)
                {
                    /* 更新処理なし */
                }
                else
                {
                    vdg_cboshtif_slp_enable( u2g_OBD_WROBGRP_SLPID );                               /* スリープ許可要求 */
                }
"
        $src_file_id_N6_after += ,$set_title_end

        $src_file_id_N7_before = $write_data_file14_before
        $src_file_id_N7_before += ,"#if 0"
        $src_file_id_N7_after = 
"#endif
                /* RoB発生条件更新停止処理 */
                if(u1g_dbg_mode == (u1)1)
                {
                    /* 更新処理なし */
                }
                else
                {
                    vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_REWKUP, (u4)0U );                           /* リセット要求 */
                }
"
        $src_file_id_N7_after += ,$set_title_end

        $src_file_id_N8 = 
"   /* 更新処理 */
    if(u1g_dbg_mode == (u1)0)
    {
        u4g_dbg_write_wslprewkup_cwkupcnt = u4s_wslprewkup_cwkupcnt;
        u1g_dbg_write_wslprewkup_wkupcnt = u1s_wslprewkup_wkupcnt;
    }"
        #書込み内容
        $write_data_file14_N8 = $write_data_file14_before + $src_file_id_N8 + $write_data_file14_after


#一時ファイルの作成
        if (Test-Path($file14_PATH + ".new")) {
            Remove-Item ($file14_PATH + ".new")
        }
        $src_file = Get-Content $file14_PATH 
        
        [bool]$is_target_section = $false # 処理対象区間か
        [double]$num = 1  
        foreach ($line in $src_file) {
                # 処理対象の開始行より前はそのまま出力
                # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                # 処理対象の終了行からはそのまま出力
        if ($line.Contains("#define u1s_wslprewkup_num       (sts_wslprewkup_data.u1_num)")) {
            $is_target_section = $true
            #% {} は foreach（Foreach-Object）を意味します
            # |符号の意味：パイプライン
            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append 
            $write_data_file14_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append   
            $is_target_section = $false
            }
        elseif ($line.Contains("u1 u1t_i;                       /* ループカウンタ */")) {
            $is_target_section = $true
            #% {} は foreach（Foreach-Object）を意味します
            # |符号の意味：パイプライン
            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append 
            $write_data_file14_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append   
            $is_target_section = $false
            }
        elseif ($line.Contains("u4s_wslprewkup_cwkupcnt = u4g_gladdst_u4u4( u4s_wslprewkup_cwkupcnt, (u4)1 );")) {
            $is_target_section = $true
            $src_file_id_N3_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $src_file_id_N3_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $is_target_section = $false
            }
        elseif ($line.Contains("u1s_wslprewkup_wkupcnt = u1g_gladdst_u1u1( u1s_wslprewkup_wkupcnt, (u1)1 );")) {
            $is_target_section = $true
            $src_file_id_N4_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $src_file_id_N4_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $is_target_section = $false
            }
        elseif ($line.Contains("u1s_wslprewkup_wkupcnt = (u1)0;") -and $num -eq 223) {
            $is_target_section = $true
            $src_file_id_N5_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $is_target_section = $false
            }
        elseif ($line.Contains("u4s_wslprewkup_cwkupcnt = (u4)0;")-and $num -eq 224) {
            $is_target_section = $true
            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $src_file_id_N5_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $is_target_section = $false
            }
        elseif ($line.Contains("vdg_cboshtif_slp_enable( u2g_OBD_WROBGRP_SLPID );")) {
            $is_target_section = $true
            $src_file_id_N6_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $src_file_id_N6_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $is_target_section = $false
            }
        elseif ($line.Contains("vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_REWKUP, (u4)0U );")) {
            $is_target_section = $true
            $src_file_id_N7_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $src_file_id_N7_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            $is_target_section = $false
            }
        elseif ($line.Contains("(void)s4g_cmemif_write( u4g_WSLPREWKUP_DATA_ST_MID, (void *)&sts_wslprewkup_data );") -and $num -eq 247) {
            $is_target_section = $true
            $write_data_file14_N8 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append 
            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append   
            $is_target_section = $false
            }
        else {
            if ($is_target_section -eq $false) {
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append
            }
        }
            $num =$num +1                   
    }    
    Remove-Item $file14_PATH
    Move-Item ($file14_PATH + ".new") $file14_PATH
    
}
        function file15_set_D {
            $file15_PATH =$SOURCES_PATH + $SOURCES_file15_D
            [string[]]$write_data_file15_before = @()
            $write_data_file15_before += ,$set_title_start
            [string[]]$write_data_file15_after = @()
            $write_data_file15_after += ,$set_title_end
            $src_file_id_N1 = 
"u4 u4g_dbg_write_wslpslpng_cslpngcnt;               /* RAM値操作用RAM(u4s_wslpslpng_cslpngcnt) */"
            #書込み内容
            $write_data_file15_N1 = $write_data_file15_before + $src_file_id_N1 + $write_data_file15_after

            $src_file_id_N2 = 
"   /* 更新処理 */
    if(u1g_dbg_mode == (u1)1)
    {
        u4s_wslpslpng_cslpngcnt = u4g_dbg_write_wslpslpng_cslpngcnt;
    }"
            #書込み内容
            $write_data_file15_N2 = $write_data_file15_before + $src_file_id_N2 + $write_data_file15_after

            $src_file_id_N3_before = $write_data_file15_before
            $src_file_id_N3_before += ,"#if 0"
            $src_file_id_N3_after = 
"#endif
            /* RoB発生条件更新停止処理 */
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                u4s_wslpslpng_cslpngcnt = u4g_gladdst_u4u4( u4s_wslpslpng_cslpngcnt, (u4)1 );   /* スリープNGカウンタカウントアップ */
            }
"
            $src_file_id_N3_after += ,$set_title_end

            $src_file_id_N4_before = $write_data_file15_before
            $src_file_id_N4_before += ,"#if 0"
            $src_file_id_N4_after = 
"#endif
            /* RoB発生条件更新停止処理 */
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                u4s_wslpslpng_cslpngcnt = (u4)0;                                            /* スリープNG継続時間カウンタクリア */
            }
"
            $src_file_id_N4_after += ,$set_title_end

            $src_file_id_N5_before = $write_data_file15_before
            $src_file_id_N5_before += ,"#if 0"
            $src_file_id_N5_after = 
"#endif
            /* RoB発生条件更新停止処理 */
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                vdg_cboshtif_slp_enable( u2g_OBD_WROBGRP_SLPID );                           /* スリープ許可要求 */
            }
"
            $src_file_id_N5_after += ,$set_title_end

            $src_file_id_N6_before = $write_data_file15_before
            $src_file_id_N6_before += ,"#if 0"
            $src_file_id_N6_after = 
"#endif
            /* RoB発生条件更新停止処理 */
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_SLPNG, (u4)0U );                    /* リセット要求 */
            }
"
            $src_file_id_N6_after += ,$set_title_end

            $src_file_id_N7 = 
"   /* 更新処理 */
    if(u1g_dbg_mode == (u1)0)
    {
        u4g_dbg_write_wslpslpng_cslpngcnt = u4s_wslpslpng_cslpngcnt;
    }"
            #書込み内容
            $write_data_file15_N7 = $write_data_file15_before + $src_file_id_N7 + $write_data_file15_after


        #一時ファイルの作成
            if (Test-Path($file15_PATH + ".new")) {
                Remove-Item ($file15_PATH + ".new")
            }
            $src_file = Get-Content $file15_PATH 
            
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("u1 u1g_wslpslpng_factor;")) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append 
                $write_data_file15_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($line.Contains("u1 u1t_xnochg;")) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append 
                $write_data_file15_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($line.Contains("u4s_wslpslpng_cslpngcnt = u4g_gladdst_u4u4( u4s_wslpslpng_cslpngcnt, (u4)1 );")) {
                $is_target_section = $true
                $src_file_id_N3_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $src_file_id_N3_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u4s_wslpslpng_cslpngcnt = (u4)0;                                            /* スリープNG継続時間カウンタクリア */")) {
                $is_target_section = $true
                $src_file_id_N4_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $src_file_id_N4_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("vdg_cboshtif_slp_enable( u2g_OBD_WROBGRP_SLPID );")) {
                $is_target_section = $true
                $src_file_id_N5_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $src_file_id_N5_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_SLPNG, (u4)0U );")) {
                $is_target_section = $true
                $src_file_id_N6_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $src_file_id_N6_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($num -eq 200) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $write_data_file15_N7| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                $is_target_section = $false
                }
            else {
                if ($is_target_section -eq $false) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append
                }
            }
                $num =$num +1                   
        }    
        Remove-Item $file15_PATH
        Move-Item ($file15_PATH + ".new") $file15_PATH

        }
        file1_set_D
        file2_set_D
        file3_set_D
        file4_set_D
        file5_set_D
        file6_set_D
        file7_set_D
        file8_set_D
        file9_set_D
        file10_set_D
        file11_set_D
        file12_set_D
        file13_set_D
        file14_set_D
        file15_set_D
        Write-Host "ソフトD改造成功"
        Write-Host "ソースを保存中--------"
        Copy-Item "..\..\main_micro\sources\" "kaizoD" -Recurse -Force
        Write-Host "改造ソフトDのビルド開始いたします。"
        Start-Process -Filepath "test_build.bat" -Wait -NoNewWindow 
        Write-Host "改造ソフトDのビルド結果物(Romフォルダ)を保存しています。"
        Copy-Item $Target_PATH "kaizoD" -Recurse -Force
        #ファイルを復元
        Remove-Item "..\..\main_micro\sources" -Recurse
        Copy-Item  "kaizoA\" "..\..\main_micro\sources" -Recurse -Force
        Write-Host "===================================================================="
        Write-Host "| 改造ソフトD作業を終わりました。|"
        Write-Host "====================================================================" 
    }
    function kaizo_E {
        Write-Host "===================================================================="
        Write-Host "| 改造ソフトE作業を開始します。|"
        Write-Host "===================================================================="     
        # sourcesフォルダのパス
        $SOURCES_file1_E ="\src\sac\asvs\aamd_l_mat.c"
        $SOURCES_file2_E ="\src\sac\aauxddc\aauxtmp_l_mat.c"
        $SOURCES_file3_E ="\src\sac\abstddc\abstddcov_l_mat.c"
        $SOURCES_file4_E ="\src\sac\abstddc\absttmp_l_mat.c"
        $SOURCES_file5_E ="\src\sac\adrvbat\adrvbat_l_mat.c"
        $SOURCES_file6_E ="\src\sac\avbs\alvmid_l_mat.c"
        $SOURCES_file7_E ="\src\aplmng\apllmng_c_mat.c"
        $SOURCES_file8_E ="\src\sac\asolddc\asoltmp_l_mat.c"
        $SOURCES_file9_E ="\inc\common.h"
        $SOURCES_file10_E ="\src\id\giprogramid_c.h"
        $SOURCES_file11_E ="\src\spf_p\ss\spp_sdbg\spp_sdbginfo_c.h"
        function file1_set_E {
            $file1_PATH =$SOURCES_PATH + $SOURCES_file1_E
            [string[]]$write_data_file1_before = @()
            $write_data_file1_before += ,$set_title_start
            [string[]]$write_data_file1_after = @()
            $write_data_file1_after += ,$set_title_end
            $src_file_id_N1_before = $write_data_file1_before
            $src_file_id_N1_before += ,"#if 0"
            $src_file_id_N1_after = 
"#endif
/* デバックモード切替処理(1_2_3以外：通常制御_1：RAMWrite有効モード(温度センサ)_2：RAMWrite有効モード(AMD)_3：RAMWrite有効モード(DCHB))) */
    if(u1g_dbg_mode == (u1)2)
    {
        /* 更新処理なし */
    }
    else
    {                    
        s2g_aamd_vamd       = s2t_vamd;
    }
"
            $src_file_id_N1_after += ,$set_title_end
            #一時ファイルの作成
            if (Test-Path($file1_PATH + ".new")) {
                Remove-Item ($file1_PATH + ".new")
            }
            $src_file = Get-Content $file1_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("s2g_aamd_vamd       = s2t_vamd;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $src_file_id_N1_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append  
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append 
                    $src_file_id_N1_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file1_PATH
        Move-Item ($file1_PATH + ".new") $file1_PATH
        }
        function file2_set_E {
            $file2_PATH =$SOURCES_PATH + $SOURCES_file2_E
            [string[]]$write_data_file2_before = @()
            $write_data_file2_before += ,$set_title_start
            [string[]]$write_data_file2_after = @()
            $write_data_file2_after += ,$set_title_end
            $src_file_id_N2_before = $write_data_file2_before
            $src_file_id_N2_before += ,"#if 0"
            $src_file_id_N2_after = 
"#endif
/* デバックモード切替処理(1_2_3以外：通常制御_1：RAMWrite有効モード(温度センサ)_2：RAMWrite有効モード(AMD)_3：RAMWrite有効モード(DCHB))) */
    if(u1g_dbg_mode == (u1)1)        /* 1：RAMWrite有効モード */
    {
        /* 更新処理なし */
    }
    else                                     /* 0：通常処理 */
    {
        s2g_aauxtmp_tddc1    = s2t_tddc1;
        s2g_aauxtmp_tddc2    = s2t_tddc2;
        s2g_aauxtmp_tddc3    = s2t_tddc3;
    }
"
            $src_file_id_N2_after += ,$set_title_end
            #一時ファイルの作成
            if (Test-Path($file2_PATH + ".new")) {
                Remove-Item ($file2_PATH + ".new")
            }
            $src_file = Get-Content $file2_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("u2g_aauxtmp_tddc3_ad = u2t_tddc3_ad;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                    $src_file_id_N2_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
            elseif ($line.Contains("s2g_aauxtmp_tddc3    = s2t_tddc3;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン 
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                    $src_file_id_N2_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                    $is_target_section = $false
            }
            else {
                if ($is_target_section -eq $false) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                }
                }
                $num =$num +1                   
        }     
        Remove-Item $file2_PATH
        Move-Item ($file2_PATH + ".new") $file2_PATH
        }
        function file3_set_E {
            $file3_PATH =$SOURCES_PATH + $SOURCES_file3_E
            [string[]]$write_data_file3_before = @()
            $write_data_file3_before += ,$set_title_start
            [string[]]$write_data_file3_after = @()
            $write_data_file3_after += ,$set_title_end

            $src_file_id_N1_before = $write_data_file3_before
            $src_file_id_N1_before += ,"#if 0"
            $src_file_id_N1_after = 
"#endif
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {                    
                /* 端子の過電圧信号状態を`“無効`”に設定 */
                stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_DISABLE;
}
"
            $src_file_id_N1_after += ,$set_title_end

            $src_file_id_N2_before = $write_data_file3_before
            $src_file_id_N2_before += ,"#if 0"
            $src_file_id_N2_after = 
"#endif
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {                    
                /* 端子の過電圧信号状態を`“有効かつ正常`”に設定 */
                stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_OFF;
            }
"
            $src_file_id_N2_after += ,$set_title_end

            $src_file_id_N3_before = $write_data_file3_before
            $src_file_id_N3_before += ,"#if 0"
            $src_file_id_N3_after = 
"#endif
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {                    
                /* 端子の過電圧信号状態を`“有効かつ正常`”に設定 */
                stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_OFF;
            }
"
            $src_file_id_N3_after += ,$set_title_end

            $src_file_id_N4_before = $write_data_file3_before
            $src_file_id_N4_before += ,"#if 0"
            $src_file_id_N4_after = 
"#endif
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {                    
                /* 端子の過電圧信号状態を`“有効かつ過電圧`”に設定 */
                stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_ON;
            }
"
            $src_file_id_N4_after += ,$set_title_end

            $src_file_id_N5_before = $write_data_file3_before
            $src_file_id_N5_before += ,"#if 0"
            $src_file_id_N5_after = 
"#endif
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {                    
                /* 端子の過電圧信号状態を`“無効`”に設定 */
                stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_DISABLE;
            }
"
            $src_file_id_N5_after += ,$set_title_end

            $src_file_id_N6_before = $write_data_file3_before
            $src_file_id_N6_before += ,"#if 0"
            $src_file_id_N6_after = 
"#endif
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {                    
                /* OV_DC4端子の過電圧信号状態を`“無効`”に設定 */
                stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_DISABLE;
            }       
"
            $src_file_id_N6_after += ,$set_title_end

            $src_file_id_N7_before = $write_data_file3_before
            $src_file_id_N7_before += ,"#if 0"
            $src_file_id_N7_after = 
"#endif
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {                    
                /* OV_DC4端子の過電圧信号状態を`“有効かつ過電圧`”に設定 */
                stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_ON;
            }
"
            $src_file_id_N7_after += ,$set_title_end
            #一時ファイルの作成
            if (Test-Path($file3_PATH + ".new")) {
                Remove-Item ($file3_PATH + ".new")
            }
            $src_file = Get-Content $file3_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($num -eq 184) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $src_file_id_N1_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append      
                    $is_target_section = $false
                    }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_DISABLE;") -and $num -eq 185) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン 
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                    $src_file_id_N1_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                    $is_target_section = $false
            }
            elseif ($num -eq 192) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $src_file_id_N2_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_OFF;") -and $num -eq 193) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $src_file_id_N2_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                $is_target_section = $false
        }
            elseif ($num -eq 224) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $src_file_id_N3_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_OFF;") -and $num -eq 225) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $src_file_id_N3_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                $is_target_section = $false
        }
            elseif ($num -eq 232) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $src_file_id_N4_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_ON ;") -and $num -eq 233) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $src_file_id_N4_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                $is_target_section = $false
        }
            elseif ($num -eq 247) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $src_file_id_N5_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_DISABLE;") -and $num -eq 248) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $src_file_id_N5_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                $is_target_section = $false
        }
            elseif ($num -eq 292) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $src_file_id_N6_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_DISABLE;") -and $num -eq 293) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $src_file_id_N6_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                $is_target_section = $false
        }
            elseif ($num -eq 297) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $src_file_id_N7_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_ON;") -and $num -eq 298) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $src_file_id_N7_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                $is_target_section = $false
        }
            else {
                if ($is_target_section -eq $false) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                }
                }
                $num =$num +1                   
        }     
        Remove-Item $file3_PATH
        Move-Item ($file3_PATH + ".new") $file3_PATH
        }
        function file4_set_E {
            $file4_PATH =$SOURCES_PATH + $SOURCES_file4_E
            [string[]]$write_data_file4_before = @()
            $write_data_file4_before += ,$set_title_start
            [string[]]$write_data_file4_after = @()
            $write_data_file4_after += ,$set_title_end
            $src_file_id_N1_before = $write_data_file4_before
            $src_file_id_N1_before += ,"#if 0"
            $src_file_id_N1_after = 
"#endif
/* デバックモード切替処理(1_2_3以外：通常制御_1：RAMWrite有効モード(温度センサ)_2：RAMWrite有効モード(AMD)_3：RAMWrite有効モード(DCHB)))*/
    if(u1g_dbg_mode == (u1)1)
    {
        /* 更新処理なし */
    }
    else
    {
        s2g_absttmp_tddc    = s2t_tddc;
    }
"
            $src_file_id_N1_after += ,$set_title_end
            #一時ファイルの作成
            if (Test-Path($file4_PATH + ".new")) {
                Remove-Item ($file4_PATH + ".new")
            }
            $src_file = Get-Content $file4_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("s2g_absttmp_tddc    = s2t_tddc;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $src_file_id_N1_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append  
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                    $src_file_id_N1_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file4_PATH
        Move-Item ($file4_PATH + ".new") $file4_PATH
        }
        function file5_set_E {
            $file5_PATH =$SOURCES_PATH + $SOURCES_file5_E
            [string[]]$write_data_file5_before = @()
            $write_data_file5_before += ,$set_title_start
            [string[]]$write_data_file5_after = @()
            $write_data_file5_after += ,$set_title_end
            $src_file_id_N1_before = $write_data_file5_before
            $src_file_id_N1_before += ,"#if 0"
            $src_file_id_N1_after = 
"#endif
/* デバックモード切替処理(1_2_3以外：通常制御_1：RAMWrite有効モード(温度センサ)_2：RAMWrite有効モード(AMD)_3：RAMWrite有効モード(DCHB))) */
    if(u1g_dbg_mode == (u1)3)
    {
        /* 更新処理なし */
    }
    else
    {
        s2g_adrvbat_vdchb     = s2t_vdchb;
    }
"
            $src_file_id_N1_after += ,$set_title_end
            #一時ファイルの作成
            if (Test-Path($file5_PATH + ".new")) {
                Remove-Item ($file5_PATH + ".new")
            }
            $src_file = Get-Content $file5_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("s2g_adrvbat_vdchb     = s2t_vdchb;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $src_file_id_N1_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file5_PATH + ".new") -Append  
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file5_PATH + ".new") -Append 
                    $src_file_id_N1_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file5_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file5_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     

        Remove-Item $file5_PATH
        Move-Item ($file5_PATH + ".new") $file5_PATH
        }
        function file6_set_E {
            $file6_PATH =$SOURCES_PATH + $SOURCES_file6_E
            [string[]]$write_data_file6_before = @()
            $write_data_file6_before += ,$set_title_start
            [string[]]$write_data_file6_after = @()
            $write_data_file6_after += ,$set_title_end

            $src_file_id_N1_before = $write_data_file6_before
            $src_file_id_N1_before += ,"#if 0"
            $src_file_id_N1_after = 
"#endif
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                /* 端子の中間電圧上限値検出信号状態を`“無効`”に設定 */
                stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_DISABLE;
            }
"
            $src_file_id_N1_after += ,$set_title_end

            $src_file_id_N2_before = $write_data_file6_before
            $src_file_id_N2_before += ,"#if 0"
            $src_file_id_N2_after = 
"#endif
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                /* 端子の中間電圧上限値検出信号状態を`“有効かつ正常`”に設定 */
                stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_OFF;
            }
"
            $src_file_id_N2_after += ,$set_title_end

            $src_file_id_N3_before = $write_data_file6_before
            $src_file_id_N3_before += ,"#if 0"
            $src_file_id_N3_after = 
"#endif
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                /* 端子の中間電圧上限値検出信号状態を`“有効かつ正常`”に設定 */
                stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_OFF;
            }
"
            $src_file_id_N3_after += ,$set_title_end

            $src_file_id_N4_before = $write_data_file6_before
            $src_file_id_N4_before += ,"#if 0"
            $src_file_id_N4_after = 
"#endif
    if(u1g_dbg_mode == (u1)1)
    {
        /* 更新処理なし */
    }
    else
    {
        /* 端子の中間電圧上限値検出信号状態を`“有効かつ過電圧`”に設定 */
        stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_ON ;
    }
"
            $src_file_id_N4_after += ,$set_title_end

            $src_file_id_N5_before = $write_data_file6_before
            $src_file_id_N5_before += ,"#if 0"
            $src_file_id_N5_after = 
"#endif
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                /* 端子の中間電圧上限値検出信号状態を`“無効`”に設定 */
                stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_DISABLE;
            }
"
            $src_file_id_N5_after += ,$set_title_end 
            
            $src_file_id_N6_before = $write_data_file6_before
            $src_file_id_N6_before += ,"#if 0"
            $src_file_id_N6_after = 
"endif
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                /* LV_MID端子の中間電圧上限値検出信号状態を`“無効`”に設定 */
                stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_DISABLE;
            }
"
            $src_file_id_N6_after += ,$set_title_end    

            $src_file_id_N7_before = $write_data_file6_before
            $src_file_id_N7_before += ,"#if 0"
            $src_file_id_N7_after = 
"#endif
            if(u1g_dbg_mode == (u1)1)
            {
                /* 更新処理なし */
            }
            else
            {
                /* LV_MID端子の中間電圧上限値検出信号状態を`“有効かつ過電圧`”に設定 */
                stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_ON;
            }
"
            $src_file_id_N7_after += ,$set_title_end  




            #一時ファイルの作成
            if (Test-Path($file6_PATH + ".new")) {
                Remove-Item ($file6_PATH + ".new")
            }
            $src_file = Get-Content $file6_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($num -eq 179) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $src_file_id_N1_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append      
                    $is_target_section = $false
                    }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_DISABLE;") -and $num -eq 180) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン 
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                    $src_file_id_N1_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append   
                    $is_target_section = $false
            }
            elseif ($num -eq 187) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $src_file_id_N2_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_OFF;") -and $num -eq 188) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $src_file_id_N2_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($num -eq 220) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $src_file_id_N3_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_OFF;") -and $num -eq 221) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $src_file_id_N3_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($num -eq 228) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $src_file_id_N4_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_ON ;") -and $num -eq 229) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $src_file_id_N4_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($num -eq 243) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $src_file_id_N5_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_DISABLE;") -and $num -eq 244) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $src_file_id_N5_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($num -eq 280) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $src_file_id_N6_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_DISABLE;") -and $num -eq 281) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $src_file_id_N6_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($num -eq 285) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $src_file_id_N7_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_ON;") -and $num -eq 286) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $src_file_id_N7_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append   
                $is_target_section = $false
            }
            else {
                if ($is_target_section -eq $false) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append
                }
                }
                $num =$num +1                   
        }     
        Remove-Item $file6_PATH
        Move-Item ($file6_PATH + ".new") $file6_PATH
        }
        function file7_set_E {
            $file7_PATH =$SOURCES_PATH + $SOURCES_file7_E
            [string[]]$write_data_file7_before = @()
            $write_data_file7_before += ,$set_title_start
            [string[]]$write_data_file7_after = @()
            $write_data_file7_after += ,$set_title_end
            $src_file_id_N1 =
"u1 u1g_dbg_mode;            /* デバックモード切替用フラグ(1_2_3以外：通常制御_1：RAMWrite有効モード(温度センサ)_2：RAMWrite有効モード(AMD)_3：RAMWrite有効モード(DCHB))) */"

            $write_data_file7_N1 = $write_data_file7_before + $src_file_id_N1 +  $write_data_file7_after
            #一時ファイルの作成
            if (Test-Path($file7_PATH + ".new")) {
                Remove-Item ($file7_PATH + ".new")
            }
            $src_file = Get-Content $file7_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("u1 u1g_apllmng_cnt_4sl;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append 
                    $write_data_file7_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file7_PATH
        Move-Item ($file7_PATH + ".new") $file7_PATH
        }
        function file8_set_E {
            $file8_PATH =$SOURCES_PATH + $SOURCES_file8_E
            [string[]]$write_data_file8_before = @()
            $write_data_file8_before += ,$set_title_start
            [string[]]$write_data_file8_after = @()
            $write_data_file8_after += ,$set_title_end

            $src_file_id_N1_before = $write_data_file8_before
            $src_file_id_N1_before += ,"#if 0"
            $src_file_id_N1_after = 
"#endif
/* デバックモード切替処理(1_2_3以外：通常制御_1：RAMWrite有効モード(温度センサ)_2：RAMWrite有効モード(AMD)_3：RAMWrite有効モード(DCHB))) */
    if(u1g_dbg_mode == (u1)1)
    {
        /* 更新処理なし */
    }
    else
    {
        s2g_asoltmp_tddc1    = s2t_tddc1;
    }
"
            $src_file_id_N1_after += ,$set_title_end

            $src_file_id_N2_before = $write_data_file8_before
            $src_file_id_N2_before += ,"#if 0"
            $src_file_id_N2_after = 
"#endif
/* デバックモード切替処理(1_2_3以外：通常制御_1：RAMWrite有効モード(温度センサ)_2：RAMWrite有効モード(AMD)_3：RAMWrite有効モード(DCHB))) */
    if(u1g_dbg_mode == (u1)1)
    {
        /* 更新処理なし */
    }
    else
    {
        s2g_asoltmp_tddc2    = s2t_tddc2;
    }
"
            $src_file_id_N2_after += ,$set_title_end
            #一時ファイルの作成
            if (Test-Path($file8_PATH + ".new")) {
                Remove-Item ($file8_PATH + ".new")
            }
            $src_file = Get-Content $file8_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
                if ($line.Contains("s2g_asoltmp_tddc1    = s2t_tddc1;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $src_file_id_N1_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append  
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append 
                    $src_file_id_N1_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
                elseif ($line.Contains("s2g_asoltmp_tddc2    = s2t_tddc2;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $src_file_id_N2_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append  
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append 
                    $src_file_id_N2_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append   
                    $is_target_section = $false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file8_PATH
        Move-Item ($file8_PATH + ".new") $file8_PATH
        }
        function file9_set_E {
            $file9_PATH =$SOURCES_PATH + $SOURCES_file9_E
            [string[]]$write_data_file9_before = @()
            $write_data_file9_before += ,$set_title_start
            [string[]]$write_data_file9_after = @()
            $write_data_file9_after += ,$set_title_end
            $src_file_id_N1 =
"extern u1 u1g_dbg_mode;              /* デバックモード切替用フラグ(1_2_3以外：通常制御_1：RAMWrite有効モード(温度センサ)_2：RAMWrite有効モード(AMD)_3：RAMWrite有効モード(DCHB))) */"

            $write_data_file9_N1 = $write_data_file9_before + $src_file_id_N1 +  $write_data_file9_after
            #一時ファイルの作成
            if (Test-Path($file9_PATH + ".new")) {
                Remove-Item ($file9_PATH + ".new")
            }
            $src_file = Get-Content $file9_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#endif  /* COMMON_H */")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $write_data_file9_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file9_PATH + ".new") -Append  
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file9_PATH + ".new") -Append 
                    $is_target_section = $false
                    }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file9_PATH + ".new") -Append
                    }
                }
                $num =$num +1                   
        }     
        Remove-Item $file9_PATH
        Move-Item ($file9_PATH + ".new") $file9_PATH
        }
        function file10_set_E {
            $file10_PATH =$SOURCES_PATH + $SOURCES_file10_E 
            [string[]]$write_data_file10_before = @()
            $write_data_file10_before += ,$set_title_start
            $write_data_file10_before += "   #if 0"
            [string[]]$write_data_file10_after = @()
            $write_data_file10_after += "    #endif"
            $write_data_file10_after +=" 	    #define  PROGRAMID  `"894BF-K00A0-4   `""
            $write_data_file10_after += ,$set_title_end
            if ($VARI -eq 1000) {
                $src_file_id= (Get-Content $file10_PATH -TotalCount 49)[-1]
            }else {
                $src_file_id= (Get-Content $file10_PATH -TotalCount 53)[-1]
            }
            $src_file_id = "    " + $src_file_id 
            #書込み内容
            $write_data_file10 = $write_data_file10_before + $src_file_id + $write_data_file10_after 
            
            #一時ファイルの作成
            if (Test-Path($file10_PATH + ".new")) {
                Remove-Item ($file10_PATH + ".new")
            }
            $src_file = Get-Content $file10_PATH
            [bool]$is_target_section = $false # 処理対象区間か
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
                if ($line.Contains("#if ( JGVARI == 1000 )")) {
                        $is_target_section = $true
                        #% {} は foreach（Foreach-Object）を意味します
                        # |符号の意味：パイプライン
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
            
                        $write_data_file10 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                    }
                    elseif ($line.Contains("#elif ( JGVARI == 1100 )")) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                        $is_target_section = $false
                    }
                    else {
                        if ($is_target_section -eq $false) {
                            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                        }
                    }
            }
        }else{
            foreach ($line in $src_file) {
                # 処理対象の開始行より前はそのまま出力
                # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#elif ( JGVARI == 1100 )")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
        
                    $write_data_file10 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                }
                elseif ($line.Contains("#else")) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                    $is_target_section = $false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file10_PATH + ".new") -Append
                    }
                }
        }
        }
        Remove-Item $file10_PATH
        Move-Item ($file10_PATH + ".new") $file10_PATH
}
        function file11_set_E {
            $file11_PATH =$SOURCES_PATH + $SOURCES_file11_E 
            [string[]]$write_data_file11_before = @()
            $write_data_file11_before += ,$set_title_start
            $write_data_file11_before += "   #if 0"
            [string[]]$write_data_file11_after = @()
            $write_data_file11_after += "    #endif"
            $write_data_file11_after += "        #define u4s_SPP_SDBGINFO_VER     ((u4)0xFF040A00U))"
            $write_data_file11_after += ,$set_title_end
            if ($VARI -eq 1000) {
                $src_file_id= (Get-Content $file11_PATH -TotalCount 118)[-1]
            }else {
                $src_file_id= (Get-Content $file11_PATH -TotalCount 122)[-1]
            }
            $src_file_id = "    " + $src_file_id 
            #書込み内容
            $write_data_file11 = $write_data_file11_before + $src_file_id + $write_data_file11_after 
            
            #一時ファイルの作成
            if (Test-Path($file11_PATH + ".new")) {
                Remove-Item ($file11_PATH + ".new")
            }
            $src_file = Get-Content $file11_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
                if ($line.Contains("#if ( JGVARI == 1000 )") -and $num -eq 116) {
                        $is_target_section = $true
                        #% {} は foreach（Foreach-Object）を意味します
                        # |符号の意味：パイプライン
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
            
                        $write_data_file11 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
                    }
                    elseif ($line.Contains("#elif ( JGVARI == 1100 )") ) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
                        $is_target_section = $false
                    }
                    else {
                        if ($is_target_section -eq $false) {
                            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
                        }
                    }
                    $num =$num +1
                    
            }
        }else{
            foreach ($line in $src_file) {
                # 処理対象の開始行より前はそのまま出力
                # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#elif ( JGVARI == 1100 )") -and $num -eq 120 ) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append

                    $write_data_file11 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
                }
                elseif ($line.Contains("#else")) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
                    $is_target_section = $false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file11_PATH + ".new") -Append
                    }
                }
                $num =$num +1
        }
        }
        Remove-Item $file11_PATH
        Move-Item ($file11_PATH + ".new") $file11_PATH  
        }
        file1_set_E
        file2_set_E
        file3_set_E
        file4_set_E
        file5_set_E
        file6_set_E
        file7_set_E
        file8_set_E
        file9_set_E
        file10_set_E
        file11_set_E
        Write-Host "ソフトE改造成功"
        Write-Host "ソースを保存中--------"
        Copy-Item "..\..\main_micro\sources\" "kaizoE" -Recurse -Force
        Write-Host "改造ソフトEのビルド開始いたします。"
        Start-Process -Filepath "test_build.bat" -Wait -NoNewWindow 
        Write-Host "改造ソフトEのビルド結果物(Romフォルダ)を保存しています。"
        Copy-Item $Target_PATH "kaizoE" -Recurse -Force
        #ファイルを復元
        Remove-Item "..\..\main_micro\sources" -Recurse
        Copy-Item  "kaizoA\" "..\..\main_micro\sources" -Recurse -Force
        Write-Host "===================================================================="
        Write-Host "| 改造ソフトE作業を終わりました。|"
        Write-Host "===================================================================="   
    }

    function kaizo_F {
        Write-Host "===================================================================="
        Write-Host "| 改造ソフトF作業を開始します。|"
        Write-Host "===================================================================="     
        # sourcesフォルダのパス
        $SOURCES_file1_F ="\src\id\giprogramid_c.h"
        $SOURCES_file2_F ="\src\hsol\hsolmng\hsolmng_c_mat.c"
        $SOURCES_file3_F ="\src\spf_p\ss\spp_sdbg\spp_sdbginfo_c.h"
        $SOURCES_file4_F ="\src\obd\wmng\wlmng_l_mat.c"
        function file1_set_F {
            $file1_PATH =$SOURCES_PATH + $SOURCES_file1_F 
            [string[]]$write_data_file1_before = @()
            $write_data_file1_before += ,$set_title_start
            $write_data_file1_before += "   #if 0"
            [string[]]$write_data_file1_after = @()
            $write_data_file1_after += "    #endif"
            $write_data_file1_after +=" 	    #define  PROGRAMID  `"894BF-K00A0-5   `""
            $write_data_file1_after += ,$set_title_end
            if ($VARI -eq 1000) {
                $src_file_id= (Get-Content $file1_PATH -TotalCount 49)[-1]
            }else {
                $src_file_id= (Get-Content $file1_PATH -TotalCount 53)[-1]
            }
            $src_file_id = "    " + $src_file_id 
            #書込み内容
            $write_data_file1 = $write_data_file1_before + $src_file_id + $write_data_file1_after 
            
            #一時ファイルの作成
            if (Test-Path($file1_PATH + ".new")) {
                Remove-Item ($file1_PATH + ".new")
            }
            $src_file = Get-Content $file1_PATH
            [bool]$is_target_section = $false # 処理対象区間か
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
                if ($line.Contains("#if ( JGVARI == 1000 )")) {
                        $is_target_section = $true
                        #% {} は foreach（Foreach-Object）を意味します
                        # |符号の意味：パイプライン
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
            
                        $write_data_file1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    }
                    elseif ($line.Contains("#elif ( JGVARI == 1100 )")) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                        $is_target_section = $false
                    }
                    else {
                        if ($is_target_section -eq $false) {
                            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                        }
                    }
            }
        }else{
            foreach ($line in $src_file) {
                # 処理対象の開始行より前はそのまま出力
                # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#elif ( JGVARI == 1100 )")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
        
                    $write_data_file1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                }
                elseif ($line.Contains("#else")) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    $is_target_section = $false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file1_PATH + ".new") -Append
                    }
                }
        }
        }
        Remove-Item $file1_PATH
        Move-Item ($file1_PATH + ".new") $file1_PATH
}
        function file2_set_F {
            $file2_PATH =$SOURCES_PATH + $SOURCES_file2_F
            [string[]]$write_data_file2_before = @()
            $write_data_file2_before += ,$set_title_start
            [string[]]$write_data_file2_after = @()
            $write_data_file2_after += ,$set_title_end
            
            $src_file_id_N1 =
"volatile u4 u4g_dbg_cnt_hsolmng_pwon;          /* 関数(vdg_hsolmng_pwon)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_hsolmng_pwonwup;       /* 関数(vdg_hsolmng_pwonwup)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_hsolmng_func_reigon;   /* 関数(vdg_hsolmng_func_reigon)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_hsolmng_func_4msm;     /* 関数(vdg_hsolmng_func_4msm)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_hsolmng_func_8msl;     /* 関数(vdg_hsolmng_func_8msl)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_hsolmng_func_adend;    /* 関数(vdg_hsolmng_func_adend)コール確認用カウンタ */"
            $write_data_file2_N1 = $write_data_file2_before + $src_file_id_N1 + $write_data_file2_after

            $src_file_id_N2 =
"   if(u4g_dbg_cnt_hsolmng_pwon < u4g_U4MAX)
    {
        u4g_dbg_cnt_hsolmng_pwon++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_hsolmng_pwon = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file2_N2 = $write_data_file2_before + $src_file_id_N2 + $write_data_file2_after


            $src_file_id_N3 =
"   if(u4g_dbg_cnt_hsolmng_pwonwup < u4g_U4MAX)
    {
        u4g_dbg_cnt_hsolmng_pwonwup++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_hsolmng_pwonwup = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file2_N3 = $write_data_file2_before + $src_file_id_N3 + $write_data_file2_after

            $src_file_id_N4 =
"   if(u4g_dbg_cnt_hsolmng_func_reigon < u4g_U4MAX)
    {
        u4g_dbg_cnt_hsolmng_func_reigon++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_hsolmng_func_reigon = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file2_N4 = $write_data_file2_before + $src_file_id_N4 + $write_data_file2_after

            $src_file_id_N5 =
"   if(u4g_dbg_cnt_hsolmng_func_4msm < u4g_U4MAX)
    {
        u4g_dbg_cnt_hsolmng_func_4msm++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_hsolmng_func_4msm = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file2_N5 = $write_data_file2_before + $src_file_id_N5 + $write_data_file2_after

            $src_file_id_N6 =
"   if(u4g_dbg_cnt_hsolmng_func_8msl < u4g_U4MAX)
    {
        u4g_dbg_cnt_hsolmng_func_8msl++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_hsolmng_func_8msl = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file2_N6 = $write_data_file2_before + $src_file_id_N6 + $write_data_file2_after

            $src_file_id_N7 =
"   if(u4g_dbg_cnt_hsolmng_func_adend < u4g_U4MAX)
    {
        u4g_dbg_cnt_hsolmng_func_adend++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_hsolmng_func_adend = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file2_N7 = $write_data_file2_before + $src_file_id_N7 + $write_data_file2_after

            #一時ファイルの作成
            if (Test-Path($file2_PATH + ".new")) {
                Remove-Item ($file2_PATH + ".new")
            }
            $src_file = Get-Content $file2_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  

            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("u1 u1g_hsolmng_xreigonrq;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                    $write_data_file2_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
            elseif ($num -eq 129) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                    $write_data_file2_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                    $is_target_section = $false
            }
            elseif ($line.Contains("/*▲▲▲ 必要に応じて関数を追加 ▲▲▲*/") -and $num -eq 191) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                $write_data_file2_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($line.Contains("u1g_hsolmng_xreigonrq = ((u1)ON); /* 再IGオン要求あり */")) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                $write_data_file2_N4 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($line.Contains("/*▲▲▲ 必要に応じて関数を追加 ▲▲▲*/") -and $num -eq 230) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                $write_data_file2_N5 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($line.Contains("vds_hsolmng_reigonrq_init();")) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                $write_data_file2_N6 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($num -eq 303) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                $write_data_file2_N7 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                $is_target_section = $false
            }
            
            else {
                if ($is_target_section -eq $false) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                }
                }
                $num =$num +1                   
    }
        Remove-Item $file2_PATH
        Move-Item ($file2_PATH + ".new") $file2_PATH
}
        function file3_set_F {
            $file3_PATH =$SOURCES_PATH + $SOURCES_file3_F 
            [string[]]$write_data_file3_before = @()
            $write_data_file3_before += ,$set_title_start
            $write_data_file3_before += "   #if 0"
            [string[]]$write_data_file3_after = @()
            $write_data_file3_after += "    #endif"
            $write_data_file3_after += "        #define u4s_SPP_SDBGINFO_VER ((u4)0xFF51030AU) /* バージョン */"
            $write_data_file3_after += ,$set_title_end
            if ($VARI -eq 1000) {
                $src_file_id= (Get-Content $file3_PATH -TotalCount 118)[-1]
            }else {
                $src_file_id= (Get-Content $file3_PATH -TotalCount 122)[-1]
            }
            $src_file_id = "    " + $src_file_id 
            #書込み内容
            $write_data_file3 = $write_data_file3_before + $src_file_id + $write_data_file3_after 
            
            #一時ファイルの作成
            if (Test-Path($file3_PATH + ".new")) {
                Remove-Item ($file3_PATH + ".new")
            }
            $src_file = Get-Content $file3_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
                if ($line.Contains("#if ( JGVARI == 1000 )") -and $num -eq 116) {
                        $is_target_section = $true
                        #% {} は foreach（Foreach-Object）を意味します
                        # |符号の意味：パイプライン
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
            
                        $write_data_file3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    }
                    elseif ($line.Contains("#elif ( JGVARI == 1100 )") ) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                        $is_target_section = $false
                    }
                    else {
                        if ($is_target_section -eq $false) {
                            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                        }
                    }
                    $num =$num +1
                    
            }
        }else{
            foreach ($line in $src_file) {
                # 処理対象の開始行より前はそのまま出力
                # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                # 処理対象の終了行からはそのまま出力
            if ($line.Contains("#elif ( JGVARI == 1100 )") -and $num -eq 120 ) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append

                    $write_data_file3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                }
                elseif ($line.Contains("#else")) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    $is_target_section = $false
                }
                else {
                    if ($is_target_section -eq $false) {
                        $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                    }
                }
                $num =$num +1
        }
        }
        Remove-Item $file3_PATH
        Move-Item ($file3_PATH + ".new") $file3_PATH  
}
        function file4_set_F {
            $file4_PATH =$SOURCES_PATH + $SOURCES_file4_F
            [string[]]$write_data_file4_before = @()
            $write_data_file4_before += ,$set_title_start
            [string[]]$write_data_file4_after = @()
            $write_data_file4_after += ,$set_title_end

            $src_file_id_N1 =
"volatile u4 u4g_dbg_cnt_wlmng_init;            /* 関数(u4g_dbg_cnt_wlmng_init)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_diag_pwon;       /* 関数(u4g_dbg_cnt_wlmng_diag_pwon)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_idle;            /* 関数(u4g_dbg_cnt_wlmng_idle)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_1msh;            /* 関数(u4g_dbg_cnt_wlmng_1msh)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_2msh;            /* 関数(u4g_dbg_cnt_wlmng_2msh)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_8msh;            /* 関数(u4g_dbg_cnt_wlmng_8msh)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_16msmh;          /* 関数(u4g_dbg_cnt_wlmng_16msmh)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_32msmh;          /* 関数(u4g_dbg_cnt_wlmng_32msmh)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_4msm;            /* 関数(u4g_dbg_cnt_wlmng_4msm)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_8msm;            /* 関数(u4g_dbg_cnt_wlmng_8msm)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_16msm;           /* 関数(u4g_dbg_cnt_wlmng_16msm)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_32msm;           /* 関数(u4g_dbg_cnt_wlmng_32msm)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_8msl;            /* 関数(u4g_dbg_cnt_wlmng_8msl)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_16msl;           /* 関数(u4g_dbg_cnt_wlmng_16msl)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_32msl;           /* 関数(u4g_dbg_cnt_wlmng_32msl)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_65msl;           /* 関数(u4g_dbg_cnt_wlmng_65msl)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_131msl;          /* 関数(u4g_dbg_cnt_wlmng_131msl)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_1sl;             /* 関数(u4g_dbg_cnt_wlmng_1sl)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_mg2ms;           /* 関数(u4g_dbg_cnt_wlmng_mg2ms)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_mg5ms;           /* 関数(u4g_dbg_cnt_wlmng_mg5ms)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_mg10ms;          /* 関数(u4g_dbg_cnt_wlmng_mg10ms)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_ad2ms;           /* 関数(u4g_dbg_cnt_wlmng_ad2ms)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_ad4ms;           /* 関数(u4g_dbg_cnt_wlmng_ad4ms)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_ad8ms;           /* 関数(u4g_dbg_cnt_wlmng_ad8ms)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_ne10;            /* 関数(u4g_dbg_cnt_wlmng_ne10)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_ne30m;           /* 関数(u4g_dbg_cnt_wlmng_ne30m)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_ne10h;           /* 関数(u4g_dbg_cnt_wlmng_ne10h)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_ne10m;           /* 関数(u4g_dbg_cnt_wlmng_ne10m)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_drvclchg;        /* 関数(u4g_dbg_cnt_wlmng_drvclchg)コール確認用カウンタ */
volatile u4 u4g_dbg_cnt_wlmng_drvclchgwch;     /* 関数(u4g_dbg_cnt_wlmng_drvclchgwch)コール確認用カウンタ */"
            $write_data_file4_N1 = $write_data_file4_before + $src_file_id_N1 + $write_data_file4_after

            $src_file_id_N2 =
"   if(u4g_dbg_cnt_wlmng_init < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_init++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_init = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N2 = $write_data_file4_before + $src_file_id_N2 + $write_data_file4_after

            $src_file_id_N3 =
"   if(u4g_dbg_cnt_wlmng_diag_pwon < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_diag_pwon++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_diag_pwon = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N3 = $write_data_file4_before + $src_file_id_N3 + $write_data_file4_after

            $src_file_id_N4 =
"   if(u4g_dbg_cnt_wlmng_idle < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_idle++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_idle = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N4 = $write_data_file4_before + $src_file_id_N4 + $write_data_file4_after

            $src_file_id_N5 =
"   if(u4g_dbg_cnt_wlmng_1msh < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_1msh++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_1msh = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N5 = $write_data_file4_before + $src_file_id_N5 + $write_data_file4_after

            $src_file_id_N6 =
"   if(u4g_dbg_cnt_wlmng_2msh < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_2msh++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_2msh = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N6 = $write_data_file4_before + $src_file_id_N6 + $write_data_file4_after

            $src_file_id_N7 =
"   if(u4g_dbg_cnt_wlmng_8msh < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_8msh++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_8msh = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N7 = $write_data_file4_before + $src_file_id_N7 + $write_data_file4_after

            $src_file_id_N8 =
"   if(u4g_dbg_cnt_wlmng_16msmh < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_16msmh++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_16msmh = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
             $write_data_file4_N8 = $write_data_file4_before + $src_file_id_N8 + $write_data_file4_after

             $src_file_id_N9 =
"   if(u4g_dbg_cnt_wlmng_32msmh < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_32msmh++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_32msmh = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
             $write_data_file4_N9 = $write_data_file4_before + $src_file_id_N9 + $write_data_file4_after
            
             $src_file_id_N10 =
"   if(u4g_dbg_cnt_wlmng_4msm < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_4msm++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_4msm = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
             $write_data_file4_N10 = $write_data_file4_before + $src_file_id_N10 + $write_data_file4_after

             $src_file_id_N11 =
"   if(u4g_dbg_cnt_wlmng_8msm < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_8msm++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_8msm = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N11 = $write_data_file4_before + $src_file_id_N11 + $write_data_file4_after

            $src_file_id_N12 =
"   if(u4g_dbg_cnt_wlmng_16msm < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_16msm++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_16msm = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N12 = $write_data_file4_before + $src_file_id_N12 + $write_data_file4_after

            $src_file_id_N13 =
"   if(u4g_dbg_cnt_wlmng_32msm < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_32msm++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_32msm = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N13 = $write_data_file4_before + $src_file_id_N13 + $write_data_file4_after

            $src_file_id_N14 =
"   if(u4g_dbg_cnt_wlmng_8msl < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_8msl++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_8msl = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N14 = $write_data_file4_before + $src_file_id_N14 + $write_data_file4_after
            
            $src_file_id_N15 =
"   if(u4g_dbg_cnt_wlmng_16msl < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_16msl++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_16msl = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N15 = $write_data_file4_before + $src_file_id_N15 + $write_data_file4_after

            $src_file_id_N16 =
"   if(u4g_dbg_cnt_wlmng_32msl < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_32msl++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_32msl = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N16 = $write_data_file4_before + $src_file_id_N16 + $write_data_file4_after

            $src_file_id_N17 =
"   if(u4g_dbg_cnt_wlmng_65msl < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_65msl++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_65msl = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N17 = $write_data_file4_before + $src_file_id_N17 + $write_data_file4_after

            $src_file_id_N18 =
"	if(u4g_dbg_cnt_wlmng_131msl < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_131msl++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_131msl = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N18 = $write_data_file4_before + $src_file_id_N18 + $write_data_file4_after

            $src_file_id_N19 =
"   if(u4g_dbg_cnt_wlmng_1sl < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_1sl++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_1sl = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N19 = $write_data_file4_before + $src_file_id_N19 + $write_data_file4_after

            $src_file_id_N20 =
"   if(u4g_dbg_cnt_wlmng_mg2ms < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_mg2ms++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_mg2ms = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
            $write_data_file4_N20 = $write_data_file4_before + $src_file_id_N20 + $write_data_file4_after

        $src_file_id_N21 =
"	if(u4g_dbg_cnt_wlmng_mg5ms < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_mg5ms++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_mg5ms = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
    $write_data_file4_N21 = $write_data_file4_before + $src_file_id_N21 + $write_data_file4_after

        $src_file_id_N22 =
"   if(u4g_dbg_cnt_wlmng_mg10ms < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_mg10ms++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_mg10ms = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
    $write_data_file4_N22 = $write_data_file4_before + $src_file_id_N22 + $write_data_file4_after

    $src_file_id_N23 =
"   if(u4g_dbg_cnt_wlmng_ad2ms < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ad2ms++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ad2ms = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
    $write_data_file4_N23 = $write_data_file4_before + $src_file_id_N23 + $write_data_file4_after
    
    $src_file_id_N24 =
"	if(u4g_dbg_cnt_wlmng_ad4ms < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ad4ms++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ad4ms = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
    $write_data_file4_N24 = $write_data_file4_before + $src_file_id_N24 + $write_data_file4_after

    $src_file_id_N25 =
"   if(u4g_dbg_cnt_wlmng_ad8ms < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ad8ms++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ad8ms = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
    $write_data_file4_N25 = $write_data_file4_before + $src_file_id_N25 + $write_data_file4_after

    $src_file_id_N26 =
"   if(u4g_dbg_cnt_wlmng_ne10 < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ne10++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ne10 = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
    $write_data_file4_N26 = $write_data_file4_before + $src_file_id_N26 + $write_data_file4_after

    $src_file_id_N27 =
"	if(u4g_dbg_cnt_wlmng_ne30m < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ne30m++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ne30m = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
    $write_data_file4_N27 = $write_data_file4_before + $src_file_id_N27 + $write_data_file4_after

    $src_file_id_N28 =
"   if(u4g_dbg_cnt_wlmng_ne10h < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ne10h++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ne10h = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
    $write_data_file4_N28 = $write_data_file4_before + $src_file_id_N28 + $write_data_file4_after

    $src_file_id_N29 =
"	if(u4g_dbg_cnt_wlmng_ne10m < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ne10m++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ne10m = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
    $write_data_file4_N29 = $write_data_file4_before + $src_file_id_N29 + $write_data_file4_after

    $src_file_id_N30 =
"   if(u4g_dbg_cnt_wlmng_drvclchg < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_drvclchg++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_drvclchg = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
    $write_data_file4_N30 = $write_data_file4_before + $src_file_id_N30 + $write_data_file4_after

    $src_file_id_N31 =
"   if(u4g_dbg_cnt_wlmng_drvclchgwch < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_drvclchgwch++;         /* デバックRAMカウントアップ処理 */
    }
    else
    {
        u4g_dbg_cnt_wlmng_drvclchgwch = (u4)0;   /* デバックRAM上限ガード処理 */
    }"
    $write_data_file4_N31 = $write_data_file4_before + $src_file_id_N31 + $write_data_file4_after

            #一時ファイルの作成
            if (Test-Path($file4_PATH + ".new")) {
                Remove-Item ($file4_PATH + ".new")
            }
            $src_file = Get-Content $file4_PATH 
            [bool]$is_target_section = $false # 処理対象区間か
            [double]$num = 1  
            
            foreach ($line in $src_file) {
                    # 処理対象の開始行より前はそのまま出力
                    # 処理対象の開始行の場合にそのまま出力と切り替え用の処理出力
                    # 処理対象の開始行+1から処理対象の終了行-1はなにもしない
                    # 処理対象の終了行からはそのまま出力
            if ($line.Contains("static u1 u1s_wlmng_8msl_count;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                    $write_data_file4_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
            elseif ($num -eq 146) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                    $write_data_file4_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
            elseif ($line.Contains("u1s_wlmng_32msm_count = (u1)0;")) {
                    $is_target_section = $true
                    #% {} は foreach（Foreach-Object）を意味します
                    # |符号の意味：パイプライン
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                    $write_data_file4_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
            elseif ($num -eq 242) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N4 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 259) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N5 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 275) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N6 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 291) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N7 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 307) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N8 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 323) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N9 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 341) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N10 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 357) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N11 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 376) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N12 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 413) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N13 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 515) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N14 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 533) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N15 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 549) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N16 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 565) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N17 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 581) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N18 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 597) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N19 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 613) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N20 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 629) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N21 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 645) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N22 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 661) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N23 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 677) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N24 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 693) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N25 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 709) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N26 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 725) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N27 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 741) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N28 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 757) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N29 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 773) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N30 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 789) {
                $is_target_section = $true
                #% {} は foreach（Foreach-Object）を意味します
                # |符号の意味：パイプライン
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N31 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            else {
                if ($is_target_section -eq $false) {
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append
                }
                }
                $num =$num +1                   
        }
        Remove-Item $file4_PATH
        Move-Item ($file4_PATH + ".new") $file4_PATH
        }

        file1_set_F
        file2_set_F
        file3_set_F
        file4_set_F
        Write-Host "ソフトF改造成功"
        Write-Host "ソースを保存中--------"
        Copy-Item "..\..\main_micro\sources\" "kaizoF" -Recurse -Force
        Write-Host "改造ソフトFのビルド開始いたします。"
        Start-Process -Filepath "test_build.bat" -Wait -NoNewWindow 
        Write-Host "改造ソフトFのビルド結果物(Romフォルダ)を保存しています。"
        Copy-Item $Target_PATH "kaizoF" -Recurse -Force
        #ファイルを復元
        Remove-Item "..\..\main_micro\sources" -Recurse
        Copy-Item  "kaizoA\" "..\..\main_micro\sources" -Recurse -Force
        Write-Host "===================================================================="
        Write-Host "| 改造ソフトF作業を終わりました。|"
        Write-Host "===================================================================="   
    }

    switch ($kaizo_type) {
        B {kaizo_B}
        C {kaizo_C}
        D {kaizo_D}
        E {kaizo_E}
        F {kaizo_F}
        H { kaizo_B
            kaizo_C
            kaizo_D
            kaizo_E
            kaizo_F
        }
 
        Default {Write-Host "改造ソフトタイプが間違った、確認してください"}
    }
    #原ソースを削除する
    Remove-Item 'kaizoA' -Recurse
    "改造完了、Any key to exit"  ;Read-Host | Out-Null ;Exit
    #改造ソフトB
}


catch {
    pause

    "改造失敗、Any key to exit"  ;Read-Host | Out-Null ;exit 1
}
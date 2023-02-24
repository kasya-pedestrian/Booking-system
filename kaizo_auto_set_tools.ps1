###############################################################################
# 
# �����\�t�g���������c�[�� 
# 
###############################################################################
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"


try {
    #�K�v�ȏ������W����
    ###############################################################################
    #�o���G�[�V��������͂���
    Write-Host "===================================================================="
    Write-Host "| �����\�t�g��Ƃ��J�n���܂��B|"
    Write-Host "===================================================================="
    Write-Host "| �t�@�C�����R�s�[���ł��B|"
    Copy-Item "..\..\main_micro\sources\" "kaizoA" -Recurse -Force
    $SOURCES_PATH = "..\..\main_micro\sources" 
    [string]$VARI = Read-Host -Prompt '�����v�\�t�g�̃\�t�g�o���G�[�V��������͂��Ă�������'
    if (($VARI -ne 1000) -and ($VARI -ne 1100 )){
        Write-Host "�o���G�[�V�������s����"
        "Any key to exit"  ;Read-Host | Out-Null ;Exit
    }
    #���{�҂̖��O����͂���
    [string]$Implement_Name = Read-Host -Prompt '�������{�҂̖��O����͂��Ă�������'
    #�]�ƈ��R�[�h�����
    [string]$Implement_code = Read-Host -Prompt '�������{�҂̏]�ƈ��R�[�h����͂��Ă�������'
    $Target_PATH = "\\APLTMCECUBUZZ2\elec\user\" + $Implement_code +"\solar_test\main\rom"
    #��������͂���
    [string]$Implement_time = Read-Host -Prompt '������������͂��Ă��������i��:230124�j'
    #���{����
    [string]$Implement_department = Read-Host -Prompt '�������{�҂̕�������͂��Ă�������'
    $set_title_start ="/*" + " "+ "debug"+" "+"s"+" "+ $Implement_department+" " + $Implement_Name+ " " +$Implement_time+ " "+"*/" 
    $set_title_end = "/*" + " "+"debug"+" "+"e"+" "+ $Implement_department+" " + $Implement_Name+ " " +$Implement_time+ " "+"*/" 
    [String]$kaizo_type = Read-Host -Prompt '
    B�F�X�^�b�N�v���p�����\�t�g
    C�F�������׌v���p�����\�t�g
    D�FEEPROM�L���[�T�C�Y�v���p�����\�t�g
    E�F�Z���T�lRAMWrite�L���������\�t�g
    F�F�p���[�I���E�^�X�N�����m�F�p�����\�t�g
    G�F�X�^�b�N�v���p(����)�����\�t�g
    H�F�ȏ�̃\�t�g�iall�@���Ԃ�������j
    �����\�t�g�̔ԍ���I�т�������'
    ###############################################################################
    #�����\�t�g�J�n
    #�����\�t�gB
    function kaizo_B {
        Write-Host "===================================================================="
        Write-Host "| �����\�t�gB��Ƃ��J�n���܂��B|"
        Write-Host "===================================================================="     
        # sources�t�H���_�̃p�X
        $SOURCES_file1_B ="\src\id\giprogramid_c.h"  
        $SOURCES_file2_B ="\src\spf_p\ss\spp_sdbg\spp_sdbginfo_c.h"  
        $SOURCES_file3_B ="\src\spf_p\ss\spp_sevent\spp_sttrevt.h"
        $SOURCES_file4_B ="\src\spf_p\ss\spp_sevent\spp_sttrevt_l_mat.c"
#file1�̉���
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
            #�����ݓ��e
            $write_data_file1 = $write_data_file1_before + $src_file_id + $write_data_file1_after 
            
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file1_PATH + ".new")) {
                Remove-Item ($file1_PATH + ".new")
            }
            $src_file = Get-Content $file1_PATH
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
                if ($line.Contains("#if ( JGVARI == 1000 )")) {
                        $is_target_section = $true
                        #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                        # |�����̈Ӗ��F�p�C�v���C��
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
                # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#elif ( JGVARI == 1100 )")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
#file2�̉���
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
            #�����ݓ��e
            $write_data_file2 = $write_data_file2_before + $src_file_id + $write_data_file2_after 
            
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file2_PATH + ".new")) {
                Remove-Item ($file2_PATH + ".new")
            }
            $src_file = Get-Content $file2_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
                if ($line.Contains("#if ( JGVARI == 1000 )") -and $num -eq 116) {
                        $is_target_section = $true
                        #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                        # |�����̈Ӗ��F�p�C�v���C��
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
                # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#elif ( JGVARI == 1100 )") -and $num -eq 120 ) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
#file3�̉���
        function file3_set_B {
            $file3_PATH =$SOURCES_PATH + $SOURCES_file3_B 
            [string[]]$write_data_file3_before = @()
            $write_data_file3_before += ,""
            $write_data_file3_before += ,$set_title_start
            [string[]]$write_data_file3_after = @()
            $write_data_file3_after += ,$set_title_end
            $src_file_id = "extern char __ghsend_stack[];            /* �X�^�b�N�A�h���X */"
            #�����ݓ��e
            $write_data_file3 = $write_data_file3_before + $src_file_id + $write_data_file3_after    
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file3_PATH + ".new")) {
                Remove-Item ($file3_PATH + ".new")
            }
            $src_file = Get-Content $file3_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  

            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("extern u2  u2g_spp_sttrevt_8mslcnt;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
"#define STACK_SIZE ((u4)0x1FF8)                                         /* �X�^�b�N�T�C�Y */
#define u4s_dbg_stack_top ( (u4 *)((u4)&__ghsend_stack - STACK_SIZE) )  /* �X�^�b�N�擪�A�h���X */
#define u4s_dbg_stack_end ( (u4)(&__ghsend_stack) )                     /* �X�^�b�N�ŏI�A�h���X */
static u4 u4s_dbg_stack_adr;                                            /* ���݃X�^�b�N�A�h���X */
static u1 u1s_dbg_stack_val;                                            /* ���݃X�^�b�N�A�h���X�̃f�[�^ */
static u4 *pts_dbg_stack_chk_adr;                                       /* �`�F�b�N����X�^�b�N�A�h���X */
static u4 u4s_dbg_stack_adr_max;                                        /* �X�^�b�N�g�p�A�h���X�ő�l */"
            #�����ݓ��e
            $write_data_file4_N1 = $write_data_file4_before + $src_file_id1 + $write_data_file4_after
            $src_file_id2 = "    pts_dbg_stack_chk_adr = u4s_dbg_stack_top;      /* �`�F�b�N�A�h���X�̏����� */
    u4s_dbg_stack_adr_max = u4s_dbg_stack_end;      /* �X�^�b�N�g�p�A�h���X�ő�l�̏����� */"
            $write_data_file4_N2 = $write_data_file4_before + $src_file_id2 + $write_data_file4_after
            $src_file_id3 ="
    if( (u4)pts_dbg_stack_chk_adr < u4s_dbg_stack_end )
    {
        u4s_dbg_stack_adr = (u4)( pts_dbg_stack_chk_adr );  /* ���݃A�h���X���擾 */
        u1s_dbg_stack_val = (u1)( *pts_dbg_stack_chk_adr ); /* ���݃A�h���X�̃f�[�^���擾 */
        pts_dbg_stack_chk_adr++;                            /* �`�F�b�N�A�h���X�̃C���N�������g���� */
        if( u1s_dbg_stack_val != 0 )
        {
            /* �X�^�b�N�g�p�A�h���X�ő�l�̍X�V */
            if( u4s_dbg_stack_adr < u4s_dbg_stack_adr_max )
            {
                u4s_dbg_stack_adr_max = u4s_dbg_stack_adr;
            }
        }
    }
    else
    {
        pts_dbg_stack_chk_adr = u4s_dbg_stack_top;          /* �`�F�b�N�A�h���X�̏����� */
    }"
            $write_data_file4_N3 = $write_data_file4_before + $src_file_id3 + $write_data_file4_after

            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file4_PATH + ".new")) {
                Remove-Item ($file4_PATH + ".new")
            }
            $src_file = Get-Content $file4_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("u2  u2g_spp_sttrevt_8mslcnt;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
        Write-Host "�\�t�gB��������"
        Write-Host "�\�[�X��ۑ���--------"
        Copy-Item "..\..\main_micro\sources\" "kaizoB" -Recurse -Force
        
        Write-Host "�����\�t�gB�̃r���h�J�n�������܂��B"
        Start-Process -Filepath "test_build.bat" -Wait -NoNewWindow 
        Write-Host "�����\�t�gB�̃r���h���ʕ�(Rom�t�H���_)��ۑ����Ă��܂��B"
        Copy-Item $Target_PATH "kaizoB" -Recurse -Force
        #�t�@�C���𕜌�
        Remove-Item "..\..\main_micro\sources" -Recurse
        Copy-Item  "kaizoA\" "..\..\main_micro\sources" -Recurse -Force
        Write-Host "===================================================================="
        Write-Host "| �����\�t�gB��Ƃ��I���܂����B|"
        Write-Host "===================================================================="    
}
    function kaizo_C {
        Write-Host "===================================================================="
        Write-Host "| �����\�t�gC��Ƃ��J�n���܂��B|"
        Write-Host "===================================================================="     
        # sources�t�H���_�̃p�X
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
            #�����ݓ��e
            $write_data_file1 = $write_data_file1_before + $src_file_id + $write_data_file1_after 
            
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file1_PATH + ".new")) {
                Remove-Item ($file1_PATH + ".new")
            }
            $src_file = Get-Content $file1_PATH
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
                if ($line.Contains("#if ( JGVARI == 1000 )")) {
                        $is_target_section = $true
                        #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                        # |�����̈Ӗ��F�p�C�v���C��
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
                # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#elif ( JGVARI == 1100 )")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
            #�����ݓ��e
            $write_data_file2_N1 = $write_data_file2_before + $src_file_id1 + $write_data_file2_after
            $src_file_id2 = 
"static u4 u4s_dbg_vdg_spp_iadrcv_alladtrg_time_max;    /* lsb=250,unit=ns:�֐��������s���ԍő�l */ 
static u4 u4s_dbg_vdg_spp_iadrcv_alladtrg_time_now;    /* lsb=250,unit=ns:�֐��������s���Ԍ��ݒl */ "
            $write_data_file2_N2 = $write_data_file2_before + $src_file_id2 + $write_data_file2_after
            $src_file_id3 =
"   u4 u4t_time_now; /* lsb=250,unit=ns:1msh������������_���ݒl */
 	 	 
    u4 u4t_gtm;
    u4t_gtm= u4g_spp_ssysclk_clk_250ns();  /* �J�n���Ԏ擾 */"
            $write_data_file2_N3 = $write_data_file2_before + $src_file_id3 + $write_data_file2_after
            $src_file_id4 =
"    u4t_time_now = u4g_spp_ssysclk_sub_250ns(u4g_spp_ssysclk_clk_250ns(),u4t_gtm); /* �������ԎZ�o */
    u4s_dbg_vdg_spp_iadrcv_alladtrg_time_now = u4t_time_now;                                  /* ���ݒl�X�V */
    if (u4t_time_now > u4s_dbg_vdg_spp_iadrcv_alladtrg_time_max)                              /* �ő�l�X�V */
        {
            u4s_dbg_vdg_spp_iadrcv_alladtrg_time_max = u4t_time_now;
        }"
            $write_data_file2_N4 = $write_data_file2_before + $src_file_id4 + $write_data_file2_after
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file2_PATH + ".new")) {
                Remove-Item ($file2_PATH + ".new")
            }
            $src_file = Get-Content $file2_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1 
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#include `"../../../aplmng/apllmng.h`" /* vdg_apllmng_adtrg() */")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
                elseif ($line.Contains("/* ������ �K�v�ɉ����Ċ֐����������ނ��� ������ */")) {
                    $is_target_section = $true
                    $write_data_file2_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append
                    $is_target_section =$false
                }
                elseif ($line.Contains("/* ������ �K�v�ɉ����Ċ֐����������ނ��� ������ */")) {
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
            #�����ݓ��e
            $write_data_file3_N1 = $write_data_file3_before + $src_file_id1 + $write_data_file3_after
            $src_file_id2 = 
"static u4 u4s_spp_sttrevt_idle_time_now;                   /* lsb=250,unit=ns:idle��������_���ݒl */
    u4 u4s_spp_sttrevt_idle_time_min;                   /* lsb=250,unit=ns:idle��������_�ŏ��l */
    u4 u4s_idle_8ms_sum_cnt;                            /* lsb=250,unit=ns:idle��������_8ms���v�J�E���g�l */"
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

    u4s_spp_sttrevt_idle_time_now = u4g_spp_ssysclk_sub_250ns(u4g_spp_ssysclk_clk_250ns(),u4t_gtm); /* �������ԎZ�o */

    glint_ei();
    if (u4s_spp_sttrevt_idle_time_now < u4s_spp_sttrevt_idle_time_min)                              /* �ő�l�X�V */
    {
        u4s_spp_sttrevt_idle_time_min = u4s_spp_sttrevt_idle_time_now;
    }
    
    u4s_idle_8ms_sum_cnt = u4s_idle_8ms_sum_cnt + u4s_spp_sttrevt_idle_time_now;                    /* idol���s���ԍ��v�l�Z�o */
    
    if ( u4g_spp_sttrevt_idle_cnt_mon < u4g_U4MAX )
    {
        u4g_spp_sttrevt_idle_cnt_mon++;
    }"
        $write_data_file3_N5 =  $src_file_id5 + $write_data_file3_after

            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file3_PATH + ".new")) {
                Remove-Item ($file3_PATH + ".new")
            }
            $src_file = Get-Content $file3_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1 
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#include `"../spp_sboshtif.h`"         /* vdg_spp_sbosht_pwonctrl()    */")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
                elseif ($line.Contains("/* �\�t�g�E�F�A�p���[�I����������v���ւ̒ʒm */")) {
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
            #�����ݓ��e
            $write_data_file4 = $write_data_file4_before + $src_file_id + $write_data_file4_after 
            
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file4_PATH + ".new")) {
                Remove-Item ($file4_PATH + ".new")
            }
            $src_file = Get-Content $file4_PATH
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
                if ($line.Contains("#if ( JGVARI == 1000 )") -and $num -eq 116) {
                        $is_target_section = $true
                        #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                        # |�����̈Ӗ��F�p�C�v���C��
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
                # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#elif ( JGVARI == 1100 )") -and $num -eq 120 ) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
            #�����ݓ��e
            $write_data_file5_N1 = $write_data_file5_before + $src_file_id_N1  
            $src_file_id_N2 =
"#endif
#define SPP_SHDRMON_EXEC_ALL       SPP_SHDRMON_USE  /* ���荞�݃��j�^�@�\�؂�ւ�         NOUSE:��g�p   USE:�g�p     */
#define SPP_SHDRMON_EXEC_END2START SPP_SHDRMON_USE  /* �I������J�n�܂ł̎��Ԍv���؂�ւ� NOUSE:�v������ USE:�v���L�� */
#define SPP_SHDRMON_EXEC_START2END SPP_SHDRMON_USE  /* �J�n����I���܂ł̎��Ԍv���؂�ւ� NOUSE:�v������ USE:�v���L�� */"

            $write_data_file5_N2 = $src_file_id_N2 + $write_data_file5_after
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file5_PATH + ".new")) {
                Remove-Item ($file5_PATH + ".new")
            }
            $src_file = Get-Content $file5_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("/* �R���p�C��SW */")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
            $src_file_id_N1 = "extern u4 u4g_spp_sttrevt_idle_cnt_mon; /* lsb=1,unit=�� : �A�C�h�����s�� */"
            #�����ݓ��e
            $write_data_file6_N1 = $write_data_file6_before + $src_file_id_N1 + $write_data_file6_after

            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file6_PATH + ".new")) {
                Remove-Item ($file6_PATH + ".new")
            }
            $src_file = Get-Content $file6_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
                if ($line.Contains("extern u2  u2g_spp_sttrevt_8mslcnt;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
"/* �������׌v���pRAM��` */
u4 u4g_spp_sttrevt_idle_cnt_mon;                   /* lsb=1,unit=��  :�A�C�h�����s�񐔉��Z�p  */
    
static u4 u4s_spp_sttrevt_idle_cnt_min;            /* lsb=1,unit=��  :�A�C�h�����s��_�ŏ��l */
static u4 u4s_spp_sttrevt_idle_cnt_now_mon;        /* lsb=1,unit=��  :�A�C�h�����s��_���ݒl */
static u4 u4s_spp_sttrevt_idle_miss_cnt;           /* lsb=1,unit=��  :�A�C�h�������� */
    
static u4 u4s_spp_sttrevt_1msh_time_max;           /* lsb=250,unit=ns:1msh������������_�ő�l */
static u4 u4s_spp_sttrevt_1msh_time_now;           /* lsb=250,unit=ns:1msh������������_���ݒl */
static u4 u4s_spp_sttrevt_4msm_time_max;           /* lsb=250,unit=ns:4msm������������_�ő�l */
static u4 u4s_spp_sttrevt_4msm_time_now;           /* lsb=250,unit=ns:4msm������������_���ݒl */
static u4 u4s_spp_sttrevt_8msl_time_max;           /* lsb=250,unit=ns:8msl������������_�ő�l */
static u4 u4s_spp_sttrevt_8msl_time_now;           /* lsb=250,unit=ns:8msl������������_���ݒl */
    
static u4 u4s_spp_sttrevt_idle_8ms_sum_time_now;   /* lsb=250,unit=ns:idle��������_8ms���v_���ݒl */
static u4 u4s_spp_sttrevt_idle_8ms_sum_time_min;   /* lsb=250,unit=ns:idle��������_8ms���v_�ŏ��l */
    
extern u4 u4s_spp_sttrevt_idle_time_min;           /* lsb=250,unit=ns:�A�C�h���^�X�N�������ԍŏ��l   */
extern u4 u4s_idle_8ms_sum_cnt;                    /* lsb=250,unit=ns:idle��������_8ms���v�J�E���g�l */"
            #�����ݓ��e
            $write_data_file7_N1 = $write_data_file7_before + $src_file_id_N1 + $write_data_file7_after
            $src_file_id_N2 =
"   /* �ŏ��l���m�F�������̂ŃC�j�V�����ōő�l������ */
    u4s_spp_sttrevt_idle_cnt_now_mon = u4g_U4MAX;
    u4s_spp_sttrevt_idle_cnt_min = u4g_U4MAX;
    u4s_spp_sttrevt_idle_time_min = u4g_U4MAX;
    u4s_spp_sttrevt_idle_8ms_sum_time_min = u4g_U4MAX;"
            $write_data_file7_N2 = $write_data_file7_before + $src_file_id_N2 + $write_data_file7_after
            $src_file_id_N3 =
"   u4 u4t_time_now; /* lsb=250,unit=ns:1msh������������_���ݒl */

    u4 u4t_gtm;
    u4t_gtm= u4g_spp_ssysclk_clk_250ns();  /* �J�n���Ԏ擾 */ "
            $write_data_file7_N3 = $write_data_file7_before + $src_file_id_N3 + $write_data_file7_after
            $src_file_id_N4 = "#if 0 "
            $write_data_file7_N4 =$write_data_file7_before + $src_file_id_N4
            $src_file_id_N5 = "	#endif 
"
            $write_data_file7_N5 = $src_file_id_N5 + $write_data_file7_after
            $src_file_id_N6 =
"   u4t_time_now = u4g_spp_ssysclk_sub_250ns(u4g_spp_ssysclk_clk_250ns(),u4t_gtm); /* �������ԎZ�o */
    u4s_spp_sttrevt_1msh_time_now = u4t_time_now;                                  /* ���ݒl�X�V */
    if (u4t_time_now > u4s_spp_sttrevt_1msh_time_max)                              /* �ő�l�X�V */
    {
        u4s_spp_sttrevt_1msh_time_max = u4t_time_now;
    }
    /* �^�X�N�̏I��(TerminateTask())�͎��Ԏ����^�X�N���̒�`(CREATE_TASK( spp_sttrevt_1msh ))�����Ŕ��s���邽�߁A���s�s�v */

"
            $write_data_file7_N6 = $write_data_file7_before + $src_file_id_N6 + $write_data_file7_after
            $src_file_id_N7 = 
"   u4 u4t_time_now;    /* lsb=250,unit=ns:4msm������������_���ݒl */
    u4 u4t_gtm;

    u4t_gtm = u4g_spp_ssysclk_clk_250ns();   /* �������׌v�����̓^�X�N�P�̂̎��Ԃ��v�� */"
            $write_data_file7_N7 = $write_data_file7_before + $src_file_id_N7 + $write_data_file7_after
            $src_file_id_N8 =
"   u4t_time_now = u4g_spp_ssysclk_sub_250ns(u4g_spp_ssysclk_clk_250ns(),u4t_gtm); /* �������ԎZ�o */
 	 	    
    u4s_spp_sttrevt_4msm_time_now = u4t_time_now;                                  /* ���ݒl�X�V */
    if (u4t_time_now > u4s_spp_sttrevt_4msm_time_max)                              /* �ő�l�X�V */
    {
        u4s_spp_sttrevt_4msm_time_max = u4t_time_now;
    }"
        $write_data_file7_N8 = $write_data_file7_before + $src_file_id_N8 + $write_data_file7_after
        $src_file_id_N9 = 
"   u4 u4t_time_now;    /* lsb=250,unit=ns:8msl������������_���ݒl */
 	 	 
    u4 u4t_gtm;

    u4t_gtm = u4g_spp_ssysclk_clk_250ns();   /* �������׌v�����̓^�X�N�P�̂̎��Ԃ��v�� */
    u4s_spp_sttrevt_idle_8ms_sum_time_now = u4s_idle_8ms_sum_cnt;   /* 8ms��idol���s���Ԃ�o�^ */

    /* �A�C�h���������菈�� (8msl����idle�����o���Ă��邩)*/
    if ( u4g_spp_sttrevt_idle_cnt_mon == 0 )
    {
        if ( u4s_spp_sttrevt_idle_miss_cnt < u4g_U4MAX )
        {
            u4s_spp_sttrevt_idle_miss_cnt++;
        }
    }
    else  /* �ŏ��񐔎擾���� */
    {
        if (u4g_spp_sttrevt_idle_cnt_mon < u4s_spp_sttrevt_idle_cnt_min)
        {
            u4s_spp_sttrevt_idle_cnt_min = u4g_spp_sttrevt_idle_cnt_mon;                        /* idle���s�񐔍ŏ��l�X�V */
        }
        if (u4s_idle_8ms_sum_cnt < u4s_spp_sttrevt_idle_8ms_sum_time_min)
        {
            u4s_spp_sttrevt_idle_8ms_sum_time_min = u4s_idle_8ms_sum_cnt;                       /* idle��������_8ms_���v�l_�ŏ����ԍX�V */
        }
    }

    u4s_spp_sttrevt_idle_cnt_now_mon = u4g_spp_sttrevt_idle_cnt_mon;                             /* idle��_�J�E���g���ݒl�X�V */
    u4s_spp_sttrevt_idle_8ms_sum_time_now = u4s_idle_8ms_sum_cnt;                                /* idle��������_8ms���v�J�E���g���ݒl�X�V */
    u4g_spp_sttrevt_idle_cnt_mon = 0;                                                            /* idle��_�J�E���g�l������(8ms���Ƃɏ���������) */
    u4s_idle_8ms_sum_cnt = 0;                                                                    /* idle��������_8ms���v�J�E���g�l������(8ms���Ƃɏ���������) */
"
            $write_data_file7_N9 = $write_data_file7_before + $src_file_id_N9 + $write_data_file7_after
            $src_file_id_N10 = 
"   u4t_time_now = u4g_spp_ssysclk_sub_250ns(u4g_spp_ssysclk_clk_250ns(),u4t_gtm); /* �������ԎZ�o */

    u4s_spp_sttrevt_8msl_time_now = u4t_time_now;                                  /* ���ݒl�X�V */
    if (u4t_time_now > u4s_spp_sttrevt_8msl_time_max)                              /* �ő�l�X�V */
    {
        u4s_spp_sttrevt_8msl_time_max = u4t_time_now;
    }
    /* �^�X�N�̏I��(TerminateTask())�͎��Ԏ����^�X�N���̒�`(CREATE_TASK( spp_sttrevt_8msl ))�����Ŕ��s���邽�߁A���s�s�v */"
            $write_data_file7_N10 = $write_data_file7_before + $src_file_id_N10 + $write_data_file7_after
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file7_PATH + ".new")) {
                Remove-Item ($file7_PATH + ".new")
            }
            $src_file = Get-Content $file7_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
                if ($line.Contains("u2  u2g_spp_sttrevt_8mslcnt;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("/*     u2g_spp_sttrevt_8mslcnt   = (u2)0;              */")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("u4 u4t_pc;   /* �v���O�����J�E���^     */")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("u4t_pc = u4g_spp_mmcalif_msupgetpc();")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N4 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    } 
                elseif ($line.Contains("vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_RTOS, u4t_pc );")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N5 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("u1g_spp_sttrevt_1mshcnt = u1t_1mshcnt;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N6 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }  
                elseif ($line.Contains("u2 u2t_4msmcnt;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N7 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    } 
                elseif ($line.Contains("u2g_spp_sttrevt_4msmcnt = u2t_4msmcnt;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N8 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("u2 u2t_8mslcnt;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append    
                    $write_data_file7_N9 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file7_PATH + ".new") -Append
                    $is_target_section = $false
                    }
                elseif ($line.Contains("2g_spp_sttrevt_8mslcnt = u2t_8mslcnt;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
    Write-Host "�\�t�gC��������"
    Write-Host "�\�[�X��ۑ���--------"
    Copy-Item "..\..\main_micro\sources\" "kaizoC" -Recurse -Force
    Write-Host "�����\�t�gC�̃r���h�J�n�������܂��B"
    Start-Process -Filepath "test_build.bat" -Wait -NoNewWindow 
    Write-Host "�����\�t�gC�̃r���h���ʕ�(Rom�t�H���_)��ۑ����Ă��܂��B"
    Copy-Item $Target_PATH "kaizoC" -Recurse -Force
    #�t�@�C���𕜌�
    Remove-Item "..\..\main_micro\sources" -Recurse
    Copy-Item  "kaizoA\" "..\..\main_micro\sources" -Recurse -Force
    Write-Host "===================================================================="
    Write-Host "| �����\�t�gC��Ƃ��I���܂����B|"
    Write-Host "====================================================================" 
}
    function kaizo_D {
        Write-Host "===================================================================="
        Write-Host "| �����\�t�gD��Ƃ��J�n���܂��B|"
        Write-Host "===================================================================="     
        # sources�t�H���_�̃p�X
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
            #�����ݓ��e
            $write_data_file1_N1 = $write_data_file1_before + $src_file_id_N1 + $write_data_file1_after
            $src_file_id_N2 =
"#define  ROB_MODE_DEF    ((u1)(0))                      /* �ʏ탂�[�h */
#define  ROB_MODE_1      ((u1)(1))                      /* RoB�����������[�h */
#define  ROB_MODE_2      ((u1)(2))                      /* RoB�������[�h(��@) */
#define  ROB_MODE_3      ((u1)(3))                      /* RoB�������[�h(NM) */"
            $write_data_file1_N2 = $write_data_file1_before + $src_file_id_N2 + $write_data_file1_after
            $src_file_id_N3 =
"u1 u1g_dbg_mode;         /* �f�o�b�N���[�h�ؑ֗p�t���O_0:�ʏ퐧�䃂�[�h_1:�f�o�b�N���[�h */
u1 u1g_dbg_RoBmode;      /* RoB���[�h�؂�ւ��t���O_0:�ʏ탂�[�h_1:RoB��������_2:RoB����(��@)_RoB����(NM) */"
            $write_data_file1_N3 = $write_data_file1_before + $src_file_id_N3 + $write_data_file1_after
            $src_file_id_N4 =
"   switch(u1g_dbg_RoBmode)
    {
        case ROB_MODE_1:
            u1g_hsmiddvi_xovsf = (u1)1;                         /* RoB(SOL���d��艺��(DDC�v��)(0x056DU))�����g���K */
            u2g_dbg_write_hsrob_soldc1winor_cnt = (u2)126;      /* RoB(��i�O RoB�ݒ��񕔕i(0x0002U))�����g���K  */
            u1g_hsbstdcdvi_xthng = (u1)1;                       /* RoB(��d�r�[�d��艺��(DDC�v��)(0x056BU))�����g���K */
            u1g_hsecucomi_soljdg = (u1)4;                       /* RoB(��d�r�[�d�s����(HV�V�X�e��)(0x0567U))�����g���K */
            u1g_hsbstdcdvi_xovsf = (u1)1;                       /* RoB(��d�r�扺��(�ߓd���v��)(0x0001U))�����g���K */
            break;
        
        case ROB_MODE_2:
            u2g_dbg_write_hsrob_auxdcthng_cnt = (u2)126;        /* RoB(��@���d��艺��(DDC�v��)(0x0569U))�����g���K */
            break;
        
        case ROB_MODE_3:
            u4g_dbg_write_wnmrewkup_cwkupcnt = (u4)450001;      /* RoB(�ߏ�E�F�C�N�A�b�v(0xF001U))�����g���K */
            u1g_dbg_write_wnmrewkup_wkupcnt = (u1)23;           /* RoB(�ߏ�E�F�C�N�A�b�v(0xF001U))�����g���K */
            u4g_dbg_write_wnmslpng_cslpngcnt = (u4)450001;      /* RoB(�X���[�vNG(0xF002U))�����g���K */
            u1g_dbg_write_aplawkfctigb = (u1)1;                 /* RoB(�X���[�vNG(0xF002U))�����g���K */
            u4g_dbg_write_wslprewkup_cwkupcnt = (u4)525001;     /* RoB(�ߏ�E�F�C�N�A�b�v(0xF009U))�����g���K */
            u1g_dbg_write_wslprewkup_wkupcnt = (u1)51;          /* RoB(�ߏ�E�F�C�N�A�b�v)(0xF009U))�����g���K */
            u4g_dbg_write_wslpslpng_cslpngcnt = (u4)525001;     /* RoB(�X���[�vNG(0xF00AU))�����g���K */
            break;

        default :
            /* �����Ȃ� */
            break;
    }"
        $write_data_file1_N4 = $write_data_file1_before + $src_file_id_N4 + $write_data_file1_after
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file1_PATH + ".new")) {
                Remove-Item ($file1_PATH + ".new")
            }
            $src_file = Get-Content $file1_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("/* ������ �C�x���g�ɍ������ޕ��i�̃w�b�_�t�@�C���C���N���[�h(�@�했�ɕҏW) ������ */")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
                elseif ($line.Contains("/* ������ �K�v�ɉ����Ċ֐����������ނ��� ������ */") -and $num -eq 186) {
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
void vdg_chkquesizeinit( void );              /* EEPROM�g�p�L���[�T�C�Y�m�F�p              */
"
            #�����ݓ��e
            $write_data_file2_N1 = $write_data_file2_before + $src_file_id_N1 + $write_data_file2_after
            $src_file_id_N2 =
"u1   u1g_ceeprom_calc_quesize( u1, u1, u1 );/* EEPROM�g�p�L���[�T�C�Y�m�F�p */
                                            /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
#define u1g_CEEPROM_WRITE    0              /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
#define u1g_CEEPROM_READ     1              /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
#define u1g_CEEPROM_MEMERR   2              /* EEPROM�g�p�L���[�T�C�Y�m�F�p */"
            $write_data_file2_N2 = $write_data_file2_before + $src_file_id_N2 + $write_data_file2_after

            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file2_PATH + ".new")) {
                Remove-Item ($file2_PATH + ".new")
            }
            $src_file = Get-Content $file2_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains(" /* ���ӎ��� :") -and $num -eq 115) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                    $write_data_file2_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
            elseif ($line.Contains("(�������ݗv���ɂĎ��{�̂���)")) {
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
"#pragma     SECTION bss spp_msram                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
static u1   u1s_ceeprom_dummy;                                       /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
static u1   u1s_ceeprom_wque_maxuse;                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
static u1   u1s_ceeprom_rque_maxuse;                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
static u1   u1s_ceeprom_eque_maxuse;                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
static u1   u1s_ceeprom_wque_use;                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
static u1   u1s_ceeprom_rque_use;                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
static u1   u1s_ceeprom_eque_use;                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
#pragma     SECTION bss      bss   /* �f�t�H���g�̃Z�N�V�����ɖ߂� *//* EEPROM�g�p�L���[�T�C�Y�m�F�p */
static u2   u2s_ceeprom_wque_count;                                  /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
static u2   u2s_ceeprom_rque_count;                                  /* EEPROM�g�p�L���[�T�C�Y�m�F�p */"
            #�����ݓ��e
            $write_data_file3_N1 = $write_data_file3_before + $src_file_id_N1 + $write_data_file3_after

            $src_file_id_N2 =
"void                              /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
vdg_chkquesizeinit( void )        /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
{                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u1s_ceeprom_wque_maxuse = 0;  /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u1s_ceeprom_rque_maxuse = 0;  /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u1s_ceeprom_eque_maxuse = 0;  /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u1s_ceeprom_wque_use = 0;     /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u1s_ceeprom_rque_use = 0;     /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u1s_ceeprom_eque_use = 0;     /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u2s_ceeprom_wque_count = 0;   /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u2s_ceeprom_rque_count = 0;   /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
}"
            $write_data_file3_N2 = $write_data_file3_before + $src_file_id_N2 + $write_data_file3_after
            $src_file_id_N3 = 
"   u1s_ceeprom_wque_use = u1g_ceeprom_calc_quesize( u1s_ceeprom_wque_idxw, u1s_ceeprom_wque_idxr, u1g_CEEPROM_WRITE );/* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    if ( u1s_ceeprom_wque_use > u1s_ceeprom_wque_maxuse )                                                              /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
{                                                                                                                  /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        u1s_ceeprom_wque_maxuse = u1s_ceeprom_wque_use;                                                               /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
}                                                                                                                  /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        u2s_ceeprom_wque_count++;                                                                                          /* EEPROM�g�p�L���[�T�C�Y�m�F�p */ "
            $write_data_file3_N3 = $write_data_file3_before + $src_file_id_N3 + $write_data_file3_after
            $src_file_id_N4 = 
"   u1s_ceeprom_rque_use = u1g_ceeprom_calc_quesize( u1s_ceeprom_rque_idxw, u1s_ceeprom_rque_idxr, u1g_CEEPROM_READ );/* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    if ( u1s_ceeprom_rque_use > u1s_ceeprom_rque_maxuse )                                                             /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    {                                                                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        u1s_ceeprom_rque_maxuse = u1s_ceeprom_rque_use;                                                              /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    }                                                                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u2s_ceeprom_rque_count++;                                                                                         /* EEPROM�g�p�L���[�T�C�Y�m�F�p */"
            $write_data_file3_N4 = $write_data_file3_before + $src_file_id_N4 + $write_data_file3_after
            $src_file_id_N5 = 
"   u1s_ceeprom_eque_use = u1g_ceeprom_calc_quesize( u1s_ceeprom_eque_idxw, u1s_ceeprom_eque_idxr, u1g_CEEPROM_MEMERR );/* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    if ( u1s_ceeprom_eque_use > u1s_ceeprom_eque_maxuse )                                                               /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    {                                                                                                                   /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        u1s_ceeprom_eque_maxuse = u1s_ceeprom_eque_use;                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    }                                                                                                                   /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u2s_ceeprom_rque_count++;                                                                                           /* EEPROM�g�p�L���[�T�C�Y�m�F�p *"
            $write_data_file3_N5 = $write_data_file3_before + $src_file_id_N5 + $write_data_file3_after
            $src_file_id_N6 =
"   u1s_ceeprom_wque_use = u1g_ceeprom_calc_quesize( u1s_ceeprom_wque_idxw, u1s_ceeprom_wque_idxr, u1g_CEEPROM_WRITE );/* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    if ( u1s_ceeprom_wque_use > u1s_ceeprom_wque_maxuse )                                                              /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    {                                                                                                                  /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        u1s_ceeprom_wque_maxuse = u1s_ceeprom_wque_use;                                                                /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    }                                                                                                                  /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u2s_ceeprom_wque_count++;                                                                                          /* EEPROM�g�p�L���[�T�C�Y�m�F�p */"
            $write_data_file3_N6 = $write_data_file3_before + $src_file_id_N6 + $write_data_file3_after   
            $src_file_id_N7 = 
"   u1s_ceeprom_rque_use = u1g_ceeprom_calc_quesize( u1s_ceeprom_rque_idxw, u1s_ceeprom_rque_idxr, u1g_CEEPROM_READ );/* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    if ( u1s_ceeprom_rque_use > u1s_ceeprom_rque_maxuse )                                                             /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    {                                                                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        u1s_ceeprom_rque_maxuse = u1s_ceeprom_rque_use;                                                               /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    }                                                                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u2s_ceeprom_rque_count++;                                                                                         /* EEPROM�g�p�L���[�T�C�Y�m�F�p */"
            $write_data_file3_N7 = $write_data_file3_before + $src_file_id_N7 + $write_data_file3_after 
            $src_file_id_N8 = 
"   u1s_ceeprom_eque_use = u1g_ceeprom_calc_quesize( u1s_ceeprom_eque_idxw, u1s_ceeprom_eque_idxr, u1g_CEEPROM_MEMERR );/* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    if ( u1s_ceeprom_eque_use > u1s_ceeprom_eque_maxuse )                                                               /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    {                                                                                                                   /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        u1s_ceeprom_eque_maxuse = u1s_ceeprom_eque_use;                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    }                                                                                                                   /* EEPROM�g�p�L���[�T�C�Y�m�F�p */"
            $write_data_file3_N8 = $write_data_file3_before + $src_file_id_N8 + $write_data_file3_after 
            $src_file_id_N9 =
"u1                                                                                                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
u1g_ceeprom_calc_quesize( u1 u1t_idxw, u1 u1t_idxr, u1 u1t_mode )                                                     /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
{                                                                                                                     /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u1 u1t_quesize = 0;                                                                                               /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u1 u1t_maxquesize = 0;                                                                                            /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u1 u1t_que_before = 0;                                                                                            /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    u1 u1t_que = 0;                                                                                                   /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
                                                                                                                        /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    switch ( u1t_mode )                                                                                               /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    {                                                                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        case u1g_CEEPROM_WRITE:                                                                                       /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            u1t_maxquesize = u1s_ceeprom_wquesize;                                                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            /* �L���[�����t���ǂ����`�F�b�N���� */                                                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            /* �����O�o�b�t�@�̌��ݎw���Ă���ǂݏo���C���f�b�N�X�̒��O�܂ŗv�������܂��Ă��邱�ƂŃ`�F�b�N */        /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            u1t_que_before = (u1)u2g_cmemmng_sub_queidx( (u2)u1s_ceeprom_wque_idxr, (u1)1, (u2)u1s_ceeprom_wquesize );/* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            u1t_que = sts_ceeprom_wque[u1t_que_before].st_memid.u1_domain_id;                                         /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            break;                                                                                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
                                                                                                                        /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        case u1g_CEEPROM_READ:                                                                                        /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            u1t_maxquesize = u1s_ceeprom_rquesize;                                                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            /* �L���[�����t���ǂ����`�F�b�N���� */                                                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            /* �����O�o�b�t�@�̌��ݎw���Ă���ǂݏo���C���f�b�N�X�̒��O�܂ŗv�������܂��Ă��邱�ƂŃ`�F�b�N */        /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            u1t_que_before = (u1)u2g_cmemmng_sub_queidx( (u2)u1s_ceeprom_rque_idxr, (u1)1, (u2)u1s_ceeprom_rquesize );/* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            u1t_que = sts_ceeprom_rque[u1t_que_before].st_memid.u1_domain_id;                                         /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            break;                                                                                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
                                                                                                                        /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        case u1g_CEEPROM_MEMERR:                                                                                      /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            u1t_maxquesize = u1s_ceeprom_equesize;                                                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            /* �L���[�����t���ǂ����`�F�b�N���� */                                                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            /* �����O�o�b�t�@�̌��ݎw���Ă���ǂݏo���C���f�b�N�X�̒��O�܂ŗv�������܂��Ă��邱�ƂŃ`�F�b�N */        /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            u1t_que_before = (u1)u2g_cmemmng_sub_queidx( (u2)u1s_ceeprom_eque_idxr, (u1)1, (u2)u1s_ceeprom_equesize );/* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            u1t_que = sts_ceeprom_eque[u1t_que_before].st_memid.u1_domain_id;                                         /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            break;                                                                                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
                                                                                                                        /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        default:                                                                                                      /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            break;                                                                                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    }                                                                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
                                                                                                                        /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    if ( u1t_idxw - u1t_idxr < 0 )                                                                                    /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    {                                                                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        u1t_quesize = u1t_maxquesize + u1t_idxw - u1t_idxr;                                                           /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    }                                                                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    else if ( u1t_idxw - u1t_idxr == 0 )                                                                              /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    {                                                                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        if ( u1t_que == u1g_CMEMMNG_NULL_ID )               /* �L���[�ɋ󂪂��鎞 */                                  /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        {                                                                                                             /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            u1t_quesize = 0;                                                                                          /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        }                                                                                                             /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        else                                                                                                          /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        {                                                                                                             /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
            u1t_quesize = u1t_maxquesize;                                                                             /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        }                                                                                                             /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    }                                                                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    else                                                                                                              /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    {                                                                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
        u1t_quesize = u1t_idxw - u1t_idxr;                                                                            /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    }                                                                                                                 /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
                                                                                                                        /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
    return u1t_quesize;                                                                                               /* EEPROM�g�p�L���[�T�C�Y�m�F�p */
}                                                                                                                     /* EEPROM�g�p�L���[�T�C�Y�m�F�p */"
        $write_data_file3_N9 = $write_data_file3_before + $src_file_id_N9 + $write_data_file3_after
#�ꎞ�t�@�C���̍쐬
            if (Test-Path($file3_PATH + ".new")) {
                Remove-Item ($file3_PATH + ".new")
            }
            $src_file = Get-Content $file3_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("static u1   u1s_ceeprom_ref_eepsram_sts;              /**< lsb=1,unit=- :EEPROM+SRAM���t���b�V�������� */")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
            elseif ($line.Contains("u1s_ceeprom_wque_idxw = (u1)u2g_cmemmng_add_queidx( (u2)u1t_wque_idxw, (u1)1U, (u2)u1s_ceeprom_wquesize );  /* �L���[�C���f�b�N�X���Z */")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u1s_ceeprom_rque_idxw = (u1)u2g_cmemmng_add_queidx( (u2)u1t_rque_idxw, (u1)1U, (u2)u1s_ceeprom_rquesize );  /* �L���[�C���f�b�N�X���Z */")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N4 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains(" u1s_ceeprom_eque_idxw = (u1)u2g_cmemmng_add_queidx( (u2)u1t_eque_idxw, (u1)1U, (u2)u1s_ceeprom_equesize );  /* �L���[�C���f�b�N�X���Z */")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N5 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("�f�[�^�l�͏����s�v�Ȃ̂ł��̂܂�")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N6 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("�f�[�^�̈�͏����s�v�Ȃ̂ł��̂܂�")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N7 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u1s_ceeprom_eque_idxr = (u1)u2g_cmemmng_add_queidx( (u2)u1t_eque_idxr, (u1)1U, (u2)u1s_ceeprom_equesize );     /* �ǂݏo��idx���� */")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $write_data_file3_N8 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u1s_ceeprom_eque_idxr = (u1)u2g_cmemmng_add_queidx( (u2)u1t_eque_idxr, (u1)1U, (u2)u1s_ceeprom_equesize );    /* �ǂݏo��idx���� */")) {
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
"   vdg_chkquesizeinit();            /* EEPROM�g�p�L���[�T�C�Y�m�F�p */"
            #�����ݓ��e
            $write_data_file4_N1 = $write_data_file4_before + $src_file_id_N1 + $write_data_file4_after
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file4_PATH + ".new")) {
                Remove-Item ($file4_PATH + ".new")
            }
            $src_file = Get-Content $file4_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("vdg_cmemmng_pwon();")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
"extern u1 u1g_dbg_mode;                              /* �f�o�b�N���[�h�ؑ֗p�t���O_0:�ʏ퐧�䃂�[�h_1:�f�o�b�N���[�h */
extern u1 u1g_dbg_RoBmode;                           /* RoB���[�h�؂�ւ��t���O_0:�ʏ탂�[�h_1:RoB��������_2:RoB����(��@)_RoB����(NM) */
extern u2 u2g_dbg_write_hsrob_soldc1winor_cnt;       /* m=hsrob, lsb=8, ofs=0 ,unit=ms�F�\�[���[DDC1���͓d�͒�i�O�p���J�E���^����pRAM */
extern u2 u2g_dbg_write_hsrob_auxdcthng_cnt;         /* m=hsrob, lsb=8, ofs=0 ,unit=ms�F��@DDC�����ُ�p���J�E���^����pRAM */
extern u4 u4g_dbg_write_wnmrewkup_cwkupcnt;          /* RAM�l����pRAM(u4s_wnmrewkup_cwkupcnt) */
extern u1 u1g_dbg_write_wnmrewkup_wkupcnt;           /* RAM�l����pRAM(u1s_wnmrewkup_wkupcnt) */
extern u4 u4g_dbg_write_wnmslpng_cslpngcnt;          /* RAM�l����pRAM(u4s_wnmslpng_cslpngcnt) */
extern u1 u1g_dbg_write_aplawkfctigb;                /* RAM�l����pRAM(u1t_aplawkfctigb) */
extern u4 u4g_dbg_write_wslprewkup_cwkupcnt;         /* RAM�l����pRAM(u4s_wslprewkup_cwkupcnt) */
extern u1 u1g_dbg_write_wslprewkup_wkupcnt;          /* RAM�l����pRAM(u1s_wslprewkup_wkupcnt) */
extern u4 u4g_dbg_write_wslpslpng_cslpngcnt;         /* RAM�l����pRAM(u4s_wslpslpng_cslpngcnt) */"
            #�����ݓ��e
            $write_data_file5_N1 = $write_data_file5_before + $src_file_id_N1 + $write_data_file5_after
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file5_PATH + ".new")) {
                Remove-Item ($file5_PATH + ".new")
            }
            $src_file = Get-Content $file5_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#endif  /* COMMON_H */")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
            #�����ݓ��e
            $write_data_file6 = $write_data_file6_before + $src_file_id + $write_data_file6_after 
            
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file6_PATH + ".new")) {
                Remove-Item ($file6_PATH + ".new")
            }
            $src_file = Get-Content $file6_PATH
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
                if ($line.Contains("#if ( JGVARI == 1000 )")) {
                        $is_target_section = $true
                        #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                        # |�����̈Ӗ��F�p�C�v���C��
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
                # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#elif ( JGVARI == 1100 )")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
    /* RoB���������X�V��~���� */
    if(u1g_dbg_mode == (u1)1)
    {
        /* �X�V�����Ȃ� */
    }
    else
    {
        u1g_hsbstdcdvi_xthng = u1t_tmp;
    }
    "
            $write_data_file7_after += ,$set_title_end
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file7_PATH + ".new")) {
                Remove-Item ($file7_PATH + ".new")
            }
            $src_file = Get-Content $file7_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("u1g_hsbstdcdvi_xthng = u1t_tmp;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
/* RoB���������X�V��~���� */
    if(u1g_dbg_mode == (u1)1)
    {
        /* �X�V�����Ȃ� */
    }
    else
    {
        u1g_hsecucomi_soljdg = u1g_zcandat_soljdg;
    }"
            $write_data_file8_after += ,$set_title_end
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file8_PATH + ".new")) {
                Remove-Item ($file8_PATH + ".new")
            }
            $src_file = Get-Content $file8_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("u1g_hsecucomi_soljdg = u1g_zcandat_soljdg;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
/* RoB���������X�V��~���� */
    if(u1g_dbg_mode == (u1)1)
    {
        /* �X�V�����Ȃ� */
    }
    else
    {
        u1g_hsmiddvi_xovsf = u1t_tmp4;
    }"
            $write_data_file9_after += ,$set_title_end
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file9_PATH + ".new")) {
                Remove-Item ($file9_PATH + ".new")
            }
            $src_file = Get-Content $file9_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("u1g_hsmiddvi_xovsf = u1t_tmp4;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
"u2 u2g_dbg_write_hsrob_soldc1winor_cnt;  /* m=hsrob, lsb=8, ofs=0 ,unit=ms�F�\�[���[DDC1���͓d�͒�i�O�p���J�E���^����pRAM */
u2 u2g_dbg_write_hsrob_auxdcthng_cnt;    /* m=hsrob, lsb=8, ofs=0 ,unit=ms�F��@DDC�����ُ�p���J�E���^����pRAM */"
            #�����ݓ��e
            $write_data_file10_N1 = $write_data_file10_before + $src_file_id_N1 + $write_data_file10_after

            $src_file_id_N2 =
"   /* u2s_hsrob_auxdcthng_cnt�X�V���� */
    if(u1g_dbg_mode == (u1)1)
    {
        u2s_hsrob_auxdcthng_cnt = u2g_dbg_write_hsrob_auxdcthng_cnt;
    }"
            $write_data_file10_N2 = $write_data_file10_before + $src_file_id_N2 + $write_data_file10_after
            $src_file_id_N3 = 
"   /* u2s_hsrob_soldc1winor_cnt�X�V���� */
    if(u1g_dbg_mode == (u1)1)
    {
        u2s_hsrob_soldc1winor_cnt = u2g_dbg_write_hsrob_soldc1winor_cnt;
    }"
            $write_data_file10_N3 = $write_data_file10_before + $src_file_id_N3 + $write_data_file10_after

            $src_file_id_N4_before = $write_data_file10_before
            $src_file_id_N4_before += ,"#if 0"

            $src_file_id_N4_after = 
"#endif
        /* RoB���������X�V��~���� */
        if(u1g_dbg_mode == (u1)1)
        {
            /* �X�V�����Ȃ� */
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
        /* RoB���������X�V��~���� */
        if(u1g_dbg_mode == (u1)1)
        {
            /* �X�V�����Ȃ� */
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
    /* RoB���������X�V��~���� */
    if(u1g_dbg_mode == (u1)1)
    {
        /* �X�V�����Ȃ� */
    }
    else
    {
        u2s_hsrob_soldc1winor_cnt = u2t_tmp;
        u2g_dbg_write_hsrob_soldc1winor_cnt = u2t_tmp; /* ����pRAM�㏑������ */
    }
"
            $src_file_id_N6_after +=, $write_data_file10_after

            $src_file_id_N7_before = $write_data_file10_before
            $src_file_id_N7_before += ,"#if 0"

            $src_file_id_N7_after = 
"#endif
    /* RoB���������X�V��~���� */
    if(u1g_dbg_mode == (u1)1)
    {
        /* �X�V�����Ȃ� */
    }
    else
    {
        u2s_hsrob_auxdcthng_cnt = u2t_tmp3;
        u2g_dbg_write_hsrob_auxdcthng_cnt = u2t_tmp3; /* ����pRAM�㏑������ */
    }
"
            $src_file_id_N7_after += ,$set_title_end
    


#�ꎞ�t�@�C���̍쐬
            if (Test-Path($file10_PATH + ".new")) {
                Remove-Item ($file10_PATH + ".new")
            }
            $src_file = Get-Content $file10_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("u1 u1g_hsrob_xsolgnstp_ddc;       /* m=hsrob, lsb=1, ofs=0, unit=-:SOL���d��艺��(DDC)RoB */")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
            #�����ݓ��e
            $write_data_file11 = $write_data_file11_before + $src_file_id + $write_data_file11_after 
            
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file11_PATH + ".new")) {
                Remove-Item ($file11_PATH + ".new")
            }
            $src_file = Get-Content $file11_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
                if ($line.Contains("#if ( JGVARI == 1000 )") -and $num -eq 116) {
                        $is_target_section = $true
                        #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                        # |�����̈Ӗ��F�p�C�v���C��
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
                # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#elif ( JGVARI == 1100 )") -and $num -eq 120 ) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
"u4 u4g_dbg_write_wnmrewkup_cwkupcnt;      /* RAM�l����pRAM(u4s_wnmrewkup_cwkupcnt) */
u1 u1g_dbg_write_wnmrewkup_wkupcnt;       /* RAM�l����pRAM(u1s_wnmrewkup_wkupcnt) */"
            #�����ݓ��e
            $write_data_file12_N1 = $write_data_file12_before + $src_file_id_N1 + $write_data_file12_after
            $src_file_id_N2 =
"   /* �X�V���� */
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
            /* RoB���������X�V��~���� */
            if(u1g_dbg_mode == (u1)1)
            {
                /* �X�V�����Ȃ� */
            }
            else
            {
                u4s_wnmrewkup_cwkupcnt = u4g_gladdst_u4u4( u4s_wnmrewkup_cwkupcnt, (u4)1 );               /* �E�F�C�N�A�b�v�J�E���^�J�E���g�A�b�v */
            }
"
            $src_file_id_N3_after += ,$set_title_end

            $src_file_id_N4_before = $write_data_file12_before
            $src_file_id_N4_before += ,"#if 0"

            $src_file_id_N4_after = 
"#endif
            /* RoB���������X�V��~���� */
            if(u1g_dbg_mode == (u1)1)
                    {
                        /* �X�V�����Ȃ� */
                    }
                    else
                    {
                        u1s_wnmrewkup_wkupcnt = u1g_gladdst_u1u1( u1s_wnmrewkup_wkupcnt, (u1)1 );    /* �E�F�C�N�A�b�v�񐔃J�E���g�A�b�v */
                    }
"
            $src_file_id_N4_after += ,$set_title_end

            $src_file_id_N5_before = $write_data_file12_before
            $src_file_id_N5_before += ,"#if 0"

            $src_file_id_N5_after = 
"#endif
            /* RoB���������X�V��~���� */
            if(u1g_dbg_mode == (u1)1)
            {
                /* �X�V�����Ȃ� */
            }
            else
            {
                u1s_wnmrewkup_wkupcnt = (u1)0;                                                    /* �E�F�C�N�A�b�v�񐔃N���A */
                u4s_wnmrewkup_cwkupcnt = (u4)0;                                                   /* �E�F�C�N�A�b�v�J�E���^�N���A */
            }
"
            $src_file_id_N5_after += ,$set_title_end

            $src_file_id_N6_before = $write_data_file12_before
            $src_file_id_N6_before += ,"#if 0"

            $src_file_id_N6_after = 
"#endif
            /* RoB���������X�V��~���� */
            if(u1g_dbg_mode == (u1)1)
            {
                /* �X�V�����Ȃ� */
            }
            else
            {
                vdg_cboshtif_slp_enable( u2g_OBD_WROBGRP_SLPID );                                     /* �X���[�v���v�� */
            }
"
            $src_file_id_N6_after += ,$set_title_end

            $src_file_id_N7_before = $write_data_file12_before
            $src_file_id_N7_before += ,"#if 0"

            $src_file_id_N7_after = 
"#endif
            /* RoB���������X�V��~���� */
            if(u1g_dbg_mode == (u1)1)
            {
                /* �X�V�����Ȃ� */
            }
            else
            {
                vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_REWKUP, (u4)0U );                             /* ���Z�b�g�v�� */
            }
"
            $src_file_id_N7_after += ,$set_title_end


            $src_file_id_N8 =
"
    /* �X�V���� */
if(u1g_dbg_mode == (u1)0)
    {
        u4g_dbg_write_wnmrewkup_cwkupcnt = u4s_wnmrewkup_cwkupcnt;
        u1g_dbg_write_wnmrewkup_wkupcnt = u1s_wnmrewkup_wkupcnt;
    }"
            $write_data_file12_N8 = $write_data_file12_before + $src_file_id_N8 + $write_data_file12_after

#�ꎞ�t�@�C���̍쐬
            if (Test-Path($file12_PATH + ".new")) {
                Remove-Item ($file12_PATH + ".new")
            }
            $src_file = Get-Content $file12_PATH 
            
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#define u1s_wnmrewkup_num       (sts_wnmrewkup_data.u1_num)")) {
                    $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
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
            elseif ($line.Contains(" u1s_wnmrewkup_wkupcnt = u1g_gladdst_u1u1( u1s_wnmrewkup_wkupcnt, (u1)1 );     /* �E�F�C�N�A�b�v�񐔃J�E���g�A�b�v */")) {
                $is_target_section = $true
                $src_file_id_N4_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $src_file_id_N4_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u1s_wnmrewkup_wkupcnt = (u1)0;                                                    /* �E�F�C�N�A�b�v�񐔃N���A */")) {
                $is_target_section = $true
                $src_file_id_N5_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("u4s_wnmrewkup_cwkupcnt = (u4)0;                                                   /* �E�F�C�N�A�b�v�J�E���^�N���A */")) {
                $is_target_section = $true
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $src_file_id_N5_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file12_PATH + ".new") -Append
                $is_target_section = $false
                }
            elseif ($line.Contains("vdg_cboshtif_slp_enable( u2g_OBD_WROBGRP_SLPID );                                     /* �X���[�v���v�� */")) {
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
            elseif ($line.Contains("(void)s4g_cmemif_write( u4g_WNMREWKUP_DATA_ST_MID, (void *)&sts_wnmrewkup_data );                 /* �E�F�C�N�A�b�v�J�E���^�A�v���A�E�F�C�N�A�b�v�񐔁A���o�����ԁA�v���������� */ /* �߂�l�͎g�p���Ȃ� */")) {
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
"u4 u4g_dbg_write_wnmslpng_cslpngcnt;      /* RAM�l����pRAM(u4s_wnmslpng_cslpngcnt) */
u1 u1g_dbg_write_aplawkfctigb;            /* RAM�l����pRAM(u1t_aplawkfctigb) */"
            #�����ݓ��e
            $write_data_file13_N1 = $write_data_file13_before + $src_file_id_N1 + $write_data_file13_after


            $src_file_id_N2_before = $write_data_file13_before
            $src_file_id_N2_before += ,"#if 0"
            $src_file_id_N2_after = 
"#endif
    /* RoB���������X�V��~���� */
    if(u1g_dbg_mode == (u1)1)
    {
        u4s_wnmslpng_cslpngcnt = u4g_dbg_write_wnmslpng_cslpngcnt;
        u1t_aplawkfctigb = u1g_dbg_write_aplawkfctigb;
    }
    else
    {
        u1t_aplawkfctigb = ( u1t_aplawkfct & u1g_CCANIF_APLAWKFCT_IGBRQON );                  /* �A�E�F�C�N�v����IGB�v��ON�Ń}�X�N */
    }
"
            $src_file_id_N2_after += ,$set_title_end

            $src_file_id_N3_before = $write_data_file13_before
            $src_file_id_N3_before += ,"#if 0"
            $src_file_id_N3_after = 
"#endif
    /* RoB���������X�V��~���� */
    if(u1g_dbg_mode == (u1)1)
    {
        /* �X�V�����Ȃ� */
    }
    else
    {
        u4s_wnmslpng_cslpngcnt = u4g_gladdst_u4u4( u4s_wnmslpng_cslpngcnt, (u4)1 ); /* �X���[�vNG�J�E���^�J�E���g�A�b�v */
    }
"
            $src_file_id_N3_after += ,$set_title_end

            $src_file_id_N4_before = $write_data_file13_before
            $src_file_id_N4_before += ,"#if 0"
            $src_file_id_N4_after = 
"#endif
    /* RoB���������X�V��~���� */
    if(u1g_dbg_mode == (u1)1)
    {
        /* �X�V�����Ȃ� */
    }
    else
    {
        u4s_wnmslpng_cslpngcnt = (u4)0;                                           /* �X���[�vNG�J�E���^�N���A */
    }
"
            $src_file_id_N4_after += ,$set_title_end

            $src_file_id_N5_before = $write_data_file13_before
            $src_file_id_N5_before += ,"#if 0"
            $src_file_id_N5_after = 
"#endif
            /* RoB���������X�V��~���� */
            if(u1g_dbg_mode == (u1)1)
            {
                /* �X�V�����Ȃ� */
            }
            else
            {
                vdg_cboshtif_slp_enable( u2g_OBD_WROBGRP_SLPID );                         /* �X���[�v���v�� */
            }
"
            $src_file_id_N5_after += ,$set_title_end

            $src_file_id_N6_before = $write_data_file13_before
            $src_file_id_N6_before += ,"#if 0"
            $src_file_id_N6_after = 
"#endif
            /* RoB���������X�V��~���� */
            if(u1g_dbg_mode == (u1)1)
            {
                /* �X�V�����Ȃ� */
            }
            else
            {
                vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_SLPNG, (u4)0U );                  /* ���Z�b�g�v�� */
            }
"
            $src_file_id_N6_after += ,$set_title_end

            $src_file_id_N7 = 
"   /* �X�V���� */
    if(u1g_dbg_mode == (u1)0)
    {
        u4g_dbg_write_wnmslpng_cslpngcnt = u4s_wnmslpng_cslpngcnt;
        u1g_dbg_write_aplawkfctigb = u1t_aplawkfctigb;
    }"
            #�����ݓ��e
            $write_data_file13_N7 = $write_data_file13_before + $src_file_id_N7 + $write_data_file13_after




#�ꎞ�t�@�C���̍쐬
            if (Test-Path($file13_PATH + ".new")) {
                Remove-Item ($file13_PATH + ".new")
            }
            $src_file = Get-Content $file13_PATH 
            
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("u1 u1g_wnmslpng_factor;")) {
                    $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
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
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
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
"u4 u4g_dbg_write_wslprewkup_cwkupcnt;        /* RAM�l����pRAM(u4s_wslprewkup_cwkupcnt) */
u1 u1g_dbg_write_wslprewkup_wkupcnt;         /* RAM�l����pRAM(u1s_wslprewkup_wkupcnt) */"
        #�����ݓ��e
        $write_data_file14_N1 = $write_data_file14_before + $src_file_id_N1 + $write_data_file14_after

        $src_file_id_N2 = 
"   /* �X�V���� */
    if(u1g_dbg_mode == (u1)1)
    {
        u4s_wslprewkup_cwkupcnt = u4g_dbg_write_wslprewkup_cwkupcnt;
        u1s_wslprewkup_wkupcnt = u1g_dbg_write_wslprewkup_wkupcnt;
    }"
        #�����ݓ��e
        $write_data_file14_N2 = $write_data_file14_before + $src_file_id_N2 + $write_data_file14_after

        $src_file_id_N3_before = $write_data_file14_before
        $src_file_id_N3_before += ,"#if 0"
        $src_file_id_N3_after = 
"#endif
            /* RoB���������X�V��~���� */
            if(u1g_dbg_mode == (u1)1)
            {
                /* �X�V�����Ȃ� */
            }
            else
            {
                u4s_wslprewkup_cwkupcnt = u4g_gladdst_u4u4( u4s_wslprewkup_cwkupcnt, (u4)1 );           /* �E�F�C�N�A�b�v�J�E���^�J�E���g�A�b�v */
            }
"
        $src_file_id_N3_after += ,$set_title_end


        $src_file_id_N4_before = $write_data_file14_before
        $src_file_id_N4_before += ,"#if 0"
        $src_file_id_N4_after = 
"#endif
                        /* RoB���������X�V��~���� */
                        if(u1g_dbg_mode == (u1)1)
                        {
                            /* �X�V�����Ȃ� */
                        }
                        else
                        {
                            u1s_wslprewkup_wkupcnt = u1g_gladdst_u1u1( u1s_wslprewkup_wkupcnt, (u1)1 );     /* �E�F�C�N�A�b�v�񐔃J�E���g�A�b�v */
                        }
"
        $src_file_id_N4_after += ,$set_title_end
        
        $src_file_id_N5_before = $write_data_file14_before
        $src_file_id_N5_before += ,"#if 0"
        $src_file_id_N5_after = 
"#endif
                    /* RoB���������X�V��~���� */
                    if(u1g_dbg_mode == (u1)1)
                    {
                        /* �X�V�����Ȃ� */
                    }
                    else
                    {
                        u1s_wslprewkup_wkupcnt = (u1)0;                                                 /* �E�F�C�N�A�b�v�񐔃N���A */
                        u4s_wslprewkup_cwkupcnt = (u4)0;                                                /* �E�F�C�N�A�b�v�J�E���^�N���A */
                    }
"
        $src_file_id_N5_after += ,$set_title_end

        $src_file_id_N6_before = $write_data_file14_before
        $src_file_id_N6_before += ,"#if 0"
        $src_file_id_N6_after = 
"#endif
                /* RoB���������X�V��~���� */
                if(u1g_dbg_mode == (u1)1)
                {
                    /* �X�V�����Ȃ� */
                }
                else
                {
                    vdg_cboshtif_slp_enable( u2g_OBD_WROBGRP_SLPID );                               /* �X���[�v���v�� */
                }
"
        $src_file_id_N6_after += ,$set_title_end

        $src_file_id_N7_before = $write_data_file14_before
        $src_file_id_N7_before += ,"#if 0"
        $src_file_id_N7_after = 
"#endif
                /* RoB���������X�V��~���� */
                if(u1g_dbg_mode == (u1)1)
                {
                    /* �X�V�����Ȃ� */
                }
                else
                {
                    vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_REWKUP, (u4)0U );                           /* ���Z�b�g�v�� */
                }
"
        $src_file_id_N7_after += ,$set_title_end

        $src_file_id_N8 = 
"   /* �X�V���� */
    if(u1g_dbg_mode == (u1)0)
    {
        u4g_dbg_write_wslprewkup_cwkupcnt = u4s_wslprewkup_cwkupcnt;
        u1g_dbg_write_wslprewkup_wkupcnt = u1s_wslprewkup_wkupcnt;
    }"
        #�����ݓ��e
        $write_data_file14_N8 = $write_data_file14_before + $src_file_id_N8 + $write_data_file14_after


#�ꎞ�t�@�C���̍쐬
        if (Test-Path($file14_PATH + ".new")) {
            Remove-Item ($file14_PATH + ".new")
        }
        $src_file = Get-Content $file14_PATH 
        
        [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
        [double]$num = 1  
        foreach ($line in $src_file) {
                # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                # �����Ώۂ̏I���s����͂��̂܂܏o��
        if ($line.Contains("#define u1s_wslprewkup_num       (sts_wslprewkup_data.u1_num)")) {
            $is_target_section = $true
            #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
            # |�����̈Ӗ��F�p�C�v���C��
            $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append 
            $write_data_file14_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file14_PATH + ".new") -Append   
            $is_target_section = $false
            }
        elseif ($line.Contains("u1 u1t_i;                       /* ���[�v�J�E���^ */")) {
            $is_target_section = $true
            #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
            # |�����̈Ӗ��F�p�C�v���C��
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
"u4 u4g_dbg_write_wslpslpng_cslpngcnt;               /* RAM�l����pRAM(u4s_wslpslpng_cslpngcnt) */"
            #�����ݓ��e
            $write_data_file15_N1 = $write_data_file15_before + $src_file_id_N1 + $write_data_file15_after

            $src_file_id_N2 = 
"   /* �X�V���� */
    if(u1g_dbg_mode == (u1)1)
    {
        u4s_wslpslpng_cslpngcnt = u4g_dbg_write_wslpslpng_cslpngcnt;
    }"
            #�����ݓ��e
            $write_data_file15_N2 = $write_data_file15_before + $src_file_id_N2 + $write_data_file15_after

            $src_file_id_N3_before = $write_data_file15_before
            $src_file_id_N3_before += ,"#if 0"
            $src_file_id_N3_after = 
"#endif
            /* RoB���������X�V��~���� */
            if(u1g_dbg_mode == (u1)1)
            {
                /* �X�V�����Ȃ� */
            }
            else
            {
                u4s_wslpslpng_cslpngcnt = u4g_gladdst_u4u4( u4s_wslpslpng_cslpngcnt, (u4)1 );   /* �X���[�vNG�J�E���^�J�E���g�A�b�v */
            }
"
            $src_file_id_N3_after += ,$set_title_end

            $src_file_id_N4_before = $write_data_file15_before
            $src_file_id_N4_before += ,"#if 0"
            $src_file_id_N4_after = 
"#endif
            /* RoB���������X�V��~���� */
            if(u1g_dbg_mode == (u1)1)
            {
                /* �X�V�����Ȃ� */
            }
            else
            {
                u4s_wslpslpng_cslpngcnt = (u4)0;                                            /* �X���[�vNG�p�����ԃJ�E���^�N���A */
            }
"
            $src_file_id_N4_after += ,$set_title_end

            $src_file_id_N5_before = $write_data_file15_before
            $src_file_id_N5_before += ,"#if 0"
            $src_file_id_N5_after = 
"#endif
            /* RoB���������X�V��~���� */
            if(u1g_dbg_mode == (u1)1)
            {
                /* �X�V�����Ȃ� */
            }
            else
            {
                vdg_cboshtif_slp_enable( u2g_OBD_WROBGRP_SLPID );                           /* �X���[�v���v�� */
            }
"
            $src_file_id_N5_after += ,$set_title_end

            $src_file_id_N6_before = $write_data_file15_before
            $src_file_id_N6_before += ,"#if 0"
            $src_file_id_N6_after = 
"#endif
            /* RoB���������X�V��~���� */
            if(u1g_dbg_mode == (u1)1)
            {
                /* �X�V�����Ȃ� */
            }
            else
            {
                vdg_spp_sesysif_syserr( u2g_SPP_SESYSIF_SLPNG, (u4)0U );                    /* ���Z�b�g�v�� */
            }
"
            $src_file_id_N6_after += ,$set_title_end

            $src_file_id_N7 = 
"   /* �X�V���� */
    if(u1g_dbg_mode == (u1)0)
    {
        u4g_dbg_write_wslpslpng_cslpngcnt = u4s_wslpslpng_cslpngcnt;
    }"
            #�����ݓ��e
            $write_data_file15_N7 = $write_data_file15_before + $src_file_id_N7 + $write_data_file15_after


        #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file15_PATH + ".new")) {
                Remove-Item ($file15_PATH + ".new")
            }
            $src_file = Get-Content $file15_PATH 
            
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("u1 u1g_wslpslpng_factor;")) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append 
                $write_data_file15_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file15_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($line.Contains("u1 u1t_xnochg;")) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
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
            elseif ($line.Contains("u4s_wslpslpng_cslpngcnt = (u4)0;                                            /* �X���[�vNG�p�����ԃJ�E���^�N���A */")) {
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
        Write-Host "�\�t�gD��������"
        Write-Host "�\�[�X��ۑ���--------"
        Copy-Item "..\..\main_micro\sources\" "kaizoD" -Recurse -Force
        Write-Host "�����\�t�gD�̃r���h�J�n�������܂��B"
        Start-Process -Filepath "test_build.bat" -Wait -NoNewWindow 
        Write-Host "�����\�t�gD�̃r���h���ʕ�(Rom�t�H���_)��ۑ����Ă��܂��B"
        Copy-Item $Target_PATH "kaizoD" -Recurse -Force
        #�t�@�C���𕜌�
        Remove-Item "..\..\main_micro\sources" -Recurse
        Copy-Item  "kaizoA\" "..\..\main_micro\sources" -Recurse -Force
        Write-Host "===================================================================="
        Write-Host "| �����\�t�gD��Ƃ��I���܂����B|"
        Write-Host "====================================================================" 
    }
    function kaizo_E {
        Write-Host "===================================================================="
        Write-Host "| �����\�t�gE��Ƃ��J�n���܂��B|"
        Write-Host "===================================================================="     
        # sources�t�H���_�̃p�X
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
/* �f�o�b�N���[�h�ؑ֏���(1_2_3�ȊO�F�ʏ퐧��_1�FRAMWrite�L�����[�h(���x�Z���T)_2�FRAMWrite�L�����[�h(AMD)_3�FRAMWrite�L�����[�h(DCHB))) */
    if(u1g_dbg_mode == (u1)2)
    {
        /* �X�V�����Ȃ� */
    }
    else
    {                    
        s2g_aamd_vamd       = s2t_vamd;
    }
"
            $src_file_id_N1_after += ,$set_title_end
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file1_PATH + ".new")) {
                Remove-Item ($file1_PATH + ".new")
            }
            $src_file = Get-Content $file1_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("s2g_aamd_vamd       = s2t_vamd;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
/* �f�o�b�N���[�h�ؑ֏���(1_2_3�ȊO�F�ʏ퐧��_1�FRAMWrite�L�����[�h(���x�Z���T)_2�FRAMWrite�L�����[�h(AMD)_3�FRAMWrite�L�����[�h(DCHB))) */
    if(u1g_dbg_mode == (u1)1)        /* 1�FRAMWrite�L�����[�h */
    {
        /* �X�V�����Ȃ� */
    }
    else                                     /* 0�F�ʏ폈�� */
    {
        s2g_aauxtmp_tddc1    = s2t_tddc1;
        s2g_aauxtmp_tddc2    = s2t_tddc2;
        s2g_aauxtmp_tddc3    = s2t_tddc3;
    }
"
            $src_file_id_N2_after += ,$set_title_end
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file2_PATH + ".new")) {
                Remove-Item ($file2_PATH + ".new")
            }
            $src_file = Get-Content $file2_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("u2g_aauxtmp_tddc3_ad = u2t_tddc3_ad;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                    $src_file_id_N2_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
            elseif ($line.Contains("s2g_aauxtmp_tddc3    = s2t_tddc3;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C�� 
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
                /* �X�V�����Ȃ� */
            }
            else
            {                    
                /* �[�q�̉ߓd���M����Ԃ�`�g����`�h�ɐݒ� */
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
                /* �X�V�����Ȃ� */
            }
            else
            {                    
                /* �[�q�̉ߓd���M����Ԃ�`�g�L��������`�h�ɐݒ� */
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
                /* �X�V�����Ȃ� */
            }
            else
            {                    
                /* �[�q�̉ߓd���M����Ԃ�`�g�L��������`�h�ɐݒ� */
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
                /* �X�V�����Ȃ� */
            }
            else
            {                    
                /* �[�q�̉ߓd���M����Ԃ�`�g�L�����ߓd��`�h�ɐݒ� */
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
                /* �X�V�����Ȃ� */
            }
            else
            {                    
                /* �[�q�̉ߓd���M����Ԃ�`�g����`�h�ɐݒ� */
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
                /* �X�V�����Ȃ� */
            }
            else
            {                    
                /* OV_DC4�[�q�̉ߓd���M����Ԃ�`�g����`�h�ɐݒ� */
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
                /* �X�V�����Ȃ� */
            }
            else
            {                    
                /* OV_DC4�[�q�̉ߓd���M����Ԃ�`�g�L�����ߓd��`�h�ɐݒ� */
                stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_ON;
            }
"
            $src_file_id_N7_after += ,$set_title_end
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file3_PATH + ".new")) {
                Remove-Item ($file3_PATH + ".new")
            }
            $src_file = Get-Content $file3_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($num -eq 184) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $src_file_id_N1_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append      
                    $is_target_section = $false
                    }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_DISABLE;") -and $num -eq 185) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C�� 
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                    $src_file_id_N1_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                    $is_target_section = $false
            }
            elseif ($num -eq 192) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $src_file_id_N2_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_OFF;") -and $num -eq 193) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $src_file_id_N2_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                $is_target_section = $false
        }
            elseif ($num -eq 224) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $src_file_id_N3_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_OFF;") -and $num -eq 225) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $src_file_id_N3_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                $is_target_section = $false
        }
            elseif ($num -eq 232) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $src_file_id_N4_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_ON ;") -and $num -eq 233) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $src_file_id_N4_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                $is_target_section = $false
        }
            elseif ($num -eq 247) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $src_file_id_N5_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_DISABLE;") -and $num -eq 248) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $src_file_id_N5_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                $is_target_section = $false
        }
            elseif ($num -eq 292) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $src_file_id_N6_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_DISABLE;") -and $num -eq 293) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $src_file_id_N6_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append   
                $is_target_section = $false
        }
            elseif ($num -eq 297) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $src_file_id_N7_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file3_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_abstddcov_lch.u1_latch = (u1)u1s_ABSTDDCOV_ON;") -and $num -eq 298) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
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
/* �f�o�b�N���[�h�ؑ֏���(1_2_3�ȊO�F�ʏ퐧��_1�FRAMWrite�L�����[�h(���x�Z���T)_2�FRAMWrite�L�����[�h(AMD)_3�FRAMWrite�L�����[�h(DCHB)))*/
    if(u1g_dbg_mode == (u1)1)
    {
        /* �X�V�����Ȃ� */
    }
    else
    {
        s2g_absttmp_tddc    = s2t_tddc;
    }
"
            $src_file_id_N1_after += ,$set_title_end
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file4_PATH + ".new")) {
                Remove-Item ($file4_PATH + ".new")
            }
            $src_file = Get-Content $file4_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("s2g_absttmp_tddc    = s2t_tddc;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
/* �f�o�b�N���[�h�ؑ֏���(1_2_3�ȊO�F�ʏ퐧��_1�FRAMWrite�L�����[�h(���x�Z���T)_2�FRAMWrite�L�����[�h(AMD)_3�FRAMWrite�L�����[�h(DCHB))) */
    if(u1g_dbg_mode == (u1)3)
    {
        /* �X�V�����Ȃ� */
    }
    else
    {
        s2g_adrvbat_vdchb     = s2t_vdchb;
    }
"
            $src_file_id_N1_after += ,$set_title_end
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file5_PATH + ".new")) {
                Remove-Item ($file5_PATH + ".new")
            }
            $src_file = Get-Content $file5_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("s2g_adrvbat_vdchb     = s2t_vdchb;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
                /* �X�V�����Ȃ� */
            }
            else
            {
                /* �[�q�̒��ԓd������l���o�M����Ԃ�`�g����`�h�ɐݒ� */
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
                /* �X�V�����Ȃ� */
            }
            else
            {
                /* �[�q�̒��ԓd������l���o�M����Ԃ�`�g�L��������`�h�ɐݒ� */
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
                /* �X�V�����Ȃ� */
            }
            else
            {
                /* �[�q�̒��ԓd������l���o�M����Ԃ�`�g�L��������`�h�ɐݒ� */
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
        /* �X�V�����Ȃ� */
    }
    else
    {
        /* �[�q�̒��ԓd������l���o�M����Ԃ�`�g�L�����ߓd��`�h�ɐݒ� */
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
                /* �X�V�����Ȃ� */
            }
            else
            {
                /* �[�q�̒��ԓd������l���o�M����Ԃ�`�g����`�h�ɐݒ� */
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
                /* �X�V�����Ȃ� */
            }
            else
            {
                /* LV_MID�[�q�̒��ԓd������l���o�M����Ԃ�`�g����`�h�ɐݒ� */
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
                /* �X�V�����Ȃ� */
            }
            else
            {
                /* LV_MID�[�q�̒��ԓd������l���o�M����Ԃ�`�g�L�����ߓd��`�h�ɐݒ� */
                stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_ON;
            }
"
            $src_file_id_N7_after += ,$set_title_end  




            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file6_PATH + ".new")) {
                Remove-Item ($file6_PATH + ".new")
            }
            $src_file = Get-Content $file6_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($num -eq 179) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $src_file_id_N1_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append      
                    $is_target_section = $false
                    }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_DISABLE;") -and $num -eq 180) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C�� 
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                    $src_file_id_N1_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append   
                    $is_target_section = $false
            }
            elseif ($num -eq 187) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $src_file_id_N2_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_OFF;") -and $num -eq 188) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $src_file_id_N2_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($num -eq 220) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $src_file_id_N3_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_OFF;") -and $num -eq 221) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $src_file_id_N3_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($num -eq 228) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $src_file_id_N4_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_ON ;") -and $num -eq 229) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $src_file_id_N4_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($num -eq 243) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $src_file_id_N5_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_DISABLE;") -and $num -eq 244) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $src_file_id_N5_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($num -eq 280) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $src_file_id_N6_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_DISABLE;") -and $num -eq 281) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $src_file_id_N6_after| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($num -eq 285) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
                $src_file_id_N7_before| %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append  
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file6_PATH + ".new") -Append 
                $is_target_section = $false
        }
            elseif ($line.Contains("stg_alvmid_lch.u1_latch = (u1)u1s_ALVMID_ON;") -and $num -eq 286) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C�� 
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
"u1 u1g_dbg_mode;            /* �f�o�b�N���[�h�ؑ֗p�t���O(1_2_3�ȊO�F�ʏ퐧��_1�FRAMWrite�L�����[�h(���x�Z���T)_2�FRAMWrite�L�����[�h(AMD)_3�FRAMWrite�L�����[�h(DCHB))) */"

            $write_data_file7_N1 = $write_data_file7_before + $src_file_id_N1 +  $write_data_file7_after
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file7_PATH + ".new")) {
                Remove-Item ($file7_PATH + ".new")
            }
            $src_file = Get-Content $file7_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("u1 u1g_apllmng_cnt_4sl;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
/* �f�o�b�N���[�h�ؑ֏���(1_2_3�ȊO�F�ʏ퐧��_1�FRAMWrite�L�����[�h(���x�Z���T)_2�FRAMWrite�L�����[�h(AMD)_3�FRAMWrite�L�����[�h(DCHB))) */
    if(u1g_dbg_mode == (u1)1)
    {
        /* �X�V�����Ȃ� */
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
/* �f�o�b�N���[�h�ؑ֏���(1_2_3�ȊO�F�ʏ퐧��_1�FRAMWrite�L�����[�h(���x�Z���T)_2�FRAMWrite�L�����[�h(AMD)_3�FRAMWrite�L�����[�h(DCHB))) */
    if(u1g_dbg_mode == (u1)1)
    {
        /* �X�V�����Ȃ� */
    }
    else
    {
        s2g_asoltmp_tddc2    = s2t_tddc2;
    }
"
            $src_file_id_N2_after += ,$set_title_end
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file8_PATH + ".new")) {
                Remove-Item ($file8_PATH + ".new")
            }
            $src_file = Get-Content $file8_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
                if ($line.Contains("s2g_asoltmp_tddc1    = s2t_tddc1;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $src_file_id_N1_before | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append  
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append 
                    $src_file_id_N1_after | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file8_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
                elseif ($line.Contains("s2g_asoltmp_tddc2    = s2t_tddc2;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
"extern u1 u1g_dbg_mode;              /* �f�o�b�N���[�h�ؑ֗p�t���O(1_2_3�ȊO�F�ʏ퐧��_1�FRAMWrite�L�����[�h(���x�Z���T)_2�FRAMWrite�L�����[�h(AMD)_3�FRAMWrite�L�����[�h(DCHB))) */"

            $write_data_file9_N1 = $write_data_file9_before + $src_file_id_N1 +  $write_data_file9_after
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file9_PATH + ".new")) {
                Remove-Item ($file9_PATH + ".new")
            }
            $src_file = Get-Content $file9_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
        
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#endif  /* COMMON_H */")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
            #�����ݓ��e
            $write_data_file10 = $write_data_file10_before + $src_file_id + $write_data_file10_after 
            
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file10_PATH + ".new")) {
                Remove-Item ($file10_PATH + ".new")
            }
            $src_file = Get-Content $file10_PATH
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
                if ($line.Contains("#if ( JGVARI == 1000 )")) {
                        $is_target_section = $true
                        #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                        # |�����̈Ӗ��F�p�C�v���C��
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
                # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#elif ( JGVARI == 1100 )")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
            #�����ݓ��e
            $write_data_file11 = $write_data_file11_before + $src_file_id + $write_data_file11_after 
            
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file11_PATH + ".new")) {
                Remove-Item ($file11_PATH + ".new")
            }
            $src_file = Get-Content $file11_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
                if ($line.Contains("#if ( JGVARI == 1000 )") -and $num -eq 116) {
                        $is_target_section = $true
                        #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                        # |�����̈Ӗ��F�p�C�v���C��
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
                # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#elif ( JGVARI == 1100 )") -and $num -eq 120 ) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
        Write-Host "�\�t�gE��������"
        Write-Host "�\�[�X��ۑ���--------"
        Copy-Item "..\..\main_micro\sources\" "kaizoE" -Recurse -Force
        Write-Host "�����\�t�gE�̃r���h�J�n�������܂��B"
        Start-Process -Filepath "test_build.bat" -Wait -NoNewWindow 
        Write-Host "�����\�t�gE�̃r���h���ʕ�(Rom�t�H���_)��ۑ����Ă��܂��B"
        Copy-Item $Target_PATH "kaizoE" -Recurse -Force
        #�t�@�C���𕜌�
        Remove-Item "..\..\main_micro\sources" -Recurse
        Copy-Item  "kaizoA\" "..\..\main_micro\sources" -Recurse -Force
        Write-Host "===================================================================="
        Write-Host "| �����\�t�gE��Ƃ��I���܂����B|"
        Write-Host "===================================================================="   
    }

    function kaizo_F {
        Write-Host "===================================================================="
        Write-Host "| �����\�t�gF��Ƃ��J�n���܂��B|"
        Write-Host "===================================================================="     
        # sources�t�H���_�̃p�X
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
            #�����ݓ��e
            $write_data_file1 = $write_data_file1_before + $src_file_id + $write_data_file1_after 
            
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file1_PATH + ".new")) {
                Remove-Item ($file1_PATH + ".new")
            }
            $src_file = Get-Content $file1_PATH
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
                if ($line.Contains("#if ( JGVARI == 1000 )")) {
                        $is_target_section = $true
                        #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                        # |�����̈Ӗ��F�p�C�v���C��
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
                # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#elif ( JGVARI == 1100 )")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
"volatile u4 u4g_dbg_cnt_hsolmng_pwon;          /* �֐�(vdg_hsolmng_pwon)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_hsolmng_pwonwup;       /* �֐�(vdg_hsolmng_pwonwup)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_hsolmng_func_reigon;   /* �֐�(vdg_hsolmng_func_reigon)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_hsolmng_func_4msm;     /* �֐�(vdg_hsolmng_func_4msm)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_hsolmng_func_8msl;     /* �֐�(vdg_hsolmng_func_8msl)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_hsolmng_func_adend;    /* �֐�(vdg_hsolmng_func_adend)�R�[���m�F�p�J�E���^ */"
            $write_data_file2_N1 = $write_data_file2_before + $src_file_id_N1 + $write_data_file2_after

            $src_file_id_N2 =
"   if(u4g_dbg_cnt_hsolmng_pwon < u4g_U4MAX)
    {
        u4g_dbg_cnt_hsolmng_pwon++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_hsolmng_pwon = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file2_N2 = $write_data_file2_before + $src_file_id_N2 + $write_data_file2_after


            $src_file_id_N3 =
"   if(u4g_dbg_cnt_hsolmng_pwonwup < u4g_U4MAX)
    {
        u4g_dbg_cnt_hsolmng_pwonwup++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_hsolmng_pwonwup = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file2_N3 = $write_data_file2_before + $src_file_id_N3 + $write_data_file2_after

            $src_file_id_N4 =
"   if(u4g_dbg_cnt_hsolmng_func_reigon < u4g_U4MAX)
    {
        u4g_dbg_cnt_hsolmng_func_reigon++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_hsolmng_func_reigon = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file2_N4 = $write_data_file2_before + $src_file_id_N4 + $write_data_file2_after

            $src_file_id_N5 =
"   if(u4g_dbg_cnt_hsolmng_func_4msm < u4g_U4MAX)
    {
        u4g_dbg_cnt_hsolmng_func_4msm++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_hsolmng_func_4msm = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file2_N5 = $write_data_file2_before + $src_file_id_N5 + $write_data_file2_after

            $src_file_id_N6 =
"   if(u4g_dbg_cnt_hsolmng_func_8msl < u4g_U4MAX)
    {
        u4g_dbg_cnt_hsolmng_func_8msl++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_hsolmng_func_8msl = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file2_N6 = $write_data_file2_before + $src_file_id_N6 + $write_data_file2_after

            $src_file_id_N7 =
"   if(u4g_dbg_cnt_hsolmng_func_adend < u4g_U4MAX)
    {
        u4g_dbg_cnt_hsolmng_func_adend++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_hsolmng_func_adend = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file2_N7 = $write_data_file2_before + $src_file_id_N7 + $write_data_file2_after

            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file2_PATH + ".new")) {
                Remove-Item ($file2_PATH + ".new")
            }
            $src_file = Get-Content $file2_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  

            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("u1 u1g_hsolmng_xreigonrq;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                    $write_data_file2_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
            elseif ($num -eq 129) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                    $write_data_file2_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                    $is_target_section = $false
            }
            elseif ($line.Contains("/*������ �K�v�ɉ����Ċ֐���ǉ� ������*/") -and $num -eq 191) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                $write_data_file2_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($line.Contains("u1g_hsolmng_xreigonrq = ((u1)ON); /* ��IG�I���v������ */")) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                $write_data_file2_N4 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($line.Contains("/*������ �K�v�ɉ����Ċ֐���ǉ� ������*/") -and $num -eq 230) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                $write_data_file2_N5 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($line.Contains("vds_hsolmng_reigonrq_init();")) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append 
                $write_data_file2_N6 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file2_PATH + ".new") -Append   
                $is_target_section = $false
            }
            elseif ($num -eq 303) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
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
            $write_data_file3_after += "        #define u4s_SPP_SDBGINFO_VER ((u4)0xFF51030AU) /* �o�[�W���� */"
            $write_data_file3_after += ,$set_title_end
            if ($VARI -eq 1000) {
                $src_file_id= (Get-Content $file3_PATH -TotalCount 118)[-1]
            }else {
                $src_file_id= (Get-Content $file3_PATH -TotalCount 122)[-1]
            }
            $src_file_id = "    " + $src_file_id 
            #�����ݓ��e
            $write_data_file3 = $write_data_file3_before + $src_file_id + $write_data_file3_after 
            
            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file3_PATH + ".new")) {
                Remove-Item ($file3_PATH + ".new")
            }
            $src_file = Get-Content $file3_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
            if ($VARI -eq 1000) {
                foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
                if ($line.Contains("#if ( JGVARI == 1000 )") -and $num -eq 116) {
                        $is_target_section = $true
                        #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                        # |�����̈Ӗ��F�p�C�v���C��
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
                # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("#elif ( JGVARI == 1100 )") -and $num -eq 120 ) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
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
"volatile u4 u4g_dbg_cnt_wlmng_init;            /* �֐�(u4g_dbg_cnt_wlmng_init)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_diag_pwon;       /* �֐�(u4g_dbg_cnt_wlmng_diag_pwon)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_idle;            /* �֐�(u4g_dbg_cnt_wlmng_idle)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_1msh;            /* �֐�(u4g_dbg_cnt_wlmng_1msh)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_2msh;            /* �֐�(u4g_dbg_cnt_wlmng_2msh)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_8msh;            /* �֐�(u4g_dbg_cnt_wlmng_8msh)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_16msmh;          /* �֐�(u4g_dbg_cnt_wlmng_16msmh)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_32msmh;          /* �֐�(u4g_dbg_cnt_wlmng_32msmh)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_4msm;            /* �֐�(u4g_dbg_cnt_wlmng_4msm)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_8msm;            /* �֐�(u4g_dbg_cnt_wlmng_8msm)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_16msm;           /* �֐�(u4g_dbg_cnt_wlmng_16msm)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_32msm;           /* �֐�(u4g_dbg_cnt_wlmng_32msm)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_8msl;            /* �֐�(u4g_dbg_cnt_wlmng_8msl)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_16msl;           /* �֐�(u4g_dbg_cnt_wlmng_16msl)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_32msl;           /* �֐�(u4g_dbg_cnt_wlmng_32msl)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_65msl;           /* �֐�(u4g_dbg_cnt_wlmng_65msl)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_131msl;          /* �֐�(u4g_dbg_cnt_wlmng_131msl)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_1sl;             /* �֐�(u4g_dbg_cnt_wlmng_1sl)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_mg2ms;           /* �֐�(u4g_dbg_cnt_wlmng_mg2ms)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_mg5ms;           /* �֐�(u4g_dbg_cnt_wlmng_mg5ms)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_mg10ms;          /* �֐�(u4g_dbg_cnt_wlmng_mg10ms)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_ad2ms;           /* �֐�(u4g_dbg_cnt_wlmng_ad2ms)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_ad4ms;           /* �֐�(u4g_dbg_cnt_wlmng_ad4ms)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_ad8ms;           /* �֐�(u4g_dbg_cnt_wlmng_ad8ms)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_ne10;            /* �֐�(u4g_dbg_cnt_wlmng_ne10)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_ne30m;           /* �֐�(u4g_dbg_cnt_wlmng_ne30m)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_ne10h;           /* �֐�(u4g_dbg_cnt_wlmng_ne10h)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_ne10m;           /* �֐�(u4g_dbg_cnt_wlmng_ne10m)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_drvclchg;        /* �֐�(u4g_dbg_cnt_wlmng_drvclchg)�R�[���m�F�p�J�E���^ */
volatile u4 u4g_dbg_cnt_wlmng_drvclchgwch;     /* �֐�(u4g_dbg_cnt_wlmng_drvclchgwch)�R�[���m�F�p�J�E���^ */"
            $write_data_file4_N1 = $write_data_file4_before + $src_file_id_N1 + $write_data_file4_after

            $src_file_id_N2 =
"   if(u4g_dbg_cnt_wlmng_init < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_init++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_init = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N2 = $write_data_file4_before + $src_file_id_N2 + $write_data_file4_after

            $src_file_id_N3 =
"   if(u4g_dbg_cnt_wlmng_diag_pwon < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_diag_pwon++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_diag_pwon = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N3 = $write_data_file4_before + $src_file_id_N3 + $write_data_file4_after

            $src_file_id_N4 =
"   if(u4g_dbg_cnt_wlmng_idle < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_idle++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_idle = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N4 = $write_data_file4_before + $src_file_id_N4 + $write_data_file4_after

            $src_file_id_N5 =
"   if(u4g_dbg_cnt_wlmng_1msh < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_1msh++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_1msh = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N5 = $write_data_file4_before + $src_file_id_N5 + $write_data_file4_after

            $src_file_id_N6 =
"   if(u4g_dbg_cnt_wlmng_2msh < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_2msh++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_2msh = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N6 = $write_data_file4_before + $src_file_id_N6 + $write_data_file4_after

            $src_file_id_N7 =
"   if(u4g_dbg_cnt_wlmng_8msh < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_8msh++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_8msh = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N7 = $write_data_file4_before + $src_file_id_N7 + $write_data_file4_after

            $src_file_id_N8 =
"   if(u4g_dbg_cnt_wlmng_16msmh < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_16msmh++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_16msmh = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
             $write_data_file4_N8 = $write_data_file4_before + $src_file_id_N8 + $write_data_file4_after

             $src_file_id_N9 =
"   if(u4g_dbg_cnt_wlmng_32msmh < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_32msmh++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_32msmh = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
             $write_data_file4_N9 = $write_data_file4_before + $src_file_id_N9 + $write_data_file4_after
            
             $src_file_id_N10 =
"   if(u4g_dbg_cnt_wlmng_4msm < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_4msm++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_4msm = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
             $write_data_file4_N10 = $write_data_file4_before + $src_file_id_N10 + $write_data_file4_after

             $src_file_id_N11 =
"   if(u4g_dbg_cnt_wlmng_8msm < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_8msm++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_8msm = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N11 = $write_data_file4_before + $src_file_id_N11 + $write_data_file4_after

            $src_file_id_N12 =
"   if(u4g_dbg_cnt_wlmng_16msm < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_16msm++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_16msm = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N12 = $write_data_file4_before + $src_file_id_N12 + $write_data_file4_after

            $src_file_id_N13 =
"   if(u4g_dbg_cnt_wlmng_32msm < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_32msm++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_32msm = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N13 = $write_data_file4_before + $src_file_id_N13 + $write_data_file4_after

            $src_file_id_N14 =
"   if(u4g_dbg_cnt_wlmng_8msl < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_8msl++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_8msl = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N14 = $write_data_file4_before + $src_file_id_N14 + $write_data_file4_after
            
            $src_file_id_N15 =
"   if(u4g_dbg_cnt_wlmng_16msl < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_16msl++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_16msl = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N15 = $write_data_file4_before + $src_file_id_N15 + $write_data_file4_after

            $src_file_id_N16 =
"   if(u4g_dbg_cnt_wlmng_32msl < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_32msl++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_32msl = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N16 = $write_data_file4_before + $src_file_id_N16 + $write_data_file4_after

            $src_file_id_N17 =
"   if(u4g_dbg_cnt_wlmng_65msl < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_65msl++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_65msl = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N17 = $write_data_file4_before + $src_file_id_N17 + $write_data_file4_after

            $src_file_id_N18 =
"	if(u4g_dbg_cnt_wlmng_131msl < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_131msl++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_131msl = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N18 = $write_data_file4_before + $src_file_id_N18 + $write_data_file4_after

            $src_file_id_N19 =
"   if(u4g_dbg_cnt_wlmng_1sl < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_1sl++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_1sl = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N19 = $write_data_file4_before + $src_file_id_N19 + $write_data_file4_after

            $src_file_id_N20 =
"   if(u4g_dbg_cnt_wlmng_mg2ms < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_mg2ms++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_mg2ms = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
            $write_data_file4_N20 = $write_data_file4_before + $src_file_id_N20 + $write_data_file4_after

        $src_file_id_N21 =
"	if(u4g_dbg_cnt_wlmng_mg5ms < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_mg5ms++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_mg5ms = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
    $write_data_file4_N21 = $write_data_file4_before + $src_file_id_N21 + $write_data_file4_after

        $src_file_id_N22 =
"   if(u4g_dbg_cnt_wlmng_mg10ms < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_mg10ms++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_mg10ms = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
    $write_data_file4_N22 = $write_data_file4_before + $src_file_id_N22 + $write_data_file4_after

    $src_file_id_N23 =
"   if(u4g_dbg_cnt_wlmng_ad2ms < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ad2ms++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ad2ms = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
    $write_data_file4_N23 = $write_data_file4_before + $src_file_id_N23 + $write_data_file4_after
    
    $src_file_id_N24 =
"	if(u4g_dbg_cnt_wlmng_ad4ms < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ad4ms++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ad4ms = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
    $write_data_file4_N24 = $write_data_file4_before + $src_file_id_N24 + $write_data_file4_after

    $src_file_id_N25 =
"   if(u4g_dbg_cnt_wlmng_ad8ms < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ad8ms++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ad8ms = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
    $write_data_file4_N25 = $write_data_file4_before + $src_file_id_N25 + $write_data_file4_after

    $src_file_id_N26 =
"   if(u4g_dbg_cnt_wlmng_ne10 < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ne10++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ne10 = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
    $write_data_file4_N26 = $write_data_file4_before + $src_file_id_N26 + $write_data_file4_after

    $src_file_id_N27 =
"	if(u4g_dbg_cnt_wlmng_ne30m < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ne30m++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ne30m = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
    $write_data_file4_N27 = $write_data_file4_before + $src_file_id_N27 + $write_data_file4_after

    $src_file_id_N28 =
"   if(u4g_dbg_cnt_wlmng_ne10h < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ne10h++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ne10h = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
    $write_data_file4_N28 = $write_data_file4_before + $src_file_id_N28 + $write_data_file4_after

    $src_file_id_N29 =
"	if(u4g_dbg_cnt_wlmng_ne10m < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_ne10m++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_ne10m = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
    $write_data_file4_N29 = $write_data_file4_before + $src_file_id_N29 + $write_data_file4_after

    $src_file_id_N30 =
"   if(u4g_dbg_cnt_wlmng_drvclchg < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_drvclchg++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_drvclchg = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
    $write_data_file4_N30 = $write_data_file4_before + $src_file_id_N30 + $write_data_file4_after

    $src_file_id_N31 =
"   if(u4g_dbg_cnt_wlmng_drvclchgwch < u4g_U4MAX)
    {
        u4g_dbg_cnt_wlmng_drvclchgwch++;         /* �f�o�b�NRAM�J�E���g�A�b�v���� */
    }
    else
    {
        u4g_dbg_cnt_wlmng_drvclchgwch = (u4)0;   /* �f�o�b�NRAM����K�[�h���� */
    }"
    $write_data_file4_N31 = $write_data_file4_before + $src_file_id_N31 + $write_data_file4_after

            #�ꎞ�t�@�C���̍쐬
            if (Test-Path($file4_PATH + ".new")) {
                Remove-Item ($file4_PATH + ".new")
            }
            $src_file = Get-Content $file4_PATH 
            [bool]$is_target_section = $false # �����Ώۋ�Ԃ�
            [double]$num = 1  
            
            foreach ($line in $src_file) {
                    # �����Ώۂ̊J�n�s���O�͂��̂܂܏o��
                    # �����Ώۂ̊J�n�s�̏ꍇ�ɂ��̂܂܏o�͂Ɛ؂�ւ��p�̏����o��
                    # �����Ώۂ̊J�n�s+1���珈���Ώۂ̏I���s-1�͂Ȃɂ����Ȃ�
                    # �����Ώۂ̏I���s����͂��̂܂܏o��
            if ($line.Contains("static u1 u1s_wlmng_8msl_count;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                    $write_data_file4_N1 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
            elseif ($num -eq 146) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                    $write_data_file4_N2 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
            elseif ($line.Contains("u1s_wlmng_32msm_count = (u1)0;")) {
                    $is_target_section = $true
                    #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                    # |�����̈Ӗ��F�p�C�v���C��
                    $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                    $write_data_file4_N3 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                    $is_target_section = $false
                    }
            elseif ($num -eq 242) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N4 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 259) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N5 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 275) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N6 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 291) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N7 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 307) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N8 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 323) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N9 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 341) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N10 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 357) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N11 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 376) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N12 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 413) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N13 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 515) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N14 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 533) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N15 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 549) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N16 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 565) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N17 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 581) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N18 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 597) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N19 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 613) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N20 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 629) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N21 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 645) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N22 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 661) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N23 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 677) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N24 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 693) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N25 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 709) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N26 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 725) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N27 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 741) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N28 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 757) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N29 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 773) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
                $line | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append 
                $write_data_file4_N30 | %{ $_+"`n" } | Out-File -Encoding default -NoNewline ($file4_PATH + ".new") -Append   
                $is_target_section = $false
                }
            elseif ($num -eq 789) {
                $is_target_section = $true
                #% {} �� foreach�iForeach-Object�j���Ӗ����܂�
                # |�����̈Ӗ��F�p�C�v���C��
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
        Write-Host "�\�t�gF��������"
        Write-Host "�\�[�X��ۑ���--------"
        Copy-Item "..\..\main_micro\sources\" "kaizoF" -Recurse -Force
        Write-Host "�����\�t�gF�̃r���h�J�n�������܂��B"
        Start-Process -Filepath "test_build.bat" -Wait -NoNewWindow 
        Write-Host "�����\�t�gF�̃r���h���ʕ�(Rom�t�H���_)��ۑ����Ă��܂��B"
        Copy-Item $Target_PATH "kaizoF" -Recurse -Force
        #�t�@�C���𕜌�
        Remove-Item "..\..\main_micro\sources" -Recurse
        Copy-Item  "kaizoA\" "..\..\main_micro\sources" -Recurse -Force
        Write-Host "===================================================================="
        Write-Host "| �����\�t�gF��Ƃ��I���܂����B|"
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
 
        Default {Write-Host "�����\�t�g�^�C�v���Ԉ�����A�m�F���Ă�������"}
    }
    #���\�[�X���폜����
    Remove-Item 'kaizoA' -Recurse
    "���������AAny key to exit"  ;Read-Host | Out-Null ;Exit
    #�����\�t�gB
}


catch {
    pause

    "�������s�AAny key to exit"  ;Read-Host | Out-Null ;exit 1
}
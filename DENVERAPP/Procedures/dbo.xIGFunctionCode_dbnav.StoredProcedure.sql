USE [DENVERAPP]
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures with (nolock)
            WHERE NAME = 'xIGFunctionCode_dbnav'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[xIGFunctionCode_dbnav]
GO

CREATE PROCEDURE [dbo].[xIGFunctionCode_dbnav] 
	@parm1 Varchar (30),
	@parm2 Varchar (6)
 
AS

/*******************************************************************************************************
*   DENVERAPP.dbo.xIGFunctionCode_dbnav 
*
*   Creator: 
*   Date:          
*   
*          EXEC sp_recompile N'dbo.xIGFunctionCode_dbnav'
*
*   Usage:	set statistics io on

	execute DENVERAPP.dbo.xIGFunctionCode_dbnav 'fee', '%'

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   
********************************************************************************************************/



SELECT * 
FROM xIGFunctionCode
left outer join PJEmploy a
	on xIGFunctionCode.activate_by = a.employee 		
left outer join PJEmploy b 
	on xIGFunctionCode.deactivate_by = b.employee 
left outer join Account c 
	on xIGFunctionCode.account = c.acct
WHERE xIGFunctionCode.code_group Like @parm1
	and xIGFunctionCode.Code_id like @parm2 		
order by xIGFunctionCode.Code_Group, xIGFunctionCode.Code_ID OPTION (RECOMPILE);
GO

---------------------------------------------
-- permissions
---------------------------------------------
grant execute on xIGFunctionCode_dbnav to BFGROUP
go

grant execute on xIGFunctionCode_dbnav to MSDSL
go

grant control on xIGFunctionCode_dbnav to MSDSL
go

grant execute on xIGFunctionCode_dbnav to MSDynamicsSL
go

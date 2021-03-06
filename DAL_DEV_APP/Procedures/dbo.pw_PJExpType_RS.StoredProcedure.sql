USE [DAL_DEV_APP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH (nolock)
            WHERE NAME = 'pw_PJExpType_RS'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[pw_PJExpType_RS]
GO

Create Procedure [dbo].[pw_PJExpType_RS]
	@Parm0 varchar(4) 

AS

/*******************************************************************************************************
*   DAL_DEV_APP.dbo.pw_PJExpType_RS 
*
*   Creator: 
*   Date:          
*   
*          
*
*   Usage:	set statistics io on

	execute DAL_DEV_APP.dbo.pw_PJExpType_RS 

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/12/2016	Replaced old joins with ANSI-standard joins.
********************************************************************************************************/

exec("
	Select E.desc_exp, 
		E.default_rate, 
		A.gl_acct, 
		E.Units_flag, 
		E.gl_acct 
	from pjexptyp E
	left outer join Pj_Account A
		on E.gl_acct = A.gl_acct
	where E.exp_type = '" + @Parm0 + "'"
)
GO


---------------------------------------------
-- permissions
---------------------------------------------
grant execute on pw_PJExpType_RS to BFGROUP
go

grant execute on pw_PJExpType_RS to MSDSL
go

grant control on pw_PJExpType_RS to MSDSL
go

grant execute on pw_PJExpType_RS to MSDynamicsSL
go

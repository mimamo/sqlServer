USE [DENVERAPP]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

IF EXISTS (
            SELECT 1
            FROM sys.procedures WITH (nolock)
            WHERE NAME = 'xIGProdCode_dbnav'
                AND type = 'P'
           )
    DROP PROCEDURE [dbo].[xIGProdCode_dbnav]
GO

CREATE PROCEDURE [dbo].[xIGProdCode_dbnav] 
	@parm1 Varchar (30),
	@parm2 Varchar (4)
 
AS
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB

/*******************************************************************************************************
*   DENVERAPP.dbo.xIGProdCode_dbnav 
*
*   Creator: 
*   Date:          
*			EXEC sp_recompile N'dbo.xIGProdCode_dbnav'
*          
*
*   Usage:	set statistics io on

	execute DENVERAPP.dbo.xIGProdCode_dbnav 'aps', '%'

*
*   Modifications:   
*   Developer Name      Date        Brief description
*   ------------------- ----------- ------------------------------------------------------------
*   Michelle Morales	02/12/2016	Replaced old joins with ANSI standard
********************************************************************************************************/

SELECT * 
FROM xIGProdCode
left outer join PJEmploy a
	on xIGProdCode.activate_by = a.employee 
left outer join PJEmploy b 	
	on xIGProdCode.deactivate_by = b.employee 
WHERE xIGProdCode.code_group like @parm1
	and xIGProdCode.Code_id like @parm2 
order by xIGProdCode.Code_Group, xIGProdCode.Code_ID OPTION (RECOMPILE);

GO


---------------------------------------------
-- permissions
---------------------------------------------
grant execute on xIGProdCode_dbnav to BFGROUP
go

grant execute on xIGProdCode_dbnav to MSDSL
go

grant control on xIGProdCode_dbnav to MSDSL
go

grant execute on xIGProdCode_dbnav to MSDynamicsSL
go

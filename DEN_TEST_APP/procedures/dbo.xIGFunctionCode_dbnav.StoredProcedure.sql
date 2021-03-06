USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIGFunctionCode_dbnav]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB
 
CREATE PROCEDURE [dbo].[xIGFunctionCode_dbnav] 
	@parm1 Varchar (30),
	@parm2 Varchar (6)
 
AS


SELECT * FROM xIGFunctionCode,PJEmploy a,PJEmploy b, Account c WHERE
		xIGFunctionCode.code_group Like @parm1
		and xIGFunctionCode.Code_id like @parm2 
		and xIGFunctionCode.activate_by *= a.employee 
		and xIGFunctionCode.deactivate_by *= b.employee 
		and xIGFunctionCode.account *= c.acct
		order by xIGFunctionCode.Code_Group, xIGFunctionCode.Code_ID
GO

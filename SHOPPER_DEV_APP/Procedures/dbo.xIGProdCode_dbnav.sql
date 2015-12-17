USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIGProdCode_dbnav]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB

CREATE PROCEDURE [dbo].[xIGProdCode_dbnav] 
	@parm1 Varchar (30),
	@parm2 Varchar (4)
 
AS


SELECT * FROM xIGProdCode,PJEmploy a,PJEmploy b WHERE
 		xIGProdCode.code_group like @parm1
		and xIGProdCode.Code_id like @parm2 
		and xIGProdCode.activate_by *= a.employee 
		and xIGProdCode.deactivate_by *= b.employee 
		order by xIGProdCode.Code_Group, xIGProdCode.Code_ID
GO

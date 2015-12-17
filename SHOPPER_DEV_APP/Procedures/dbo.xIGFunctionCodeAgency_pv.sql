USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIGFunctionCodeAgency_pv]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB
 
CREATE PROCEDURE [dbo].[xIGFunctionCodeAgency_pv] 
	@parm1 Varchar (10)

AS

SELECT * FROM xIGFunctionCode where 
CODE_ID like @parm1 
and Type = 'A' 
Order by Code_id
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIGFunctionCodeAll_pv]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--UPDATED to T-SQL Standard 10/13/2009 JWG & MSB
  
CREATE PROCEDURE [dbo].[xIGFunctionCodeAll_pv] 
	@parm1 Varchar (6)
AS


SELECT * FROM xIGFunctionCode where Code_id like @parm1 
Order by Code_id
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpjcode_Function]    Script Date: 12/16/2015 15:55:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xpjcode_Function] 
	@parm1 Varchar (4) 
AS
	select * from PJCODE where 
	code_value like @parm1 and 
	code_type = '9FCG'  
	order by code_type, code_value
GO

USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xpjcode_product]    Script Date: 12/21/2015 13:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xpjcode_product] 
	@parm1 Varchar (4) 
AS
	select * from PJCODE where 
	code_value like @parm1 and 
	code_type = '9PCG'  
	order by code_type, code_value
GO

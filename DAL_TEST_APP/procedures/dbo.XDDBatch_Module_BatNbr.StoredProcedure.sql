USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_Module_BatNbr]    Script Date: 12/21/2015 13:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_Module_BatNbr]
	@Module		varchar(2),
	@BatNbr		varchar(10)
AS
  	Select 		*
  	FROM 		XDDBatch
  	WHERE 		Module = @Module
  			and BatNbr LIKE @BatNbr
GO

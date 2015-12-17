USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_Module_BatNbr]    Script Date: 12/16/2015 15:55:37 ******/
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

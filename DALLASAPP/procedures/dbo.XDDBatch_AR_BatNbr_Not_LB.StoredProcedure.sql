USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_AR_BatNbr_Not_LB]    Script Date: 12/21/2015 13:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_AR_BatNbr_Not_LB]
	@BatNbr		varchar(10)
AS
  	Select 		*
  	FROM 		XDDBatch
  	WHERE 		Module = 'AR'
  			and FileType <> 'L'
  			and BatNbr = @BatNbr
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDAccount_CuryID]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDAccount_CuryID]
	@Account	varchar( 10 )

AS

	Declare @PmtCuryID 	varchar( 4 )

	SELECT	@PmtCuryID = BaseCuryID 
	FROM	GLSetup (nolock)
	
	if exists(Select * from CMSetup (nolock))
		SELECT	@PmtCuryID = CuryID 
		FROM	Account (nolock)
		WHERE	Acct = @Account

	SELECT @PmtCuryID
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatch_PmtTotal]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatch_PmtTotal]
  	@Module		varchar( 2 ),
  	@BatNbr		varchar( 10 )

AS

	declare	@BatTotal	float
	declare	@BaseCuryPrec	float

	-- Get the base currency precision
	SELECT	@BaseCuryPrec = c.DecPl
	FROM	GLSetup s (nolock),
		Currncy c (nolock)
	WHERE	s.BaseCuryID = c.CuryID

	SET @BatTotal = 0

	if @Module = 'AP'
		SELECT @BatTotal = Sum(round(CuryOrigDocAmt, @BaseCuryPrec)) 
		FROM 	APDoc (nolock) 
		WHERE 	BatNbr = @BatNbr 
			and DocType IN ('CK', 'HC') 
			and Status <> 'V'
--	else
--		AR goes here

	SELECT @BatTotal
GO

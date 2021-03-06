USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDOutbound_PrcDecPl]    Script Date: 12/21/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDOutbound_PrcDecPl] @CurrencyID varchar(4)
AS
Declare @CurrencyDecPl  as smallint
Declare @CustomDecPl  as smallint

	SELECT @CurrencyDecPl = DecPl FROM Currncy (NOLOCK) where CuryId = @CurrencyID

	SELECT   @CustomDecPl =
	      CASE (SELECT S4Future09 FROM EDSetup (NOLOCK))
	         WHEN 1 THEN @CurrencyDecPl
	         ELSE (SELECT DecPlPrcCst FROM INSetup (NOLOCK))
	      END

	-- set return value = -1 if it is undefined
	SELECT @CurrencyDecPl = ISNULL(@CurrencyDecPl, -1)
	SELECT @CustomDecPl = ISNULL(@CustomDecPl, -1)

	Select @CurrencyDecPl, @CustomDecPl
GO

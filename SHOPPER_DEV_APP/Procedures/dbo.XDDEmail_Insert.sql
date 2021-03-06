USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDEmail_Insert]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[XDDEmail_Insert]
	@LineFull		varchar( 510 )
AS

	declare @Line		varchar( 255 )
	declare @LinePlus	varchar( 255 )

	if len(rtrim(@LineFull)) <= 255
	BEGIN
		SET @Line = rtrim(@LineFull)
		SET @LinePlus = ''
	END
	else
	BEGIN
		SET @Line = Left(@LineFull, 255)
		SET @LInePlus = right(@LineFull, len(@LineFull) - 255)
	END	

	INSERT	INTO #TempTable
	(LineOut, LineOutPlus)
	VALUES
	(@Line, @LinePlus)
GO

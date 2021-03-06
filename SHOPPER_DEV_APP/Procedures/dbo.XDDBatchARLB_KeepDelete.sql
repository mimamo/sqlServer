USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchARLB_KeepDelete]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchARLB_KeepDelete]
	@KeepDelete	varchar(1),
	@BatNbr		varchar(10)
	
AS
	SELECT		*
	FROM		XDDBatch
	WHERE		Module = 'AR'
			and FileType = 'L'
			and KeepDelete LIKE @KeepDelete
			and BatNbr LIKE @BatNbr
	ORDER BY	BatNbr DESC
GO

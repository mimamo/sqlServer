USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_RefNbr_CountInvcNbr]    Script Date: 12/21/2015 13:35:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_RefNbr_CountInvcNbr]
	@RefNbr		Varchar(10)
AS
	SELECT	Count(*)
	FROM	RefNbr
	WHERE	RefNbr = @RefNbr
GO

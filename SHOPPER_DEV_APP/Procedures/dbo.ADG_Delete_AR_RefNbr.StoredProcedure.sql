USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Delete_AR_RefNbr]    Script Date: 12/21/2015 14:34:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ADG_Delete_AR_RefNbr]
	@RefNbr		Varchar(10)
AS
	DELETE	RefNbr
	WHERE	RefNbr = @RefNbr
GO

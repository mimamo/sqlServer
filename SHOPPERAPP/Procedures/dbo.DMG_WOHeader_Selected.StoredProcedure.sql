USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_WOHeader_Selected]    Script Date: 12/21/2015 16:13:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_WOHeader_Selected]
	@WONbr		varchar(16)
AS
	select		PrjWOGLIM, ProcStage, WOType
	from		WOHeader
	Where		WONbr = @WONbr
GO

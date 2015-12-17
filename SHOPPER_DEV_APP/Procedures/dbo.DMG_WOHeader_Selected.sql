USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_WOHeader_Selected]    Script Date: 12/16/2015 15:55:18 ******/
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

USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_Get_SO]    Script Date: 12/21/2015 14:06:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateAll_Get_SO]
as
	select		CpnyID, OrdNbr
	from		SOHeader
	where		Status = 'O'
	order by	CpnyID, OrdNbr
GO

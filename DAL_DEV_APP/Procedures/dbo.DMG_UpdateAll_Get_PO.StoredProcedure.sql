USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_UpdateAll_Get_PO]    Script Date: 12/21/2015 13:35:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_UpdateAll_Get_PO]
as
	select		CpnyID, PONbr
	from		Purchord
	where		Status in ('O', 'P')
	order by	PONbr
GO

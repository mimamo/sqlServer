USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOHeader_All_NoCancelled]    Script Date: 12/21/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_SOHeader_All_NoCancelled]
as
	set nocount on

	select	*

	from	SOHeader

	where	Cancelled = 0

	order by CpnyID, OrdNbr
GO

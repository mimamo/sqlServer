USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_Book_PostBookings]    Script Date: 12/21/2015 16:00:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_Book_PostBookings]
as
	select	PostBookings
	from	SOSetup (nolock)
GO

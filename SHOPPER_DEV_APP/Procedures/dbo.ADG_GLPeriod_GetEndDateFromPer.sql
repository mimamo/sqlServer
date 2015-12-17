USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLPeriod_GetEndDateFromPer]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_GLPeriod_GetEndDateFromPer]
	@Period			varchar (6)
as
	declare @PerEnd		varchar (4)

	execute ADG_GLPeriod_EndDateFromPerOut @Period, @PerEnd output

	select @PerEnd PerEnd
GO

USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_GLPeriod_GetPeriodFromDate]    Script Date: 12/16/2015 15:55:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_GLPeriod_GetPeriodFromDate]
	@Date			smalldatetime,
	@UseCurrentOMPeriod	smallint
as
	declare @Period	varchar(6)

	execute ADG_GLPeriod_GetPerFromDateOut @Date, @UseCurrentOMPeriod, @Period output

	select @Period Period
GO

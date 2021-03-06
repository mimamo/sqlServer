USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ARSetup_InvcNbr]    Script Date: 12/21/2015 14:17:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_ARSetup_InvcNbr]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
as
	select
		SetupID,
		convert(char(13), ''),
		convert(char( 4), ''),
		convert(char(10), coalesce(reverse(substring(reverse(rtrim(LastRefNbr)), 1, nullif(patindex('%[^0-9]%',reverse(rtrim(LastRefNbr))),0) - 1)), LastRefNbr))
	from ARSetup
GO

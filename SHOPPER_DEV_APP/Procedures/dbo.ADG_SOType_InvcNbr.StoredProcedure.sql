USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_SOType_InvcNbr]    Script Date: 12/21/2015 14:34:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[ADG_SOType_InvcNbr]
	@CpnyID		varchar(10),
	@SOTypeID	varchar(4)
as
	select
		case when InvcNbrAR = 0 then InvcNbrPrefix else coalesce(reverse(substring(reverse(rtrim(LastRefNbr)), nullif(patindex('%[^0-9]%',reverse(rtrim(LastRefNbr))),0), 10)), '') end,
		case when InvcNbrAR = 0 then InvcNbrType else '&AR' end,
		LastInvcNbr
	from	SOType
	cross 	join ARSetup
	where	CpnyID = @CpnyID
	  and	SOTypeID = @SOTypeID
GO

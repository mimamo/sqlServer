USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSendEDIShippingNotice]    Script Date: 12/21/2015 14:34:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[EDSendEDIShippingNotice]
	@CustID varchar(15)
as
	select	count(*)
	from	EDOutBound
	where	CustID = @CustID
	and	Trans IN ('856', '857')
GO

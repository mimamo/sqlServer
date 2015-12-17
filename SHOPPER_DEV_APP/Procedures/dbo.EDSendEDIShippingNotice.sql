USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSendEDIShippingNotice]    Script Date: 12/16/2015 15:55:21 ******/
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

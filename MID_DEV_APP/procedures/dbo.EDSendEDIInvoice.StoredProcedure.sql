USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSendEDIInvoice]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[EDSendEDIInvoice]
	@CustID varchar(15)
as
	select	count(*)
	from	EDOutBound
	where	CustID = @CustID
	and	Trans IN ('810', '880')
GO

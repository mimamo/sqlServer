USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_SOAddress_Fetch]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_SOAddress_Fetch]
	@CustID		varchar(15)
as
	select	*
	from	SOAddress
	where	CustID = @CustID
GO

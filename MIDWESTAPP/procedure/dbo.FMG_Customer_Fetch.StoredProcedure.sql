USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_Customer_Fetch]    Script Date: 12/21/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_Customer_Fetch]
	@CustID		varchar(15)
as
	select	*
	from	Customer
	where	CustID = @CustID
GO

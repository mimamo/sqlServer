USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_Customer_Fetch]    Script Date: 12/21/2015 13:44:55 ******/
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

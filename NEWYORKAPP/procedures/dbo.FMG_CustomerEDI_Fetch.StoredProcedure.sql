USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CustomerEDI_Fetch]    Script Date: 12/21/2015 16:01:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_CustomerEDI_Fetch]
	@CustID		varchar(15)
as
	select	*
	from	CustomerEDI
	where	CustID = @CustID
GO

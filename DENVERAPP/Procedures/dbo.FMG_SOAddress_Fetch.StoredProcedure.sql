USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_SOAddress_Fetch]    Script Date: 12/21/2015 15:42:55 ******/
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

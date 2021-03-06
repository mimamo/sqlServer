USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CreditInfo_Customer_Selected]    Script Date: 12/21/2015 14:06:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_CreditInfo_Customer_Selected]
	@CustID		varchar(15),
	@CreditRule	varchar(2) OUTPUT,
	@GracePer	smallint OUTPUT
as
	select	@CreditRule = ltrim(rtrim(CreditRule)),
		@GracePer = GracePer
	from	CustomerEDI (NOLOCK)
	where	CustID = @CustID

	if @@ROWCOUNT = 0 begin
		set @CreditRule = ''
		set @GracePer = 0
		return 0	--Failure
	end
	else
		return 1	--Success
GO

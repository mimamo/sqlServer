USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CustContactSelected]    Script Date: 12/21/2015 15:55:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_CustContactSelected]
	@CustID		varchar(15),
	@Type		varchar(2) OUTPUT,
	@ContactID	varchar(10),
	@Name		varchar(60) OUTPUT,
	@OrderLimit	decimal(25,9) OUTPUT,
	@POReqdAmt	decimal(25,9) OUTPUT
as
	select	@Name = ltrim(rtrim(Name)),
		@OrderLimit = OrderLimit,
		@POReqdAmt = POReqdAmt,
		@Type = ltrim(rtrim(Type))
	from	CustContact (NOLOCK)
	where	CustID = @CustID
	and	Type like @Type
	and	ContactID = @ContactID

	if @@ROWCOUNT = 0 begin
		set @Name = ''
		set @OrderLimit = 0
		set @POReqdAmt = 0
		set @Type = ''
		return 0	--Failure
	end
	else
		return 1	--Success
GO

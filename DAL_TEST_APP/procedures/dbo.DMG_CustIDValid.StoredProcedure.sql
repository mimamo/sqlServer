USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CustIDValid]    Script Date: 12/21/2015 13:56:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_CustIDValid]
	@CustID		varchar(15)
as
	if (
	select	count(*)
	from	Customer (NOLOCK)
	where	CustID = @CustID
	and	Status IN ('A', 'O', 'R')
	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO

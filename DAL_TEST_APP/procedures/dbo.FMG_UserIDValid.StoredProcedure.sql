USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_UserIDValid]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_UserIDValid]
	@UserID	varchar(47)

WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
	if (
	select	count(*)
	from 	vs_UserRec (NOLOCK)
        where 	UserID = @UserID
 	) = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO

USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CertificationTextValid]    Script Date: 12/21/2015 16:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_CertificationTextValid]
	@CertID	varchar(2)
as
	if (
	select	count(*)
	from 	CertificationText (NOLOCK)
        where 	CertID = @CertID
	) = 0
 		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO

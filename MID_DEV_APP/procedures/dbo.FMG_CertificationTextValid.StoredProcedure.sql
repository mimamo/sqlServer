USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CertificationTextValid]    Script Date: 12/21/2015 14:17:44 ******/
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

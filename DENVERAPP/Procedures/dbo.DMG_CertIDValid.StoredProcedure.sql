USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_CertIDValid]    Script Date: 12/21/2015 15:42:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_CertIDValid]
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

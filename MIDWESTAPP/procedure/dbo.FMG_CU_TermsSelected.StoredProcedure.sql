USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[FMG_CU_TermsSelected]    Script Date: 12/21/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[FMG_CU_TermsSelected]
	@TermsId	varchar(2),
	@ApplyTo	varchar(1),
	@COD		smallint OUTPUT
as
	select	@COD = COD
	from	Terms (NOLOCK)
	where	TermsId = @TermsId
	and	ApplyTo in (@ApplyTo,'B')

	if @@ROWCOUNT = 0
		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO

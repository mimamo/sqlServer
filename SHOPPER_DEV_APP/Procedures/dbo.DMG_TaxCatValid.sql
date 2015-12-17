USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_TaxCatValid]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_TaxCatValid]
	@CatID	varchar(10)
as
	if (
	select	count(*)
	from 	SlsTaxCat (NOLOCK)
        where 	CatID = @CatID
	) = 0
 		--select 0
		return 0	--Failure
	else
		--select 1
		return 1	--Success
GO

USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_TermsSelected]    Script Date: 12/21/2015 15:42:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_TermsSelected]
	@TermsID 	varchar(2),
	@Applyto 	varchar(1),
	@SOBehavior  	varchar(4),
	@COD		smallint OUTPUT
as
	SELECT	@COD = COD
	FROM 	Terms
	WHERE 	Applyto IN (@Applyto,'B')
	  AND 	((TermsType = 'S' and @SOBehavior in ('CM', 'DM'))
	  or 	(TermsType = TermsType and @SOBehavior NOT in ('CM', 'DM')))
	  AND 	TermsID = @TermsID

	if @@ROWCOUNT = 0 begin
		set @COD = 0
		return 0	--Failure
	end
	else begin
		return 1	--Success
	end
GO

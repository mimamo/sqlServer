USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_PurOrdDet_Fetch]    Script Date: 12/21/2015 15:42:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[DMG_PurOrdDet_Fetch]
	@PONbr		varchar(10)
as
	select	*
	from	PurOrdDet
	where	PONbr = @PONbr and PONbr <> ''
GO

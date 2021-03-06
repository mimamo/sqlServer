USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOLine_COIS]    Script Date: 12/21/2015 16:13:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOLine_COIS]
	@CpnyID		varchar(10),
	@OrdNbr		varchar(15),
	@InvtIDParm	varchar(30),
	@SiteIDParm	varchar(10)
AS
	SELECT *
	FROM SOLine
	WHERE CpnyID = @CpnyID
	   AND OrdNbr = @OrdNbr
	   AND	InvtID like @InvtIDParm
	   AND	SiteID like @SiteIDParm
	ORDER BY CpnyID,
	   OrdNbr,
	   LineRef
GO

USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_SOHeader_Nav]    Script Date: 12/21/2015 15:42:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[DMG_SOHeader_Nav]
	@CpnyID varchar(10),
	@OrdNbr varchar(15)
AS
	SELECT *
	FROM SOHeader
	WHERE CpnyID = @CpnyID
	   AND OrdNbr LIKE @OrdNbr
	ORDER BY OrdNbr
GO

USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDACHHeadTrail_Move_Recs]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDACHHeadTrail_Move_Recs]
	@FileType	varchar( 1 ),
	@FormatID	varchar( 15 ),
	@HeadTrailID	varchar( 1 ),
	@OldHT		varchar( 1 ),
	@NewHT		varchar( 1 )
AS

	-- Remove any records at the "New" Code
	DELETE		
	FROM 		XDDACHHeadTrail
	WHERE		FileType = @FileType
			and FormatID = @FormatID
			and HeadTrailID = @HeadTrailID
			and Header_Trailer = @NewHT
			
	-- Change all "Old" codes to the "New" codes		
	UPDATE		XDDAchHeadTrail		
	SET		Header_Trailer = @NewHT
	WHERE		FileType = @FileType
			and FormatID = @FormatID
			and HeadTrailID = @HeadTrailID
			and Header_Trailer = @OldHT
GO

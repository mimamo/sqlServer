USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDAchHeadTrail_HT_StartPos]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDAchHeadTrail_HT_StartPos]
	@FileType	varchar(1),
	@FormatID	varchar(15),
	@HeadTrailID	varchar(1),
	@Header_Trailer	varchar(1),
	@StartPos	varchar(2)
AS
  Select 	*
  FROM		XDDAchHeadTrail
  WHERE 	FileType LIKE @FileType
  		and FormatID LIKE @FormatID
  		and HeadTrailID LIKE @HeadTrailID
  		and Header_Trailer LIKE @Header_Trailer
  		and StartPos LIKE @StartPos
  ORDER by 	FileType, FormatID, HeadTrailID, Header_Trailer, StartPos
GO

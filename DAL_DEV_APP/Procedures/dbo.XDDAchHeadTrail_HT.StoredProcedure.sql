USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDAchHeadTrail_HT]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDAchHeadTrail_HT]
	@FileType	varchar(1),
	@FormatID	varchar(15),
	@HeadTrailID	varchar(1),
	@Header_Trailer	varchar(1)
AS
  Select 	*
  FROM		XDDAchHeadTrail
  WHERE		FileType = @FileType
  		and FormatID = @FormatID
  		and HeadTrailID = @HeadTrailID
  		and Header_Trailer = @Header_Trailer
  ORDER by 	Header_Trailer, StartPos
GO

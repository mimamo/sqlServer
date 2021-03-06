USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDAchHeadTrail_Lookup]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDAchHeadTrail_Lookup]
	@FileType	varchar(1),
	@FormatID	varchar(15),
	@HeadTrailID	varchar(1)
AS

  Select 	count(*)
  FROM		XDDAchHeadTrail (nolock)
  WHERE		FileType = @FileType
  		and FormatID = @FormatID
  		and HeadTrailID = @HeadTrailID
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCampaignSegmentValid]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptCampaignSegmentValid]
	@CampaignKey int,
	@SegmentName varchar(500)
AS

/*
|| When     Who Rel     What
|| 08/10/11 MFT 10.550  Created
*/

DECLARE @Key int

SELECT @Key = CampaignSegmentKey
FROM tCampaignSegment (nolock)
WHERE
	CampaignKey = @CampaignKey AND
	SegmentName = @SegmentName

RETURN ISNULL(@Key, 0)
GO

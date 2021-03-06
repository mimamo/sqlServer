USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPublishCalendarSecurityGetList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPublishCalendarSecurityGetList]
	@PublishCalendarKey int
AS

/*
|| When      Who Rel      What
|| 6/12/12   CRG 10.5.5.7 Created
*/

	SELECT	pcs.*, sg.GroupName
	FROM	tPublishCalendarSecurity pcs (nolock)
	INNER JOIN tSecurityGroup sg (nolock) ON pcs.SecurityGroupKey = sg.SecurityGroupKey
	WHERE	PublishCalendarKey = @PublishCalendarKey
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadUserServices]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadUserServices]
	@ProjectKey int
AS --Encrypt

/*
|| When      Who Rel     What
|| 4/11/08   CRG 1.0.0.0 Created for use by the new ProjectManager
|| 11/05/12  MFT 10.562  Added tService join
*/

	SELECT
		us.*,
		s.ServiceCode,
		s.Description
	FROM
		tProjectUserServices us (nolock)
		INNER JOIN tService s (nolock) ON us.ServiceKey = s.ServiceKey
	WHERE  ProjectKey = @ProjectKey
GO

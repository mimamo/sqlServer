USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptContactActivityProjectNote]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spRptContactActivityProjectNote]
	(
		@ActivityKey INT
	)
AS --Encrypt

  /*
  || When     Who Rel    What
  || 01/08/09 GHL 10.016 Reading now tActivity instead of tContactActivity and tProjectNote
  */
  
	SET NOCOUNT ON
	
	SELECT  v.Notes AS ContactActivityNote,
			v.*
	FROM    vContactActivity v (NOLOCK)
		WHERE  v.ActivityKey = @ActivityKey
	
	RETURN 1
GO

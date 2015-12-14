USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetAllForEntity]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetAllForEntity]
	(
		@Entity varchar(50),
		@EntityKey int
	)

AS

/*
|| When     Who Rel     What
|| 01/21/10 GHL 10.517	Reading now fields which are needed, not a.*
||                      Taking now 3 secs instead of 3 mins on APP2
|| 09/15/11 RLB 10.548  (121046) passing in DateUpdated to help figure out Last Activity
*/
	
	select a.ActivityKey, a.ActivityDate, a.Completed, a.DateCompleted, a.DateUpdated
	From tActivity a (nolock) 
	Inner join tActivityLink al (nolock) on a.ActivityKey = al.ActivityKey
	Where al.Entity = @Entity and al.EntityKey = @EntityKey
GO

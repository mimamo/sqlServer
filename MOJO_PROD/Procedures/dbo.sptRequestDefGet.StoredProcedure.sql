USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestDefGet]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestDefGet]
	@RequestDefKey int

AS --Encrypt
 /*
  || When     Who Rel       What
  || 03/25/15 WDF 10.5.9.0  (250961) Added CreatedBy; UpdatedBy
 */

		SELECT tRequestDef.*,
		  	   u.FirstName + ' ' + u.LastName as CreatedBy,
		       u2.FirstName + ' ' + u2.LastName as UpdatedBy,
			(Select Count(*) from tRequestDefSpec rds (NOLOCK) Where rds.RequestDefKey = @RequestDefKey) as SpecCount
		FROM tRequestDef (NOLOCK) 
  		left join tUser u (nolock) on tRequestDef.CreatedByKey = u.UserKey
		left join tUser u2 (nolock) on tRequestDef.UpdatedByKey = u2.UserKey
		WHERE
			RequestDefKey = @RequestDefKey

	RETURN 1
GO

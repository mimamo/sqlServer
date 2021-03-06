USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldSetGet]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldSetGet]
 @FieldSetKey int
AS --Encrypt
 /*
  || When     Who Rel       What
  || 03/25/15 WDF 10.5.9.0  (250961) Added CreatedBy; UpdatedBy
 */

 -- ToDo: If there is more than one PrimaryKey, remove the extras or rewrite the If statement.
 IF @FieldSetKey IS NULL
  SELECT tFieldSet.*
  		,u.FirstName + ' ' + u.LastName as CreatedBy
		,u2.FirstName + ' ' + u2.LastName as UpdatedBy
  FROM  tFieldSet (NOLOCK) 
  		left join tUser u (nolock) on tFieldSet.CreatedByKey = u.UserKey
		left join tUser u2 (nolock) on tFieldSet.UpdatedByKey = u2.UserKey
 ELSE
  SELECT tFieldSet.*
  		,u.FirstName + ' ' + u.LastName as CreatedBy
		,u2.FirstName + ' ' + u2.LastName as UpdatedBy
  FROM tFieldSet (NOLOCK)
  	   left join tUser u (nolock) on tFieldSet.CreatedByKey = u.UserKey
	   left join tUser u2 (nolock) on tFieldSet.UpdatedByKey = u2.UserKey
  WHERE
   FieldSetKey = @FieldSetKey
 RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetGetList]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetGetList]
	@Entity varchar(50),
	@EntityKey int,
	@UserKey int = null
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/25/09   CRG 10.5.1.1 (64143) Added FieldSetName for printing
|| 5/6/10    RLB 10.5.2.2 (79908) Ordering by display order
|| 06/15/14  GWG 10.5.8.1  Added Unread support
|| 04/21/15  WDF 10.5.9.1 (250962) Added CreatedBy; UpdatedBy
*/


if @UserKey is null
BEGIN
	SELECT	ss.*, fs.FieldSetName
	       ,u.FirstName + ' ' + u.LastName as [CreatedBy]
	       ,u2.FirstName + ' ' + u2.LastName as [UpdatedBy]
	FROM	tSpecSheet ss (NOLOCK) 
	INNER JOIN tObjectFieldSet ofs (nolock) ON ss.CustomFieldKey = ofs.ObjectFieldSetKey
	INNER JOIN tFieldSet fs (nolock) ON ofs.FieldSetKey = fs.FieldSetKey
	 LEFT JOIN tUser u (nolock) ON ss.CreatedByKey = u.UserKey
	 LEFT JOIN tUser u2 (nolock) ON ss.UpdatedByKey = u2.UserKey
	WHERE	ss.Entity = @Entity 
	AND		ss.EntityKey = @EntityKey
	ORDER BY ss.DisplayOrder
END
ELSE
BEGIN
	SELECT	ss.*, fs.FieldSetName, ISNULL(IsRead, 2) as IsRead
	       ,u.FirstName + ' ' + u.LastName as [CreatedBy]
	       ,u2.FirstName + ' ' + u2.LastName as [UpdatedBy]
	FROM	tSpecSheet ss (NOLOCK) 
	INNER JOIN tObjectFieldSet ofs (nolock) ON ss.CustomFieldKey = ofs.ObjectFieldSetKey
	INNER JOIN tFieldSet fs (nolock) ON ofs.FieldSetKey = fs.FieldSetKey
	LEFT OUTER JOIN (Select * from tAppRead (nolock) Where Entity = 'tSpecSheet' and UserKey = @UserKey) as ar on ss.SpecSheetKey = ar.EntityKey
	LEFT OUTER JOIN tUser u (nolock) ON ss.CreatedByKey = u.UserKey
	LEFT OUTER JOIN tUser u2 (nolock) ON ss.UpdatedByKey = u2.UserKey
	WHERE	ss.Entity = @Entity 
	AND		ss.EntityKey = @EntityKey
	ORDER BY ss.DisplayOrder
END
	RETURN 1
GO

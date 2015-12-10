USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetGet]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetGet]
	@SpecSheetKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 9/25/09   CRG 10.5.1.1 (64143) Added FieldSetName for printing
|| 04/21/15  WDF 10.5.9.1 (250962) Added CreatedBy; UpdatedBy
*/

	SELECT	ss.*, fs.FieldSetName
	       ,u.FirstName + ' ' + u.LastName as [CreatedBy]
	       ,u2.FirstName + ' ' + u2.LastName as [UpdatedBy]
	FROM	tSpecSheet ss (nolock)
	INNER JOIN tObjectFieldSet ofs (nolock) ON ss.CustomFieldKey = ofs.ObjectFieldSetKey
	INNER JOIN tFieldSet fs (nolock) ON ofs.FieldSetKey = fs.FieldSetKey
	 LEFT JOIN tUser u (nolock) ON ss.CreatedByKey = u.UserKey
	 LEFT JOIN tUser u2 (nolock) ON ss.UpdatedByKey = u2.UserKey
	WHERE	ss.SpecSheetKey = @SpecSheetKey

	RETURN 1
GO

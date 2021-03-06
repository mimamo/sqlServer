USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_tFieldSetGetForExport]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_tFieldSetGetForExport]
	@FieldSetKey int
AS

/*
|| When      Who Rel     What
|| 5/18/07   CRG 8.4.3   (7087) Created to pull in specific fields for Spec Sheet export.
*/	

	SELECT	fd.*, fsf.DisplayOrder
	FROM	tFieldDef fd (nolock)
	INNER JOIN tFieldSetField fsf (nolock) ON fd.FieldDefKey = fsf.FieldDefKey
	WHERE	fsf.FieldSetKey = @FieldSetKey
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSpecSheetGetListCFData]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSpecSheetGetListCFData]
	@Entity varchar(50),
	@EntityKey int,
	@SpecSheetKey int
AS --Encrypt

/*
|| When      Who Rel      What
|| 04/15/15  WDF 10.591  (250962) Added for Kohls requirements
*/

	SELECT ss.SpecSheetKey
	      ,CASE fd.DisplayType
	         WHEN 7 THEN 
	                 CASE ISNUMERIC(RIGHT(fd.FieldName, 1))
	                     WHEN 0 THEN fd.FieldName
	                     ELSE LEFT(fd.FieldName, LEN(fd.FieldName) - 1)
	                  END
				ELSE fd.FieldName
			END as FieldName
		  ,fv.FieldValue
	  FROM	tSpecSheet ss (NOLOCK) INNER JOIN tObjectFieldSet ofs (nolock) ON ss.CustomFieldKey = ofs.ObjectFieldSetKey
                                   inner join tFieldValue fv (nolock) on ofs.ObjectFieldSetKey = fv.ObjectFieldSetKey
	                               INNER JOIN tFieldSet fs (nolock) ON ofs.FieldSetKey = fs.FieldSetKey
                                   inner join tFieldDef fd (nolock) on fv.FieldDefKey = fd.FieldDefKey
	 WHERE ss.Entity = @Entity 
	   AND ss.EntityKey = @EntityKey
	   AND ss.SpecSheetKey = @SpecSheetKey
	ORDER BY ss.SpecSheetKey, ss.DisplayOrder
	
	
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemDepartmentGet]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemDepartmentGet]
	@ItemKey int

AS --Encrypt

	SELECT i.DepartmentKey, d.DepartmentName
	FROM tItem i
	LEFT OUTER JOIN tDepartment d (nolock) ON i.DepartmentKey = d.DepartmentKey
	WHERE i.ItemKey = @ItemKey

RETURN 1
GO

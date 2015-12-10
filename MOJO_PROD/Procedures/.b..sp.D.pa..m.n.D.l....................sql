USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepartmentDelete]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepartmentDelete]
	@DepartmentKey int

AS --Encrypt

  /*
  || When     Who Rel   What
  || 12/05/07 GHL 8.5   Added check of other tables                 
  */
  
If exists(Select 1 from tItem (nolock) Where DepartmentKey = @DepartmentKey) 
	return -1
If exists(Select 1 from tService (nolock) Where DepartmentKey = @DepartmentKey) 
	return -1	
	
If exists(Select 1 from tClass (nolock) Where DepartmentKey = @DepartmentKey)
	return -1
If exists(Select 1 from tUser (nolock) Where DepartmentKey = @DepartmentKey)
	return -1

If exists(Select 1 from tInvoiceLine (nolock) Where DepartmentKey = @DepartmentKey)
	return -1
If exists(Select 1 from tTransaction (nolock) Where DepartmentKey = @DepartmentKey)
	return -1

	DELETE
	FROM tDepartment
	WHERE
		DepartmentKey = @DepartmentKey 

	RETURN 1
GO

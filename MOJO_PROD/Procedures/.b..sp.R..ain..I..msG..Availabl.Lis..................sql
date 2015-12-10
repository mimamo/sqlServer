USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerItemsGetAvailableList]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerItemsGetAvailableList]
	(
		@CompanyKey INT
	)
AS -- Encrypt

/*
|| When     Who Rel   What
|| 07/10/07 QMD 8.5   Expense Type reference changed to tItem (Removed the union)
*/

	SET NOCOUNT ON
	
	-- These items needed to go in same DD 

	SELECT	i.ItemKey 
			,CASE i.ItemType
                WHEN 3 THEN CAST('Expense - ' + i.ItemName AS VARCHAR(250))
                ELSE CAST('Item - ' + i.ItemName AS VARCHAR(250))
             END AS ItemName
			,'tItem' AS Entity
	FROM	tItem i (nolock)
	WHERE	i.CompanyKey = @CompanyKey
	AND		i.Active = 1
	Order By Entity DESC, ItemName	
	
	
	RETURN 1
GO

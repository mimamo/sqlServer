USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerItemsGetList]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerItemsGetList]
	(
		@RetainerKey int
		,@Entity varchar(50)
	)
AS -- Encrypt

/*
|| When     Who Rel   What
|| 07/10/07 QMD 8.5   Expense Type reference changed to tItem (Removed Union from else condition)
*/

	SET NOCOUNT ON

	IF @Entity = 'tService'
		SELECT	ri.EntityKey 
				,ri.Entity
				,s.ServiceCode + ' - ' + s.Description AS ItemName
		FROM	tRetainerItems ri (NOLOCK)
			INNER JOIN tService s (NOLOCK) ON ri.EntityKey = s.ServiceKey
		WHERE   ri.RetainerKey = @RetainerKey
		AND		ri.Entity = 'tService'

	ELSE
		SELECT	ri.EntityKey
				,ri.Entity
				,CASE i.ItemType
                    WHEN 3 THEN CAST('Expense - ' + i.ItemName AS VARCHAR(50)) 
                    ELSE CAST('Item - ' + i.ItemName AS VARCHAR(50))  
                 END AS ItemName
		FROM	tRetainerItems ri (NOLOCK)
			INNER JOIN tItem i (NOLOCK) ON ri.EntityKey = i.ItemKey
		WHERE   ri.RetainerKey = @RetainerKey
		AND		ri.Entity = 'tItem'
			
	RETURN 1
GO

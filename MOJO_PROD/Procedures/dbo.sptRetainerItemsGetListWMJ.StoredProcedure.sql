USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRetainerItemsGetListWMJ]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRetainerItemsGetListWMJ]
	(
		@CompanyKey int
		,@RetainerKey int
		,@Entity varchar(50)
	)
AS -- Encrypt

/*
|| When     Who Rel    What
|| 10/26/11 RLB 10549  Created for Flex Retainer
|| 5/11/12  RLB 142564 Only pull active services and Items
*/

	SET NOCOUNT ON
IF @RetainerKey > 0
Begin
	IF @Entity = 'tService'
		SELECT	ri.EntityKey 
				,ri.Entity
				,s.ServiceCode + ' - ' + s.Description AS ItemName
				,1 AS selected
		FROM	tRetainerItems ri (NOLOCK)
			INNER JOIN tService s (NOLOCK) ON ri.EntityKey = s.ServiceKey
		WHERE   ri.RetainerKey = @RetainerKey
		AND		ri.Entity = 'tService'
		AND     s.Active = 1
		
		UNION
		
		SELECT ServiceKey as EntityKey
				,'tService' as Entity
				,ServiceCode + ' - ' + Description AS ItemName
				,0 AS selected
		FROM tService (NOLOCK)
		WHERE CompanyKey = @CompanyKey 
		AND  Active = 1
		AND  ServiceKey NOT IN (Select EntityKey from tRetainerItems (NOLOCK) where RetainerKey = @RetainerKey and Entity = 'tService')

	ELSE
		SELECT	ri.EntityKey
				,ri.Entity
				,CASE i.ItemType
                    WHEN 3 THEN CAST('Expense - ' + i.ItemName AS VARCHAR(50)) 
                    ELSE CAST('Item - ' + i.ItemName AS VARCHAR(50))  
                 END AS ItemName
                 ,1 AS selected
		FROM	tRetainerItems ri (NOLOCK)
			INNER JOIN tItem i (NOLOCK) ON ri.EntityKey = i.ItemKey
		WHERE   ri.RetainerKey = @RetainerKey
		AND		ri.Entity = 'tItem'
		AND     i.Active = 1
		
		UNION

		SELECT ItemKey as EntityKey
			,'tItem' AS Entity
			,CASE ItemType
				WHEN 3 THEN CAST('Expense - ' + ItemName AS VARCHAR(50)) 
                ELSE CAST('Item - ' + ItemName AS VARCHAR(50))  
             END AS ItemName
            ,0 AS selected
       FROM tItem (nolock)
       WHERE CompanyKey = @CompanyKey
	   AND Active = 1
       AND ItemKey Not In (Select EntityKey from tRetainerItems (nolock) where RetainerKey = @RetainerKey and Entity = 'tItem')

END
ELSE
BEGIN
	IF @Entity = 'tService'
		
		SELECT ServiceKey as EntityKey
				,'tService' as Entity
				,ServiceCode + ' - ' + Description AS ItemName
				,0 AS selected
		FROM tService (NOLOCK)
		WHERE CompanyKey = @CompanyKey
		AND   Active = 1 
	
	ELSE
		
		SELECT ItemKey as EntityKey
			,'tItem' AS Entity
			,CASE ItemType
				WHEN 3 THEN CAST('Expense - ' + ItemName AS VARCHAR(50)) 
                ELSE CAST('Item - ' + ItemName AS VARCHAR(50))  
             END AS ItemName
            ,0 AS selected
       FROM tItem (nolock)
       WHERE CompanyKey = @CompanyKey
       AND   Active = 1 


END 
			
	RETURN 1
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormGetFormList]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptFormGetFormList]
	 @CompanyKey INT,
	 @FormLayoutKey INT
AS --Encrypt

  /*
  || When     Who Rel   What
  || 11/26/07 GHL 8.5   Removed non ANSI joins for SQL 2005 
  */
  	                   
	 -- Must be created here in the SP

	 CREATE TABLE #tField (
					DisplayOrder INT NULL
					,FieldName    VARCHAR(200) NULL)
 
 INSERT #tField (FieldName, DisplayOrder)
 select fld.FieldName
       ,fld.DisplayOrder
   from tFormLayoutDetail fld (nolock)
       LEFT OUTER JOIN tFieldDef fd (nolock) ON fld.FieldName = fd.FieldName
  where fld.FormLayoutKey = @FormLayoutKey
    and fd.OwnerEntityKey = @CompanyKey
    and fd.AssociatedEntity = 'Forms'
    and fld.FieldName NOT LIKE '~%'		-- Filter out required fields
		
	DECLARE		@FormKey INT
				,@DisplayOrder INT
				,@FieldName VARCHAR(200)
				,@FieldValue VARCHAR(200) 
				,@SQL VARCHAR(1000)      
	     
	SELECT @DisplayOrder = -1
	WHILE (1 = 1)
	BEGIN
		SELECT @DisplayOrder = MIN(DisplayOrder)
		FROM   #tField
		WHERE  DisplayOrder > @DisplayOrder
		
		IF @DisplayOrder IS NULL
			BREAK
			
		SELECT @FieldName = FieldName
		FROM  #tField
		WHERE  DisplayOrder = @DisplayOrder

		/* Example of Statement to execute
		UPDATE #tFormGrid
		SET    #tFormGrid.Issue = CONVERT(VARCHAR(200), b.FieldValue)
		FROM   vFormSearch	    b (NOLOCK)
		WHERE  #tFormGrid.FormKey = b.FormKey
		AND    b.FieldName        = 'Issue'
		*/
		 	
		SELECT @SQL = 'UPDATE #tFormGrid '
		SELECT @SQL = @SQL + 'SET #tFormGrid.[' + @FieldName + '] = CONVERT(VARCHAR(200), b.FieldValue) '
		SELECT @SQL = @SQL + 'FROM   vFormSearch	    b (NOLOCK) '
		SELECT @SQL = @SQL + 'WHERE  #tFormGrid.FormKey = b.FormKey '
		SELECT @SQL = @SQL + 'AND    b.FieldName = '''+@FieldName+''''
		print @SQL
		EXEC (@SQL)
	
	END 
	
	--SELECT *  FROM #tFormGrid                
	                
	
	/* set nocount on */
	return 1


	-- Will need to be created by ASP page
	/*
	CREATE TABLE #tFormGrid (
								FormKey INT NULL
	              ,DateCreated DATETIME NULL
	              ,DateClosed DATETIME NULL
	              ,CustomFieldKey INT NULL
	              ,FormName VARCHAR(200) NULL
	              ,FormPrefix VARCHAR(50) NULL
	              ,FormNumber VARCHAR(50) NULL
	              ,Subject VARCHAR(200) NULL
	              ,ProjectName VARCHAR(200) NULL
	              
	              ,Issue VARCHAR(200) NULL
	              ,ReleaseVersion VARCHAR(200) NULL
	              ,GC_Name VARCHAR(200) NULL
	              ,GC_Store VARCHAR(200) NULL
	              ,RD_Names VARCHAR(200) NULL
	              ,RD_NumPeople VARCHAR(200) NULL
	              ,RD_ReachedAt VARCHAR(200) NULL
	              ,RD_TravelDates VARCHAR(200) NULL
	              ,MyFieldName VARCHAR(200) NULL
	              ,MyName VARCHAR(200) NULL
	              ,Quantity VARCHAR(200) NULL
	              ,RD_Location VARCHAR(200) NULL	         
              )
		
		INSERT #tFormGrid  (FormKey)
		SELECT FormKey
		FROM   tForm (NOLOCK)
		WHERE  CompanyKey = @CompanyKey
		ORDER BY FormKey
  	*/
GO

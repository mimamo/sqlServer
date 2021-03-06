USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFindExpenseType]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spFindExpenseType]
  	 @CompanyKey int
 	,@ItemID varchar(50) 
 	,@ItemKey int         
AS --Encrypt

  /*
  || When     Who Rel   What
  || 07/10/07 QMD 8.5   Expense Type reference changed to tItem
  */

 IF @ItemKey IS NULL
  BEGIN
     IF EXISTS(
                SELECT 1 
                FROM   tItem (NOLOCK)
                WHERE  CompanyKey = @CompanyKey 
	                   AND UPPER(ItemID) = UPPER(@ItemID)
               )
     RETURN -1
  END
 ELSE
  BEGIN
     IF EXISTS(
                SELECT 1 
                FROM   tItem (NOLOCK)
                WHERE  CompanyKey = @CompanyKey 
		               AND ItemKey <> @ItemKey 
		               AND UPPER(ItemID) = UPPER(@ItemID)
               ) 
     RETURN -1
  END

  RETURN 1
GO

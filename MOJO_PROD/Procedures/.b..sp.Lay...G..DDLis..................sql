USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptLayoutGetDDList]    Script Date: 12/10/2015 10:54:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptLayoutGetDDList]
	(
		@CompanyKey INT
		,@LayoutKey INT
		,@Entity varchar(50)
	)
AS

  /*
  || When     Who Rel    What
  || 03/24/10 GHL 10.521 Creation for Drop Downs 
  || 10/05/12 GHL 10.560 Added ShortName because some are 150 chars long 
  */

	SET NOCOUNT ON
	
	SELECT LayoutKey, LayoutName
	       ,substring(LayoutName, 1, 90) as ShortName
	FROM   tLayout (NOLOCK)
	WHERE  CompanyKey = @CompanyKey
	AND    (Active = 1
			OR
			LayoutKey = @LayoutKey)
	AND    (@Entity IS NULL
	        OR
	        UPPER(Entity) = UPPER(@Entity))
	ORDER BY LayoutName
	
	RETURN 1
GO

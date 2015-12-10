USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spSecurityGetRight]    Script Date: 12/10/2015 10:54:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSecurityGetRight]
 (
  @EntityType varchar(35),
  @EntityKey  int,
  @RightID    varchar(35)
 )
AS --Encrypt

/*
|| When     Who Rel   What
|| 11/26/07 GHL 8.5 Modification for SQL 2005
*/

 SELECT r.RightID
		, ISNULL((SELECT TOP 1 1 FROM tRightAssigned ra (NOLOCK)
			WHERE ra.RightKey = r.RightKey
			AND   UPPER(LTRIM(RTRIM(ra.EntityType))) = UPPER(LTRIM(RTRIM(@EntityType)))
			AND   ra.EntityKey   = EntityKey
            ), 0) AS Allowed
 FROM   tRight         r  (NOLOCK)			
 WHERE    UPPER(LTRIM(RTRIM(r.RightID))) = UPPER(LTRIM(RTRIM(@RightID)))
                 
              
 /* set nocount on */
 return 1
GO

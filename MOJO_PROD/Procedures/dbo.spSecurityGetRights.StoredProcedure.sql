USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spSecurityGetRights]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSecurityGetRights]
 (
  @EntityType varchar(35),
  @EntityKey  int = NULL,
  @RightGroup varchar(35) = NULL,
  @SetGroup varchar(35) = NULL,
  @UserKey int = 0
 )
AS --Encrypt
 
 /*
|| When     Who Rel   What
|| 11/26/07 GHL 8.5 Modification for SQL 2005
|| 3/1/2012 GWG 10.5.5.3  Added a restriction for right levels to allow for different level pricing
|| 6/3/2014 GWG 10.5.8.0  Added protection against a 0 security group key
*/

Declare @RightLevel int, @CompanyKey int

Select @RightLevel = ISNULL(RightLevel, 0), @CompanyKey = ISNULL(OwnerCompanyKey, CompanyKey) from tUser (nolock) Where UserKey = @UserKey


if @RightLevel = 0
BEGIN
  IF @RightGroup IS NULL
   SELECT r.*
          , ISNULL((SELECT TOP 1 1 FROM tRightAssigned ra (NOLOCK)
			WHERE ra.RightKey = r.RightKey
			AND   UPPER(LTRIM(RTRIM(ra.EntityType))) = UPPER(LTRIM(RTRIM(@EntityType)))
			AND   ra.EntityKey   = @EntityKey
			AND   ra.EntityKey > 0 --prevent against a 0 key
            ),0) AS Allowed
    FROM   tRight          r  (NOLOCK)
    WHERE  UPPER(LTRIM(RTRIM(r.SetGroup)))   = UPPER(LTRIM(RTRIM(@SetGroup)))
       
       
 ELSE
 
    SELECT r.*
          , ISNULL((SELECT TOP 1 1 FROM tRightAssigned ra (NOLOCK)
			WHERE ra.RightKey = r.RightKey
			AND   UPPER(LTRIM(RTRIM(ra.EntityType))) = UPPER(LTRIM(RTRIM(@EntityType)))
			AND   ra.EntityKey   = @EntityKey
			AND   ra.EntityKey > 0 --prevent against a 0 key
            ), 0) AS Allowed
    FROM   tRight          r  (NOLOCK)
    WHERE  UPPER(LTRIM(RTRIM(r.RightGroup))) = UPPER(LTRIM(RTRIM(@RightGroup)))
    AND    UPPER(LTRIM(RTRIM(r.SetGroup)))   = UPPER(LTRIM(RTRIM(@SetGroup)))
 END
 ELSE
 BEGIN
   IF @RightGroup IS NULL
   SELECT r.*
          , ISNULL((SELECT TOP 1 1 FROM tRightAssigned ra (NOLOCK)
			WHERE ra.RightKey = r.RightKey
			AND   UPPER(LTRIM(RTRIM(ra.EntityType))) = UPPER(LTRIM(RTRIM(@EntityType)))
			AND   ra.EntityKey   = @EntityKey
			AND   ra.EntityKey > 0 --prevent against a 0 key
            ),0) AS Allowed
    FROM   tRight          r  (NOLOCK)
		INNER JOIN tRightLevel rl (nolock) on r.RightKey = rl.RightKey

    WHERE  UPPER(LTRIM(RTRIM(r.SetGroup)))   = UPPER(LTRIM(RTRIM(@SetGroup)))
		AND rl.CompanyKey = @CompanyKey and rl.Level = @RightLevel
       
       
 ELSE
 
    SELECT r.*
          , ISNULL((SELECT TOP 1 1 FROM tRightAssigned ra (NOLOCK)
			WHERE ra.RightKey = r.RightKey
			AND   UPPER(LTRIM(RTRIM(ra.EntityType))) = UPPER(LTRIM(RTRIM(@EntityType)))
			AND   ra.EntityKey   = @EntityKey
			AND   ra.EntityKey > 0 --prevent against a 0 key
            ), 0) AS Allowed
    FROM   tRight          r  (NOLOCK)
		INNER JOIN tRightLevel rl (nolock) on r.RightKey = rl.RightKey
    WHERE  UPPER(LTRIM(RTRIM(r.RightGroup))) = UPPER(LTRIM(RTRIM(@RightGroup)))
    AND    UPPER(LTRIM(RTRIM(r.SetGroup)))   = UPPER(LTRIM(RTRIM(@SetGroup)))
	AND rl.CompanyKey = @CompanyKey and rl.Level = @RightLevel

 END


 /* set nocount on */
 return 1
GO

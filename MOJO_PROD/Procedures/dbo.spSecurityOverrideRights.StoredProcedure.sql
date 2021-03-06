USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spSecurityOverrideRights]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spSecurityOverrideRights]
 (
  @RightGroup varchar(35) = NULL,
  @SetGroup varchar(35)
 )
AS --Encrypt
 
 -- Filter out admin for now 
    IF @RightGroup IS NULL
   SELECT r.RightID
             ,1           AS Allowed
       FROM   tRight          r  (NOLOCK)
       WHERE  UPPER(LTRIM(RTRIM(r.SetGroup)))   = UPPER(LTRIM(RTRIM(@SetGroup)))
       
 ELSE
 
  SELECT r.RightID
    ,1 AS Allowed
       FROM   tRight          r  (NOLOCK)
       WHERE  UPPER(LTRIM(RTRIM(r.RightGroup))) = UPPER(LTRIM(RTRIM(@RightGroup)))
    AND    UPPER(LTRIM(RTRIM(r.SetGroup)))   = UPPER(LTRIM(RTRIM(@SetGroup)))
 
 return 1
GO

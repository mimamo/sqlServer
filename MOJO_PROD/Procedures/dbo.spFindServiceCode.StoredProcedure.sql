USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spFindServiceCode]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spFindServiceCode]
  @CompanyKey int
 ,@ServiceCode varchar(50)
 ,@ServiceKey int
AS --Encrypt
 IF @ServiceKey IS NULL
  BEGIN
  If EXISTS(
   Select 1 
   from
    tService (nolock)
   WHERE
    CompanyKey = @CompanyKey AND
    UPPER(ServiceCode) = UPPER(@ServiceCode)
   )
   return -1
  END
 ELSE
  BEGIN
  If EXISTS(
   Select 1 
   from
    tService (nolock)
   WHERE
    CompanyKey = @CompanyKey AND
    ServiceKey <> @ServiceKey AND
    UPPER(ServiceCode) = UPPER(@ServiceCode)
   )
   return -1
  END
 return 1
GO

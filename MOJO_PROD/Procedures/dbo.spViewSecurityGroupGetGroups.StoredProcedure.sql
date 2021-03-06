USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spViewSecurityGroupGetGroups]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spViewSecurityGroupGetGroups]
 (
  @CompanyKey int
    ,@ViewKey int
 )
AS --Encrypt
 SELECT sg.*
 FROM   tSecurityGroup sg (NOLOCK)
       ,tViewSecurityGroup rsg (NOLOCK)
 WHERE  rsg.ViewKey        = @ViewKey
 AND    rsg.SecurityGroupKey = sg.SecurityGroupKey 
 AND    sg.CompanyKey        = @CompanyKey 
 AND    sg.Active            = 1
 
 /* set nocount on */
 return
GO

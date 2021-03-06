USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spRptSecurityGroupGetGroups]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spRptSecurityGroupGetGroups]
 (
  @CompanyKey int
    ,@ReportKey int
 )
AS --Encrypt
 SELECT sg.*
 FROM   tSecurityGroup sg (NOLOCK)
       ,tRptSecurityGroup rsg (NOLOCK)
 WHERE  rsg.ReportKey        = @ReportKey
 AND    rsg.SecurityGroupKey = sg.SecurityGroupKey 
 AND    sg.CompanyKey        = @CompanyKey 
 AND    sg.Active            = 1
 
 /* set nocount on */
 return
GO

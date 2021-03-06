USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGetCompanyForTrans]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spGetCompanyForTrans]
 @TransmittalKey int
AS --Encrypt
 SELECT c.CompanyName, c.CompanyName as Name
 FROM tCompany c (nolock),
   tProject p (nolock),
   tTransmittal t (nolock)
 WHERE t.TransmittalKey =@TransmittalKey
 AND  t.ProjectKey  =p.ProjectKey   
 AND  p.CompanyKey  =c.CompanyKey
 
 RETURN 1
GO

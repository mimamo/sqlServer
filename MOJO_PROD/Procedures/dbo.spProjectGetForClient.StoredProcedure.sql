USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectGetForClient]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spProjectGetForClient]
 @InvoiceKey int
 
AS --Encrypt
 SELECT p.*,
	p.ProjectNumber + ' - ' + ProjectName as ProjectFullName
 FROM tProject p (NOLOCK),
   tInvoice i (NOLOCK)
 WHERE i.InvoiceKey = @InvoiceKey
 AND  i.ClientKey = p.ClientKey
 AND  p.Deleted = 0
GO

USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spInvoiceLineGet]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spInvoiceLineGet]
 @InvoiceKey int
 
AS --Encrypt

/*
|| When     Who Rel  What
|| 11/26/07 GHL 8.5 Switched to LEFT OUTER JOIN/INNER JOIN for SQL 2005
*/

 SELECT il.*,p.ProjectName
 FROM tInvoiceLine il (NOLOCK)
   LEFT OUTER JOIN tProject p (NOLOCK) ON il.ProjectKey = p.ProjectKey
 WHERE il.InvoiceKey = @InvoiceKey
GO

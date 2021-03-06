USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvInvoiceOpenAmountGetAging]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvInvoiceOpenAmountGetAging]
 (
  @LoggedCompanyKey INT 
 )
AS --Encrypt

  /*
  || When     Who Rel   What
  || 11/27/07 GHL 8.5   Removed alias in order by for SQL server 2005                      
  */
  
    SELECT
		i.InvoiceKey  
		,i.InvoiceNumber
        ,i.DueDate
        ,i.OpenAmount AS Amount
        ,CASE
            WHEN DATEDIFF(d, GETDATE(), i.DueDate) > 0 THEN 1
        ELSE 0
        END AS Col1       
        ,CASE
            WHEN DATEDIFF(d, i.DueDate, GETDATE()) > 90 THEN 1
        ELSE 0
		END AS Col5
        ,CASE
            WHEN DATEDIFF(d, i.DueDate, GETDATE()) >= 61 AND DATEDIFF(d, i.DueDate, GETDATE()) <= 90 THEN 1
        ELSE 0
		END AS Col4
        ,CASE
            WHEN DATEDIFF(d, i.DueDate, GETDATE()) >= 31 AND DATEDIFF(d, i.DueDate, GETDATE()) <= 60 THEN 1
        ELSE 0
		END AS Col3
        ,CASE
            WHEN DATEDIFF(d, i.DueDate, GETDATE()) >= 0 AND DATEDIFF(d, i.DueDate, GETDATE()) <= 30 THEN 1
        ELSE 0
		END AS Col2
        ,i.CompanyKey
        ,i.BCompanyName as CompanyName
 FROM	vInvoice i (nolock)
 WHERE  i.CompanyKey   = @LoggedCompanyKey
 AND    i.OpenAmount > 0.000   
 ORDER BY i.BCompanyName, i.DueDate
             
 RETURN 1
GO

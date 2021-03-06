USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepositGetReport]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepositGetReport]
	@DepositKey int

AS --Encrypt

		SELECT 
			d.*
			,gl.AccountNumber + ' ' + gl.AccountName as AccountName
			,Case Cleared When 1 then 'Cleared' else 'Open' end as ClearedText
			,ch.CheckDate
			,ch.CheckAmount
			,ch.ReferenceNumber
			,cm.CheckMethod
			,c.CompanyName
			,c.CustomerID
			,ch.Description
		FROM tDeposit d (nolock)
			Inner join tGLAccount gl (nolock) on d.GLAccountKey = gl.GLAccountKey
			inner join tCheck ch (nolock) on ch.DepositKey = d.DepositKey
			inner join tCompany c (nolock) on ch.ClientKey = c.CompanyKey
			left outer join tCheckMethod cm (nolock) on ch.CheckMethodKey = cm.CheckMethodKey
		WHERE
			d.DepositKey = @DepositKey
		Order By
			d.DepositKey, ch.CheckDate, c.CompanyName
GO

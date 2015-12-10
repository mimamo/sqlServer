USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepositGetSelectedList]    Script Date: 12/10/2015 10:54:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepositGetSelectedList]

	(
		@DepositKey int
	)

AS
	
	Select 
		ch.*,
		c.CustomerID,
		c.CompanyName
	From 
		tCheck ch (nolock)
		inner join tCompany c (nolock) on ch.ClientKey = c.CompanyKey
	Where
		ch.DepositKey = @DepositKey
GO

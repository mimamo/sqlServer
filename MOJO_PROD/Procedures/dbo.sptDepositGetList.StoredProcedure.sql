USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepositGetList]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepositGetList]

	@GLAccountKey int


AS --Encrypt

		SELECT *,
		ISNULL((Select sum(CheckAmount) from tCheck (nolock) Where DepositKey = tDeposit.DepositKey), 0) as Amount
		FROM tDeposit (nolock)
		WHERE
			GLAccountKey = @GLAccountKey
		Order By
			DepositDate DESC

	RETURN 1
GO

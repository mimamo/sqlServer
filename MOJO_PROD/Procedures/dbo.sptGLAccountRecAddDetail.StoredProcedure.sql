USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptGLAccountRecAddDetail]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptGLAccountRecAddDetail]
	@GLAccountRecKey int,
	@Type varchar(10),
	@Key int
AS

  /*
  || When     Who Rel     What
  || 01/07/09 GHL 10.016  (43640) Added CompanyKey when querying tTransaction 
  ||                       to improve performance
  || 10/18/11 MFT 10.549  Made exists check look for existence in any AccountRec, not just current; added error return
  || 11/16/11 MFT 10.549  Corrected existence check to account for 'D' type
  */

DECLARE @CompanyKey INT

SELECT @CompanyKey = CompanyKey
FROM   tGLAccountRec (NOLOCK)
WHERE  GLAccountRecKey = @GLAccountRecKey

if @Type = 'T'
	BEGIN
		if exists(
			Select 1 from tGLAccountRecDetail (nolock) 
			Where TransactionKey = @Key)
			RETURN -1
		
		Insert tGLAccountRecDetail (GLAccountRecKey, TransactionKey)
		Values (@GLAccountRecKey, @Key)
	END
else
	BEGIN
		if exists(
			SELECT
				t.TransactionKey
			FROM
				tDeposit d (nolock)
				INNER JOIN tCheck c (nolock)
					ON d.DepositKey = c.DepositKey
				INNER JOIN tTransaction t (nolock)
					ON c.CheckKey = t.EntityKey AND t.Entity = 'RECEIPT'
				INNER JOIN tGLAccountRecDetail ard (nolock)
					ON t.TransactionKey = ard.TransactionKey
			WHERE
				t.DepositKey = @Key)
			RETURN -1
		
		Insert tGLAccountRecDetail (GLAccountRecKey, TransactionKey)
		Select @GLAccountRecKey, TransactionKey 
		from tTransaction (nolock) 
		Where CompanyKey = @CompanyKey
			AND DepositKey = @Key
	END

RETURN 1
GO

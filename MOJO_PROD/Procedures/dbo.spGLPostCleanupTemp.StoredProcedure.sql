USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostCleanupTemp]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostCleanupTemp]
	(
		@Entity VARCHAR(50)
		,@EntityKey INT
		,@TransactionDate SMALLDATETIME -- This is GL transaction date
	)
AS --Encrypt

  /*
  || When     Who Rel    What
  || 06/18/07 GHL 8.5    Creation for new gl posting
  || 09/17/07 GHL 8.5    Added overhead
  || 08/05/13 GHL 10.570 Added multi currency data
  || 01/16/14 GHL 10.576 Modification to handle AR/AP adjustments due to Credits 
  || 07/17/14 GHL 10.582 (222243) Copy class from header to MC sections
  */  
  
	SET NOCOUNT ON
	
	Declare @DateCreated smalldatetime
			,@PostMonth int
			,@PostYear int
		
	Select	@PostMonth = cast(DatePart(mm, @TransactionDate) as int)
			,@PostYear = cast(DatePart(yyyy, @TransactionDate) as int)
			,@DateCreated = Cast(Cast(DatePart(mm,GETDATE()) as varchar) + '/' + Cast(DatePart(dd,GETDATE()) as varchar) + '/' + Cast(DatePart(yyyy,GETDATE()) as varchar) as smalldatetime)

	DECLARE @HeaderTempTranLineKey int
	DECLARE @HeaderClassKey int
	SELECT  @HeaderTempTranLineKey = min(TempTranLineKey)  from #tTransaction where Entity = @Entity and EntityKey = @EntityKey and [Section] = 1
	SELECT  @HeaderClassKey = ClassKey from #tTransaction where Entity = @Entity and EntityKey = @EntityKey and TempTranLineKey = @HeaderTempTranLineKey

	-- Correct data if needed 
	UPDATE #tTransaction
	SET		#tTransaction.PostMonth		= @PostMonth
		   ,#tTransaction.PostYear		= @PostYear
		   ,#tTransaction.DateCreated	= @DateCreated
	
		   ,#tTransaction.ClassKey		= CASE	WHEN #tTransaction.ClassKey = 0			THEN NULL ELSE #tTransaction.ClassKey		END
	  	   ,#tTransaction.OfficeKey		= CASE	WHEN #tTransaction.OfficeKey = 0		THEN NULL ELSE #tTransaction.OfficeKey		END
	  	   ,#tTransaction.DepartmentKey	= CASE	WHEN #tTransaction.DepartmentKey = 0	THEN NULL ELSE #tTransaction.DepartmentKey	END
	  	   ,#tTransaction.ProjectKey	= CASE	WHEN #tTransaction.ProjectKey = 0		THEN NULL ELSE #tTransaction.ProjectKey		END
	  	   ,#tTransaction.GLCompanyKey	= CASE	WHEN #tTransaction.GLCompanyKey = 0		THEN NULL ELSE #tTransaction.GLCompanyKey	END
		   ,#tTransaction.ClientKey		= CASE	WHEN #tTransaction.ClientKey = 0		THEN NULL ELSE #tTransaction.ClientKey		END
		   ,#tTransaction.SourceCompanyKey = CASE WHEN #tTransaction.SourceCompanyKey = 0 THEN NULL ELSE #tTransaction.SourceCompanyKey	END
		 
		   ,#tTransaction.Debit			= ROUND(#tTransaction.Debit, 2) -- this is what spGLInsertTran does
		   ,#tTransaction.Credit		= ROUND(#tTransaction.Credit, 2)
		   
		   ,#tTransaction.ExchangeRate  = ISNULL(#tTransaction.ExchangeRate, 1)
		   ,#tTransaction.HDebit		= ISNULL(#tTransaction.HDebit, ROUND(#tTransaction.Debit, 2)) -- this is what spGLInsertTran does
		   ,#tTransaction.HCredit		= ISNULL(#tTransaction.HCredit, ROUND(#tTransaction.Credit, 2))
		   
		   ,#tTransaction.GLValid		= 0	-- Prepare for GLAccount validation	   	
	WHERE	Entity = @Entity AND EntityKey = @EntityKey
	
	DELETE #tTransaction 
	WHERE ISNULL(Debit, 0) = 0 AND ISNULL(Credit, 0) = 0 
	AND   Entity = @Entity AND EntityKey = @EntityKey
	AND   [Section] NOT IN (1, 9, 10) -- Not Header, Rounding and Realized gain/loss

	DELETE #tTransaction 
	WHERE ISNULL(HDebit, 0) = 0 AND ISNULL(HCredit, 0) = 0 
	AND   Entity = @Entity AND EntityKey = @EntityKey
	AND   [Section] IN ( 9, 10) -- Rounding and Realized gain/loss

	-- copy class from header for MC rounding
	UPDATE #tTransaction
	SET    #tTransaction.ClassKey = @HeaderClassKey
	WHERE  #tTransaction.Entity = @Entity AND #tTransaction.EntityKey = @EntityKey
	AND    #tTransaction.[Section] = 9 -- MC Rounding 
	--AND    #tTransaction.[Section] IN ( 9, 10) -- MC Rounding and Realized gain/loss


	-- special case of the AR/AP where we could have credit AR/AP adjustments with Debit/Credit = 0/0 and HDebit/HCredit <> 0/0
	DELETE #tTransaction 
	WHERE ISNULL(HDebit, 0) = 0 AND ISNULL(HCredit, 0) = 0 AND ISNULL(Debit, 0) = 0 AND ISNULL(Credit, 0) = 0 
	AND   Entity = @Entity AND EntityKey = @EntityKey
	AND   [Section] = 1

	UPDATE #tTransaction
	SET    #tTransaction.Overhead = 1
	FROM   tCompany cl (NOLOCK) 
	WHERE  #tTransaction.ClientKey = cl.CompanyKey
	AND    ISNULL(cl.Overhead, 0) = 1	
	AND    #tTransaction.Entity = @Entity AND #tTransaction.EntityKey = @EntityKey
		
	RETURN 1
GO

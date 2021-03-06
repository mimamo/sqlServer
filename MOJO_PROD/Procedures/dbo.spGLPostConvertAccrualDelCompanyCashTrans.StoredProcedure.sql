USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spGLPostConvertAccrualDelCompanyCashTrans]    Script Date: 12/10/2015 12:30:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGLPostConvertAccrualDelCompanyCashTrans]
	(
	@CompanyKey int
	)
AS --Encrypt

	SET NOCOUNT ON
	 
	 begin tran
	 
	 delete tCashTransaction where CompanyKey = @CompanyKey
	 
	 if @@Error <> 0
	 begin
		rollback tran	
		return -1
	 end
	
	delete tCashConvert where CompanyKey = @CompanyKey
	 
	 if @@Error <> 0
	 begin
		rollback tran	
		return -1
	 end
		
	commit tran
			
	RETURN 1
GO

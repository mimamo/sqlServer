USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQBServiceInsert]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQBServiceInsert]
	@CompanyKey int,
	@ServiceCode varchar(50),
	@Description varchar(100),
	@HourlyRate1 money,
    @GLAccountLinkID varchar(100),
	@LinkID varchar(100)
	
	
AS --Encrypt

/*
|| When     Who Rel			What
|| 02/21/11 QMD 10.5.4.1	Updated parms for sptServiceInsert
*/


declare @RetVal int
declare @ServiceKey int
declare @GLAccountKey int


	select @GLAccountKey = GLAccountKey from tGLAccount (nolock) where LinkID = @GLAccountLinkID

	select @ServiceKey = ServiceKey
	  from tService (nolock)
	 where LinkID = @LinkID
	   and CompanyKey = @CompanyKey
	 
if @ServiceKey is null
  begin	  
	exec @RetVal = sptServiceInsert
	     @CompanyKey,
		 @ServiceCode,
		 @Description,
		 @HourlyRate1,
		 null,
		 null,
		 null,
		 null,
		 1,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 null,
		 @GLAccountKey,
		 null,
		 0,
		 0,
		 0,
		 @ServiceKey output


	if @RetVal < 0
		return -1
		
	update tService
	   set LinkID = @LinkID
	 where ServiceKey = @ServiceKey
	 
  end
else
	update tService
       set ServiceCode = @ServiceCode,
	       Description = @Description,
	       HourlyRate1 = @HourlyRate1,
           GLAccountKey = @GLAccountKey
	 where LinkID = @LinkID           
	
	return @ServiceKey
GO

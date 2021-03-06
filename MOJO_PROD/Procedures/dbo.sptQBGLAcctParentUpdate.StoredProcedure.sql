USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptQBGLAcctParentUpdate]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptQBGLAcctParentUpdate]
(	
	@CompanyKey int,
	@ChildLinkID varchar(100),
	@ParentLinkID varchar(100)
)

	
AS --Encrypt

declare @GLParentAccountKey int
declare @GLAccountKey int

	select @GLAccountKey = GLAccountKey 
	  from tGLAccount (nolock) 
     where CompanyKey = @CompanyKey 
	   and LinkID = @ChildLinkID
	if @GLAccountKey is null
		return -1
		
	select @GLParentAccountKey = GLAccountKey 
	  from tGLAccount (nolock) 
     where CompanyKey = @CompanyKey 
	   and LinkID = @ParentLinkID
	if @GLParentAccountKey is null
		return -2
		
	update tGLAccount
	   set Rollup = 1
	 where GLAccountKey = @GLParentAccountKey

	update tGLAccount
	   set ParentAccountKey = @GLParentAccountKey
	 where GLAccountKey = @GLAccountKey

	return 1
GO

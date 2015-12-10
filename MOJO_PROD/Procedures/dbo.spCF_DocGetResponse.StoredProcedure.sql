USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spCF_DocGetResponse]    Script Date: 12/10/2015 12:30:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spCF_DocGetResponse]

AS
	
	--insert new field sets
	select EntityKey
	      ,NewEntityKey
	      ,CustomFieldKey
	      ,NewCustomFieldKey
	      ,Action
	from #tCFDocSaveKeys
	where Action in ('insertEntity','insertOFS','deleteOFS')
							
	return 1
GO
